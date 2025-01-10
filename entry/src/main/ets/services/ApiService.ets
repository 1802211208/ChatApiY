import { http } from '@kit.NetworkKit';
import { ApifoxModel, ApiResponse, ApiResponseError, ChatMessage } from '../models/ApiModel';

export class ApiService {
  async chat(messages: ChatMessage[], config: ChatRequestConfig): Promise<string> {
    const httpRequest = http.createHttp();
    const requestBody: ApifoxModel = {
      model: config.modelId,
      messages: messages,
      max_tokens: config.maxTokens,
      temperature: config.temperature,
      presence_penalty: config.presencePenalty,
      frequency_penalty: config.frequencyPenalty,
      top_p: config.topP,
      stream: false,
    };
    const extraData = JSON.stringify(requestBody);

    try {
      const response = await httpRequest.request(config.apiUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${config.apiKey}`,
        },
        extraData: extraData,
        expectDataType: http.HttpDataType.OBJECT,
      });

      if (response.responseCode === 200) {
        const responseData = response.result as ApiResponse;
        return responseData.choices[0].message.content as string;
      } else {
        const responseData = response.result as ApiResponseError;
        return `请确认您的配置是否正确！${responseData.error.message},`;
      }
    } catch (error) {
      const errorStr = JSON.stringify(error);
      console.error('API请求失败:', errorStr);
      throw new Error(`HTTP错误: 请确认您的配置是否正确！ ${errorStr}`);
    } finally {
      httpRequest.destroy();
    }
  }
}


export interface ChatRequestConfig {
  apiKey: string;
  apiUrl: string;
  modelId: string;
  maxTokens: number;
  temperature: number;
  presencePenalty: number;
  frequencyPenalty: number;
  topP: number;
}

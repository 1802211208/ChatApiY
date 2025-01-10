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

  /**
   * 流式响应，元服务不支持
   * @param messages
   * @param config
   * @param onMessage
   * @returns
   */
  // async chatStream(
  //   messages: ChatMessage[],
  //   config: ChatRequestConfig,
  //   onMessage: (content: string) => void
  // ): Promise<void> {
  //   const httpRequest = http.createHttp();
  //   const requestBody: ApifoxModel = {
  //     model: config.modelId,
  //     messages: messages,
  //     max_tokens: config.maxTokens,
  //     temperature: config.temperature,
  //     presence_penalty: config.presencePenalty,
  //     frequency_penalty: config.frequencyPenalty,
  //     top_p: config.topP,
  //     stream: true,
  //   };
  //
  //   const streamInfo: http.HttpRequestOptions = {
  //     method: http.RequestMethod.POST,
  //     header: {
  //       'Content-Type': 'application/json',
  //       'Authorization': `Bearer ${config.apiKey}`,
  //       'Accept': 'text/event-stream',
  //     },
  //     extraData: JSON.stringify(requestBody),
  //     expectDataType: http.HttpDataType.STRING,
  //     connectTimeout: 60000,
  //     readTimeout: 60000,
  //   };
  //
  //   try {
  //     // 创建缓冲区存储未完成的数据块
  //     let buffer = '';
  //
  //     // 监听流式响应事件
  //     httpRequest.on('dataReceive', (data: ArrayBuffer) => {
  //
  //       const textDecoder = util.TextDecoder.create('utf-8');
  //       const chunk = textDecoder.decodeToString(new Uint8Array(data));
  //
  //       // const chunk = this.arrayBufferToString(data);
  //       buffer += chunk;
  //
  //       // 处理缓冲区中的数据
  //       const chunks = buffer.split('\n\n');
  //       for (let i = 0; i < chunks.length - 1; i++) {
  //         const line = chunks[i];
  //         if (line.startsWith('data: ') && line !== 'data: [DONE]') {
  //           try {
  //             const jsonStr = line.substring(6).trim(); // 去掉 'data: ' 前缀
  //             const streamChunk = JSON.parse(jsonStr) as StreamChunk;
  //             const content = streamChunk.choices[0]?.delta?.content;
  //             if (content) {
  //               onMessage(content); // 逐步传递数据
  //             }
  //           } catch (e) {
  //             console.error('解析流式响应出错:', e);
  //           }
  //         }
  //       }
  //
  //       // 保留最后一个未完成的块
  //       buffer = chunks[chunks.length - 1];
  //     });
  //
  //     // 监听流式响应结束事件
  //     httpRequest.on('dataEnd', () => {
  //       console.info('流式响应数据接收完毕');
  //     });
  //
  //     // 发送请求
  //     await httpRequest.requestInStream(config.apiUrl, streamInfo);
  //   } catch (error) {
  //     console.error('流式API请求失败:', error);
  //     throw error as Error;
  //   } finally {
  //     httpRequest.off('dataReceive');
  //     httpRequest.off('dataEnd');
  //     httpRequest.destroy();
  //   }
  // }


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

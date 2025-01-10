import { ChatMessage, MessageContent } from '../models/ApiModel';
import { ApiService, ChatRequestConfig } from './ApiService';
import { ConfigService } from './ConfigService';
import { ChatConfig, DEFAULT_CONFIG } from '../models/ConfigModel';

export class MessageService {
  private apiService: ApiService = new ApiService();
  private configService: ConfigService = ConfigService.getInstance();
  private currentConfig: ChatConfig = DEFAULT_CONFIG;
  private currentModel: string = '';
  private initPromise: Promise<void>;

  constructor() {
    // 使用Promise确保初始化完成
    this.initPromise = this.initialize();
  }

  private async initialize(): Promise<void> {
    try {
      await this.loadConfig();
    } catch (error) {
      console.error('MessageService初始化失败:', error);
      throw error as Error;
    }
  }

  private async loadConfig() {
    this.currentConfig = await this.configService.getConfig();
  }

  // 确保在调用任何方法前配置已加载完成
  private async ensureInitialized() {
    await this.initPromise;
  }


  async setModel(modelId: string): Promise<void> {
    await this.ensureInitialized();
    this.currentModel = modelId;
  }
  getCurrModel():string{
    return this.currentModel;
  }

  async updateConfig(config: ChatConfig): Promise<void> {
    await this.ensureInitialized();
    this.currentConfig = config;
  }

  async getAvailableModels(): Promise<string[]> {
    await this.ensureInitialized();
    return this.currentConfig.models;
  }

  async sendMessage(messages: ChatMessage[],hasImg:boolean): Promise<ChatMessage> {
    await this.ensureInitialized();
    try {
      const chatConfig: ChatRequestConfig = {
        apiKey: this.currentConfig.apiKey,
        apiUrl: this.currentConfig.apiUrl,
        modelId: this.currentModel,
        maxTokens: this.currentConfig.maxTokens,
        temperature: this.currentConfig.temperature,
        presencePenalty: this.currentConfig.presencePenalty,
        frequencyPenalty: this.currentConfig.frequencyPenalty,
        topP: this.currentConfig.topP
      };

      const aiResponse = await this.apiService.chat(messages, chatConfig);
      
      return {
        role: 'assistant',
        content: aiResponse
      };
    } catch (error) {
      console.error('消息处理失败:', error);
      if(hasImg){
        return {
          role: 'assistant',
          content: "抱歉，响应出现错误，请确认当前模型是否支持图片分析：" + error
        };
      }else{
        return {
          role: 'assistant',
          content: "抱歉，响应出现错误：" + error
        };
      }

    }
  }

  // async sendMessageWithImage(text: string, imageBase64: string): Promise<ChatMessage> {
  //   await this.ensureInitialized();
  //   const message: ChatMessage = {
  //     role: 'user',
  //     content: [
  //       {
  //         type: 'text',
  //         text: text
  //       },
  //       {
  //         type: 'image_url',
  //         image_url: {
  //           url: `data:image/jpeg;base64,${imageBase64}`
  //         }
  //       }
  //     ]
  //   };
  //
  //   try {
  //     const chatConfig: ChatRequestConfig = {
  //       apiKey: this.currentConfig.apiKey,
  //       apiUrl: this.currentConfig.apiUrl,
  //       modelId: this.currentModel,
  //       maxTokens: this.currentConfig.maxTokens,
  //       temperature: this.currentConfig.temperature,
  //       presencePenalty: this.currentConfig.presencePenalty,
  //       frequencyPenalty: this.currentConfig.frequencyPenalty,
  //       topP: this.currentConfig.topP
  //     };
  //
  //     const aiResponse = await this.apiService.chat([message], chatConfig);
  //     return {
  //       role: 'assistant',
  //       content: aiResponse
  //     };
  //   } catch (error) {
  //     console.error('图片消息处理失败:', error);
  //     return {
  //       role: 'assistant',
  //       content: "抱歉，处理图片时出现错误：" + error
  //     };
  //   }
  // }

  isMultipartMessage(content: string | MessageContent[]): boolean {
    return Array.isArray(content);
  }

}

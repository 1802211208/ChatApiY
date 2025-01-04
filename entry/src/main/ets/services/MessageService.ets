import { ChatMessage } from '../models/ApiModel';
import { ApiService, ChatRequestConfig } from './ApiService';
import { ConfigService } from './ConfigService';
import { ChatConfig, DEFAULT_CONFIG } from '../models/ConfigModel';

export class MessageService {
  private apiService: ApiService = new ApiService();
  private configService: ConfigService = ConfigService.getInstance();
  private currentConfig: ChatConfig = DEFAULT_CONFIG;
  private currentModel: string = 'gpt-4o-mini';
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

  async updateConfig(config: ChatConfig): Promise<void> {
    await this.ensureInitialized();
    this.currentConfig = config;
  }

  async getAvailableModels(): Promise<string[]> {
    await this.ensureInitialized();
    return this.currentConfig.models;
  }

  async sendMessage(messages: ChatMessage[]): Promise<ChatMessage> {
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
      return {
        role: 'assistant',
        content: "抱歉，响应出现错误：" + error
      };
    }
  }

}

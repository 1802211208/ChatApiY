export class ChatConfig {
  apiKey: string;
  apiUrl: string;
  maxTokens: number; //【最大回复 Max_tokens】设置Ai最大回复内容大小,会影响返回结果的长度。普通聊天建议500-800；短文生成建议800-2000；代码生成建议2000-3600；长文生成建议切换模型到4000左右(或选择长回复模型)
  temperature: number; //【随机属性 Temperature】默认值为 1，值越大，回复内容越赋有多样性、创造性、随机性；设为0-根据事实回答，希望得到事实答案应该降低该参数；日常聊天建议0.5-0.8。
  presencePenalty: number; //【话题属性 Presence_penalty】默认值为 0，值越大，越能够让Ai更好地控制新话题的引入，建议微调或不变。
  frequencyPenalty: number; //【重复属性 Frequency_penalty】默认值为 0，值越大，越能够让Ai更好地避免重复之前说过的话，建议微调或不变。
  topP: number; //【词汇属性 Top_p】默认值为 1，值越小，Ai生成的内容越单调，也越容易理解；值越大，Ai回复的词汇围越大，越多样化。（与随机属性二选一）
  models: string[];

  constructor(
    apiKey: string = '',
    apiUrl: string = 'https://api.deepseek.com/v1/chat/completions',
    maxTokens: number = 1688,
    temperature: number = 0.5,
    presencePenalty: number = 0,
    frequencyPenalty: number = 0,
    topP: number = 1,
    models: string[] = ['deepseek-chat','gpt-4o-mini','gpt-4o','claude-3-5-sonnet-20241022']
  ) {
    this.apiKey = apiKey;
    this.apiUrl = apiUrl;
    this.maxTokens = maxTokens;
    this.temperature = temperature;
    this.presencePenalty = presencePenalty;
    this.frequencyPenalty = frequencyPenalty;
    this.topP = topP;
    this.models = models;
  }

  // 创建配置副本
  clone(): ChatConfig {
    return new ChatConfig(
      this.apiKey,
      this.apiUrl,
      this.maxTokens,
      this.temperature,
      this.presencePenalty,
      this.frequencyPenalty,
      this.topP,
      this.models
    );
  }

  // 验证配置有效性
  validate(): boolean {
    return (
      this.apiKey?.length > 0 &&
        this.apiUrl?.length > 0 &&
        this.maxTokens > 0 &&
        this.temperature >= 0 && this.temperature <= 2 &&
        this.presencePenalty >= -2 && this.presencePenalty <= 2 &&
        this.frequencyPenalty >= -2 && this.frequencyPenalty <= 2 &&
        this.topP >= 0 && this.topP <= 1
    );
  }
}

// 默认配置实例
export const DEFAULT_CONFIG = new ChatConfig();

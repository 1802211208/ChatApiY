import dataPreferences from '@ohos.data.preferences';
import { ChatConfig, DEFAULT_CONFIG } from '../models/ConfigModel';

export class ConfigService {
  private static instance: ConfigService;
  private static readonly PREFERENCES_NAME = 'chat_config';
  private static readonly CONFIG_KEY = 'app_config';
  private preferences?: dataPreferences.Preferences;
  private initPromise?: Promise<void>;

  private constructor() {}

  public static getInstance(): ConfigService {
    if (!ConfigService.instance) {
      ConfigService.instance = new ConfigService();
    }
    return ConfigService.instance;
  }

  private async initialize(): Promise<void> {
    if (!this.initPromise) {
      this.initPromise = new Promise<void>(async (resolve, reject) => {
        try {
          const context = getContext(this);
          this.preferences = await dataPreferences.getPreferences(context, ConfigService.PREFERENCES_NAME);
          resolve();
        } catch (error) {
          console.error('初始化失败:', error);
          reject(error);
        }
      });
    }
    return this.initPromise;
  }

  async getConfig(): Promise<ChatConfig> {
    try {
      await this.initialize();
      if (!this.preferences) {
        console.error('preferences未初始化');
        return DEFAULT_CONFIG;
      }
      
      const configStr = await this.preferences.get(ConfigService.CONFIG_KEY, JSON.stringify(DEFAULT_CONFIG));
      return JSON.parse(configStr as string);
    } catch (error) {
      console.error('获取配置失败:', error);
      return DEFAULT_CONFIG;
    }
  }

  async saveConfig(config: ChatConfig): Promise<void> {
    try {
      await this.initialize();
      if (!this.preferences) {
        throw new Error('preferences未初始化');
      }
      
      await this.preferences.put(ConfigService.CONFIG_KEY, JSON.stringify(config));
      await this.preferences.flush();
    } catch (error) {
      console.error('保存配置失败:', error);
      throw error as Error;
    }
  }
}

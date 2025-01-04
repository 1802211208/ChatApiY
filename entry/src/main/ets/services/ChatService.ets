import { Chat } from '../models/ApiModel';
import dataPreferences from '@ohos.data.preferences';
import { intl } from '@kit.LocalizationKit';

export class ChatService {
  private static instance: ChatService;
  private static readonly PREFERENCES_NAME = 'chat_data';
  private static readonly CHATS_KEY = 'chats';
  private preferences?: dataPreferences.Preferences;
  private dateFormat = new intl.DateTimeFormat('zh-CN', {
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });

  private constructor() {
  }

  public static getInstance(): ChatService {
    if (!ChatService.instance) {
      ChatService.instance = new ChatService();
    }
    return ChatService.instance;
  }

  private async initialize(): Promise<void> {
    if (!this.preferences) {
      const context = getContext(this);
      this.preferences = await dataPreferences.getPreferences(context, ChatService.PREFERENCES_NAME);
    }
  }

  async createChat(): Promise<Chat> {


    const newChat: Chat = {
      id: new Date().getTime().toString(),
      title: this.dateFormat.format(new Date()),
      createTime: Date.now(),
      updateTime: Date.now(),
      messages: []
    };

    await this.saveChat(newChat);
    return newChat;
  }

  async getAllChats(): Promise<Chat[]> {
    await this.initialize();
    const chatsStr = await this.preferences?.get(ChatService.CHATS_KEY, '[]');
    return JSON.parse(chatsStr as string);
  }

  async getChat(chatId: string): Promise<Chat | null> {
    const chats = await this.getAllChats();
    const chat = chats.find(chat => chat.id === chatId);
    if (chat == undefined) {
      return null;
    }
    return chat;
  }

  async saveChat(chat: Chat): Promise<void> {
    await this.initialize();
    const chats = await this.getAllChats();
    const index = chats.findIndex(c => c.id === chat.id);

    if (index >= 0) {
      chats.splice(index, 1);  // 删除旧的
      chats.unshift(chat);     // 插入到开头
    } else {
      chats.unshift(chat);     // 新chat直接插入到开头
    }

    await this.preferences?.put(ChatService.CHATS_KEY, JSON.stringify(chats));
    await this.preferences?.flush();
  }

  async deleteChat(chatId: string): Promise<void> {
    try {
      const chats = await this.getAllChats();
      const updatedChats = chats.filter(chat => chat.id !== chatId);
      await this.preferences?.put('chats', JSON.stringify(updatedChats));
      await this.preferences?.flush();
    } catch (error) {
      console.error('删除聊天失败:', error);
      throw error as Error;
    }
  }

  async deleteAllChats(): Promise<void> {
    try {
      await this.preferences?.put('chats', JSON.stringify([]));
      await this.preferences?.flush();
    } catch (error) {
      console.error('清除所有聊天失败:', error);
      throw error as Error;
    }
  }

  async updateChatTitle(chatId: string, title: string): Promise<void> {
    const chat = await this.getChat(chatId);
    if (chat) {
      chat.title = title;
      chat.updateTime = Date.now();
      await this.saveChat(chat);
    }
  }
}

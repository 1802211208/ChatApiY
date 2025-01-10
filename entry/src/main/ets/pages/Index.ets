import router from '@ohos.router';
import { Chat } from '../models/ApiModel';
import { ChatService } from '../services/ChatService';
import { AppRoutes } from '../common/AppRoutes';
import { Profile } from './Profile';
import { ChatConfig } from '../models/ConfigModel';
import { ConfigService } from '../services/ConfigService';

@Entry
@Component
struct Index {
  @State chats: Chat[] = [];
  @State currentIndex: number = 0;
  private chatService: ChatService = ChatService.getInstance();
  private configService: ConfigService = ConfigService.getInstance();
  private controller: TabsController = new TabsController();

  // 添加配置检查方法
  private async checkConfig(): Promise<boolean> {
    try {
      const config: ChatConfig = await this.configService.getConfig();
      if (!config.apiKey || !config.apiUrl || config.models.length === 0) {
        AlertDialog.show({
          title: '配置缺失',
          message: '请先完成API配置并添加可用模型',
          confirm: {
            value: '去配置',
            action: () => {
              router.pushUrl({ url: AppRoutes.Settings });
            }
          }
        });
        return false;
      }
      return true;
    } catch (error) {
      console.error('配置检查失败:', error);
      return false;
    }
  }

  aboutToAppear() {
    this.loadChats();
  }

  onPageShow() {
    // 页面重新显示时刷新列表
    this.loadChats();
  }

  async loadChats() {
    this.chats = await this.chatService.getAllChats();
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
      TabContent() {
        Column() {
          // 标题栏
          Row() {
            Button() {
              Image($r('app.media.ic_add'))
                .width(24)
                .height(24)
            }
            .backgroundColor(Color.Transparent)
            .margin({ right: 15 })

            Text('聊天')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .align(Alignment.Start)
          .height(56)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#FFFFFF')
          .onClick(async () => {
            if (await this.checkConfig()) {
              const newChat = await this.chatService.createChat();
              router.pushUrl({
                url: 'pages/Chat',
                params: { param: newChat.id }
              });
            }
          })

          // 会话列表
          List() {
            ForEach(this.chats, (chat: Chat) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(chat.title)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium)
                    Text(chat.lastMessage || '暂无消息')
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .fontSize(14)
                      .fontColor('#666666')
                      .margin({ top: 4 })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Blank()

                  Text(new Date(chat.updateTime).toLocaleDateString())
                    .fontSize(12)
                    .fontColor('#999999')
                }
                .width('100%')
                .padding(16)
                .backgroundColor(Color.White)
                .onClick(async () => {
                  if (await this.checkConfig()) {
                    router.pushUrl({
                      url: 'pages/Chat',
                      params: { param: chat.id }
                    });
                  }
                })
              }
              .swipeAction({ end: this.DeleteButton(chat.id) })
            })
          }
          .edgeEffect(EdgeEffect.Spring,{alwaysEnabled:true})
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 1, color: '#F5F5F5' })
        }
      }
      .tabBar(this.TabBuilder('聊天', 0, $r('app.media.ic_chat'), $r('app.media.ic_chat_selected')))

      TabContent() {
        Profile()
      }
      .tabBar(this.TabBuilder('我的', 1, $r('app.media.ic_profile'), $r('app.media.ic_profile_selected')))
    }
    .scrollable(false)
    .onChange((index: number) => {
      if(index ==0){
        this.loadChats();
      }
      this.currentIndex = index;
    })
  }

  @Builder
  TabBuilder(title: string, index: number, normalImg: Resource, selectedImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectedImg : normalImg)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex === index ? '#8a8a8a' : '#bfbfbf')
        .margin({ top: 4 })
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.Center)
  }

  // 修改删除按钮的实现
  @Builder
  DeleteButton(chatId: string) {
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.ic_delete'))
        .width(24)
        .height(24)
    }
    .padding(10)
    .margin({left:10,right:10})
    .backgroundColor('#c12c1f')
    .onClick(async () => {
      await this.chatService.deleteChat(chatId);
      this.loadChats();
    })

  }
}


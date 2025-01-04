import { ChatMessage } from '../models/ApiModel';

@Entry
@Component
struct TestPage {
  @State messageList: Array<ChatMessage> = [];
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      // 聊天消息列表
      List({ scroller: this.scroller, space: 10 }) {
        ForEach(this.messageList, (msg: ChatMessage) => {
          ListItem() {
            Row() {
              Text(msg.content)
            }
            .width('100%')
            .padding({ left: 12, right: 12 });
          }
        });
      }

      Button('发送')
        .margin({ left: 8 })
        .height(40)
        .backgroundColor('#007AFF')
        .borderRadius(20)
        .onClick(() => {
          const userMessage: ChatMessage = {
            content: '11111',
            role: 'user'
          };

          // 更新UI
          this.messageList.push({
            content: userMessage.content,
            role: userMessage.role
          });
        });
      Button('修改')
        .margin({ left: 8 })
        .height(40)
        .backgroundColor('#007AFF')
        .borderRadius(20)
        .onClick(async () => {
          for (let index = 0; index < 100; index++) {
            this.messageList[this.messageList.length - 1] = {
              content: '222222' + index,
              role: 'assistant'
            } as ChatMessage;

            // 等待一段时间以使 UI 有机会逐步更新
          }
        });
    }.height('100%')

  }
}
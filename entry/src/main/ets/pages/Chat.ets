import { KeyboardAvoidMode, router, window } from '@kit.ArkUI';
import { MessageService } from '../services/MessageService';
import { ChatService } from '../services/ChatService';
import { KeyboardUtils } from '../utils/KeyboardUtils';
import { Chat, ChatMessage, MessageContent } from '../models/ApiModel';
import { SelectOption } from '../models/UIModel';
import { OneParams } from '../models/TempParamsModel';
import { ImageUtils } from '../utils/ImageUtils';

@Entry
@Component
struct ChatPage {
  @State messageList: Array<ChatMessage> = [];
  @State inputMessage: string = '';
  @State isLoading: boolean = false;
  @State modelOptions: SelectOption[] = [];
  @State selectedModelIndex: number = 0;
  @State chat: Chat | null = null;
  private scroller: Scroller = new Scroller();
  private messageService: MessageService = new MessageService();
  private chatId: string = (router.getParams() as OneParams).param;
  private chatService: ChatService = ChatService.getInstance();
  @State screenHeight: number = 0;
  @State isKeyBoardHidden: boolean = false;
  @State currentBase64img: string = '';

  async loadChat() {
    if (this.chatId) {
      this.chat = await this.chatService.getChat(this.chatId);
      if (this.chat) {
        // 显式创建新的消息对象数组
        this.messageList = this.chat.messages.map(msg => {
          const message: ChatMessage = {
            content: msg.content,
            role: msg.role
          };
          return message;
        });
        // 延迟滚动到底部，确保列表已渲染
        setTimeout(() => {
          this.scrollToBottom();
        }, 100);
      }
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ right: 16 })
          .onClick(() => router.back())
        Select(this.modelOptions)
          .selected(this.selectedModelIndex)
          .value(this.modelOptions[this.selectedModelIndex]?.value ?? '')
          .font({ size: 12 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 12, weight: 400 })
          .optionFont({ size: 12, weight: 400 })
          .onSelect((index: number) => {
            this.selectedModelIndex = index;
            const selectedModel = this.modelOptions[index].value as string;
            this.messageService.setModel(selectedModel);
          })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .zIndex(-10)

      // 聊天消息列表
      List({ scroller: this.scroller, space: 10 }) {
        ForEach(this.messageList, (msg: ChatMessage) => {
          ListItem() {
            Row() {
              if (msg.role === 'user') {
                Blank();
                this.MessageBubble(msg.content, msg.role === 'user');
              } else {
                this.MessageBubble(msg.content, msg.role === 'user');
                Blank();
              }
            }
            .width('100%')
            .padding({ left: 12, right: 12 });
          }
        });

        if (this.isLoading)
        ListItem() {
          Row() {
            this.MessageBubble("正在思考...", false);
            Blank();
          }
          .width('100%')
          .padding({ left: 12, right: 12 });
        }
      }
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .padding({ top: 10, bottom: 10 })
      .layoutWeight(1)
      .width('100%')
      .backgroundColor("#9aa7b1")
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          // 点击列表时收起键盘
          this.dismissKeyboard();
        }
      })
      .zIndex(-10)

      // 底部输入区域
      Column() {

        if (this.currentBase64img) {
          Image(this.currentBase64img)
            .height(50)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 10 })

        }
        Row() {
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r('app.media.ic_gallery'))
              .width(24)
              .height(24)
          }
          .width(40)
          .height(40)
          .backgroundColor('#007AFF')
          .margin({ right: 8 })
          .onClick(async () => {
            try {
              this.currentBase64img = await ImageUtils.getPictureFromAlbumWithBase64();
            } catch (error) {
              console.error('图片处理失败:', error);
              // 可以添加错误提示
            }
          })

          TextArea({ placeholder: '请输入消息...', text: this.inputMessage })
            .layoutWeight(1)
            .backgroundColor('#F5F5F5')
            .borderRadius(20)
            .padding({ left: 12, right: 12 })
            .onChange((value: string) => {
              this.inputMessage = value;
            })
            .enterKeyType(EnterKeyType.Send)
            .onSubmit(() => {
              this.sendMessage();
            })

          Button('发送')
            .margin({ left: 8 })
            .height(40)
            .backgroundColor('#007AFF')
            .borderRadius(20)
            .onClick(() => {
              this.sendMessage();
            });
        }
        .width('100%')

      }.alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding(12)
      .backgroundColor(Color.White)

      // .onAreaChange((oldValue: Area, newValue: Area) => {
      //   let oldY = oldValue.position.y as number;
      //   let newY = newValue.position.y as number;
      //   if (oldY > newY) {
      //     this.scrollToBottom();
      //   }
      // })
    }
    .height(this.screenHeight) // 动态设置可视区域高度
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .width('100%')
    // top数值与状态栏区域高度保持一致；bottom数值与导航条区域高度保持一致
    .backgroundColor('#EDEDED');
  }

  @Builder
  MessageBubble(content: string | MessageContent[], isUser: boolean) {
    if (typeof content === 'string') {
      Text(content)
        .copyOption(CopyOptions.LocalDevice)
        .fontSize(16)
        .padding(12)
        .backgroundColor(isUser ? '#007AFF' : Color.White)
        .foregroundColor(isUser ? Color.White : Color.Black)
        .borderRadius(12)
    } else {
      Column() {
        ForEach(content, (item: MessageContent) => {
          if (item.type === 'text') {
            Text(item.text)
              .fontSize(16)
              .fontColor(isUser ? Color.White : Color.Black)
          } else if (item.type === 'image_url') {
            Image(item.image_url!.url)
              .height('160')
              .width('auto') // 宽度设置为自动，以保持比例
              .margin({top:12})
              .objectFit(ImageFit.Contain)
              .borderRadius(12)
          }
        })
      }
      .alignItems(isUser?HorizontalAlign.End:HorizontalAlign.Start)
      .padding(12)
      .backgroundColor(isUser ? '#007AFF' : Color.White)
      .foregroundColor(isUser ? Color.White : Color.Black)
      .borderRadius(12)
    }
  }

  private dismissKeyboard(): void {
    KeyboardUtils.dismissKeyboard(this.getUIContext());
  }

  private async sendMessage(): Promise<void> {
    if (this.inputMessage.trim() !== '') {


      const userMessage: ChatMessage = {
        content: this.inputMessage,
        role: 'user'
      };

      if (this.currentBase64img) {
        userMessage.content = [
          {
            type: "text",
            text: this.inputMessage
          }, {
          type: "image_url",
          image_url: {
            url: this.currentBase64img
          }
        }
        ]
      }

      // 更新UI
      this.messageList.push({
        content: userMessage.content,
        role: userMessage.role
      });

      // 保存消息到聊天记录
      if (this.chat) {
        this.chat.messages.push({
          content: userMessage.content,
          role: userMessage.role
        });
        this.chat.lastMessage = this.inputMessage.substring(0, 20);
        this.chat.updateTime = Date.now();
        await this.chatService.saveChat(this.chat);
      }
      this.inputMessage = '';
      this.currentBase64img = '';
      this.dismissKeyboard();
      this.scrollToBottom();
      this.isLoading = true;

      // this.messageList.push({
      //   content: '正在思考...',
      //   role: 'assistant'
      // });

      try {
        // 发送消息并获取响应
        const aiMessage = await this.messageService.sendMessage(this.messageList);

        // this.messageList[this.messageList.length - 1] = {
        //   content: aiMessage.content,
        //   role: aiMessage.role
        // } as ChatMessage

        this.messageList.push({
          content: aiMessage.content,
          role: aiMessage.role
        });


        if (this.chat) {
          this.chat.messages.push({
            content: aiMessage.content,
            role: aiMessage.role
          });
          const content = aiMessage.content as string;
          this.chat.lastMessage = content.substring(0, 20);
          this.chat.updateTime = Date.now();
          await this.chatService.saveChat(this.chat);
        }
        this.scrollToBottom();
      } finally {
        this.isLoading = false;
      }
    }
  }

  private scrollToBottom(): void {
    // this.scroller.scrollToIndex(this.messageList.length - 1);
    this.scroller.scrollEdge(Edge.Bottom)
  }

  async aboutToAppear() {
    this.loadChat();
    // 获取可用模型列表
    try {
      const models = await this.messageService.getAvailableModels();
      // 使用SelectOption类创建选项
      this.modelOptions = models.map(model => new SelectOption(model));

      if (this.modelOptions.length > 0) {
        this.selectedModelIndex = 0;
        this.messageService.setModel(this.modelOptions[0].value);
      }
    } catch (error) {
      console.error('获取模型列表失败:', error);
    }

    window.getLastWindow(getContext(this)).then(currentWindow => {
      let property = currentWindow.getWindowProperties();
      let avoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      let avoidAreaNAVIGATION = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      // 初始化显示区域高度
      this.screenHeight = px2vp(property.windowRect.height - avoidArea.topRect.height - avoidArea.bottomRect.height-avoidAreaNAVIGATION.bottomRect.height);
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {
          return;
        }
        if (data.area.bottomRect.height <= 0) {
          this.isKeyBoardHidden = true;
          this.screenHeight = px2vp(property.windowRect.height - avoidArea.topRect.height - data.area.bottomRect.height-avoidAreaNAVIGATION.bottomRect.height);
        } else {
          this.isKeyBoardHidden = false;
          this.screenHeight = px2vp(property.windowRect.height - avoidArea.topRect.height - data.area.bottomRect.height);
          this.scrollToBottom();
        }
      })
    })


    // KeyboardUtils.setKeyboardAvoidMode(this.getUIContext(), KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear(): void {
    // KeyboardUtils.setKeyboardAvoidMode(this.getUIContext(), KeyboardAvoidMode.OFFSET);
  }
}



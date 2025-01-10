import router from '@ohos.router';
import { AppRoutes } from '../common/AppRoutes';
import { ChatService } from '../services/ChatService';

@Component
export struct Profile {
  @State isShowDialog: boolean = false;
  private chatService: ChatService = ChatService.getInstance();

  build() {

    Column() {
      // 标题栏
      Row() {
        Text('我的')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 设置列表
          List() {
            ListItem() {
              this.SettingItem('使用教程', () => {
                router.pushUrl({ url: AppRoutes.Tutorial });
              })
            }

            ListItem() {
              this.SettingItem('模型设置', () => {
                router.pushUrl({ url: AppRoutes.Settings });
              })
            }

            ListItem() {
              this.SettingItem('关于我们', () => {
                router.pushUrl({ url: AppRoutes.About });
              })
            }

            ListItem() {
              this.SettingItem('问题反馈', () => {
                router.pushUrl({ url: AppRoutes.Report });
              })
            }
          }
          .divider({ strokeWidth: 1, color: '#F5F5F5' })

          Row() {
            Text('清除所有聊天')
              .fontSize(16)
              .fontColor(Color.White)
              .padding({
                left: 16,
                right: 16,
                top: 8,
                bottom: 8
              })
              .textAlign(TextAlign.Center)
              .width('100%')
              .borderRadius(8)
              .backgroundColor('#9e2a22')
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .margin({
            left: 16,
            right: 16,
            top: 80,
            bottom: 40
          })
          .onClick(() => {
            this.showDeleteConfirmDialog()
          })
        }.height('100%')
      }
      .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      // .scrollBar(BarState.On) // 滚动条常驻显示
      // .scrollBarColor(Color.Gray) // 滚动条颜色
      // .scrollBarWidth(10) // 滚动条宽度
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')

  }

  private showDeleteConfirmDialog() {
    AlertDialog.show({
      title: '确认清除',
      message: '确定要清除所有聊天记录吗？此操作不可恢复。',
      alignment: DialogAlignment.Center,
      primaryButton: {
        value: '取消',
        fontColor: '#666666',
        action: () => {
          console.info('取消删除')
        }
      },
      secondaryButton: {
        value: '清除',
        fontColor: '#FF4544',
        action: async () => {
          await this.chatService.deleteAllChats();
        }
      }
    })
  }

  @Builder
  SettingItem(title: string, onClick: () => void) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor('#333333')

      Blank()

      Image($r('app.media.ic_arrow_right'))
        .width(20)
        .height(20)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .onClick(onClick)
  }
}

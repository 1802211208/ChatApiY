import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Report {
  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ right: 16 })
          .onClick(() => router.back())

        Text('问题反馈')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
          Column() {
            Text('反馈说明')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Text('为了提供更好的服务体验，如您在使用过程中遇到以下问题，欢迎发送邮件反馈：\n\n' +
              '1. AI回复中的不当内容\n' +
              '2. 应用功能异常\n' +
              '3. 使用建议\n' +
              '4. 其他问题\n\n' +
              '反馈时请尽可能详细描述您遇到的问题，这将有助于我们更好地解决问题。'
            )
              .fontSize(16)
              .fontColor('#666666')
            Text('另因元服务域名请求限制，如有不支持访问的域名请即时联系我们')
              .fontSize(16)
              .fontColor('#a64036')

            Row() {
              Text('1489922840@qq.com')
                .fontSize(16)
                .fontColor('#007AFF')
                .margin({ right: 8 })

              Button({ type: ButtonType.Circle }) {
                Image($r('app.media.ic_copy'))
                  .width(16)
                  .height(16)
              }
              .width(32)
              .height(32)
              .backgroundColor('#F0F0F0')
              .onClick(() => {
                promptAction.showToast({
                  message: '邮箱已复制',
                  duration: 2000
                });
              })
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .onClick(() => {
              // 复制邮箱到剪贴板
              promptAction.showToast({
                message: '邮箱已复制',
                duration: 2000
              });
            })
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .height('100%')
          .width('100%')

      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      .scrollBar(BarState.Off) // 滚动条常驻显示
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
    }
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

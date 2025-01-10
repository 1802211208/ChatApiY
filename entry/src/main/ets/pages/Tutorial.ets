import router from '@ohos.router';

@Entry
@Component
struct Tutorial {
  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .margin({ right: 16 })
          .onClick(() => {
            router.back();
          })

        Text('使用教程')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(56)
      .padding(16)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column({ space: 16 }) {
          // 应用说明
          Column() {
            Text('应用说明')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Text('ChatApiY是一个AI接口聚合工具，支持对接多个兼容OpenAI接口的服务。您可以通过配置不同服务商的API密钥和接口地址来使用各种AI模型。\n\n目前支持的服务包括但不限于：\n· DeepSeek\n· OpenAI\n以及其他兼容OpenAI接口的服务')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ bottom: 12 })
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)

          // // 声明
          // Column() {
          //   Text('免责声明')
          //     .fontSize(18)
          //     .fontWeight(FontWeight.Bold)
          //
          //   Text('本教程中提到的 DeepSeek 及其相关图片仅用于示例说明。DeepSeek 是 DeepSeek Company 的商标。本应用与 DeepSeek 没有任何官方关联。用户在使用相关服务时，请遵守 DeepSeek 的服务条款和相关政策。')
          //     .fontSize(14)
          //     .fontColor('#666666')
          // }
          // .width('100%')
          // .padding(16)
          // .backgroundColor(Color.White)
          // .borderRadius(8)

          // DeepSeek教程
          Column() {
            Text('DeepSeek API申请教程')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Column({ space: 8 }) {
              Text('1. 访问DeepSeek平台')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Text('打开网址：https://platform.deepseek.com/api_keys')
                .copyOption(CopyOptions.LocalDevice)
                .fontSize(14)
                .fontColor('#666666')
                .margin({ bottom: 8 })
                .onClick(() => {
                  // 可以添加复制链接功能
                })
              Text('2. 注册/登录账号')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Text('在平台页面完成账号注册或登录')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ bottom: 8 })

              Text('3. 创建API Key')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Text('点击"Create new API key"按钮创建新的密钥')
                .fontSize(14)
                .fontColor('#666666')
                .margin({ bottom: 8 })
              Image($r('app.media.deepseek_key'))
                .width('100%')
                .objectFit(ImageFit.Contain)
                .margin({ top: 16, bottom: 16 })

              Text('4. 配置应用')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Text('· 在应用设置中填入获取的API Key\n· 设置API地址：\nhttps://api.deepseek.com/v1/chat/completions\n· 添加可用模型，如：deepseek-chat')
                .copyOption(CopyOptions.LocalDevice)
                .fontSize(14)
                .fontColor('#666666')
                .margin({ bottom: 8 })
              Image($r('app.media.deepseek_api'))
                .width('100%')
                .objectFit(ImageFit.Contain)
                .margin({ top: 16, bottom: 16 })

                Text('免责声明')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)

                Text('本教程中提到的 DeepSeek 及其相关图片仅用于示例说明。DeepSeek 是 DeepSeek Company 的商标。本应用与 DeepSeek 没有任何官方关联。用户在使用相关服务时，请遵守 DeepSeek 的服务条款和相关政策。')
                  .fontSize(14)
                  .fontColor('#666666')

            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)

          // 使用提示
          Column() {
            Text('使用提示')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Text('1. 确保API Key和地址配置正确\n2. 至少添加一个可用的模型\n3. 建议先使用较小的模型测试配置是否正确\n4. 如遇到问题，请检查网络连接和API配置')
              .fontSize(14)
              .fontColor('#666666')
          }
          .padding(16)
          .width('100%')
          .backgroundColor(Color.White)
          .borderRadius(8)

          // 重要声明
          Column() {
            Text('重要声明')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 12 })

            Text('1. 本应用仅提供接口对接服务，不参与任何API调用费用的收取。\n\n2. 所有API密钥和配置信息均存储在本地，我们不会收集或上传您的任何个人信息。\n\n3. 使用第三方服务时产生的所有费用均由相应的服务商收取，与本应用无关。\n\n4. 在使用各服务商API时，请确保遵守其服务条款和相关政策。\n\n5. 本应用不对第三方服务的可用性、稳定性以及内容准确性承担责任。')
              .fontSize(14)
              .fontColor('#FF3B30')
              .margin({ bottom: 8 })
          }
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)
        }
        .padding(16)
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
    }
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

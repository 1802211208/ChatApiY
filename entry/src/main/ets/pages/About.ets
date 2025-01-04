import router from '@ohos.router';
import bundleManager from '@ohos.bundle.bundleManager';

@Entry
@Component
struct About {
  @State appVersion: string = '';
  @State appName: string = 'ChatAI';

  aboutToAppear() {
    // 获取应用版本信息
    try {
      bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY)
        .then((bundleInfo) => {
          this.appVersion = bundleInfo.versionName;
        })
        .catch((error: Error) => {
          console.error('获取应用版本失败:', error);
        });
    } catch (error) {
      console.error('获取应用信息失败:', error);
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
            .onClick(() => {
              router.back();
            })

          Text('关于我们')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {


          // 应用信息
          // 应用图标
          Image($r('app.media.app_icon'))
            .width(80)
            .height(80)
            .margin({ top: 40, bottom: 16 })

          // 应用名称
          Text(this.appName)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })

          // 版本信息
          Text(`版本 ${this.appVersion}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 40 })

          // 应用简介
          Text('ChatAI是一款基于OpenAI接口的AI聊天应用，支持多种AI模型，为您提供智能对话服务。')
            .fontSize(14)
            .fontColor('#333333')
            .margin({ bottom: 24 })
            .padding({ left: 20, right: 20 })
            .textAlign(TextAlign.Center)

          Blank();

          // 开发者信息
          // Column({ space: 12 }) {
          //   Text('翻斗花园')
          //     .fontSize(14)
          //     .fontColor('#666666')
          //   Text('https://www.ikunnb.top')
          //     .fontSize(14)
          //     .fontColor('#666666')
          // }
          // .margin({ top: 20 })
          // .padding(16)
          // .width('100%')
          // 版权信息'

          Text('翻斗花园')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 40 })
          Text('© 2024 ChatAI All Rights Reserved')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 10, bottom: 20 })

        }.height('100%')
      }.layoutWeight(1)
      .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
      .scrollBar(BarState.Off) // 滚动条常驻显示
      .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
    }.width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

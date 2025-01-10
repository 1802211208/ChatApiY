import router from '@ohos.router';
import bundleManager from '@ohos.bundle.bundleManager';

@Entry
@Component
struct About {
  @State appVersion: string = '';
  @State appName: string = 'ChatApiY';

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
          Text('ChatApiY是一款AI接口聚合工具，支持对接多个兼容OpenAI接口的服务，为您提供智能对话服务。')
            .fontSize(14)
            .fontColor('#333333')
            .margin({ bottom: 24 })
            .padding({ left: 20, right: 20 })
            .textAlign(TextAlign.Center)

          Blank();

          Text('声明')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 12 })

          Text('本应用是一个AI接口聚合工具，支持对接多个兼容OpenAI接口的服务。应用中提到的第三方服务名称（如DeepSeek等）均为其各自所有者的商标。本应用与这些服务提供商没有任何官方关联。\n\n用户在使用相关服务时，请遵守各服务提供商的服务条款和相关政策。本应用仅提供技术对接，不对第三方服务的可用性和内容承担责任。')
            .fontSize(12)
            .padding({ left: 20, right: 20 })
            .fontColor('#999999')
          Text('© 2025 ChatApiY All Rights Reserved')
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

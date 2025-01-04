import { ChatConfig, DEFAULT_CONFIG } from '../models/ConfigModel';
import { ConfigService } from '../services/ConfigService';
import router from '@ohos.router';

@Entry
@Component
struct Settings {
  @State private config: ChatConfig = DEFAULT_CONFIG;
  private configService: ConfigService = ConfigService.getInstance();
  @State private newModel: string = '';

  aboutToAppear() {
    this.loadConfig();
  }

  private loadConfig() {
    this.configService.getConfig()
      .then((savedConfig: ChatConfig) => {
        this.config = savedConfig;
      })
      .catch((error: Error) => {
        console.error('加载配置失败:', error);
      });
  }

  // 添加一个处理模型删除的方法
  private deleteModel(index: number): void {
    const newModels = [...this.config.models];
    newModels.splice(index, 1);
    this.config.models = newModels;
  }

  // 添加一个处理新模型添加的方法
  private addModel(modelName: string): void {
    const trimmedName = modelName.trim();
    if (trimmedName && !this.config.models.includes(trimmedName)) {
      this.config.models = [...this.config.models, trimmedName];
      this.newModel = '';
    } else {
      AlertDialog.show({
        title: '提示',
        message: '该模型已存在',
        confirm: {
          value: '确定',
          action: () => {
            this.newModel = '';
          }
        }
      })
    }
  }

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

          Text('设置')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      Stack() {
        // 设置内容
        Scroll() {
          Column({ space: 16 }) {
            // 基本设置
            Column() {
              SettingItem({
                label: 'API密钥', value: this.config.apiKey, onChange: (value: string) => {
                  this.config.apiKey = value;
                }
              });
              SettingItem({
                label: 'API地址', value: this.config.apiUrl, onChange: (value: string) => {
                  this.config.apiUrl = value;
                }
              });


              Column() {
                Text('最大Token数')
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ bottom: 4 })

                TextInput({ text: this.config.maxTokens.toString() })
                  .width('100%')
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.config.maxTokens = parseInt(value) || 0;
                  })
              }
              .width('100%')
              .margin({ bottom: 12 })

            }
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)

            // 模型列表设置
            Column() {
              Text('模型列表')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 16 })
              Row() {
                TextInput({ placeholder: '输入模型名称', text: this.newModel })
                  .layoutWeight(1)
                  .height(40)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(4)
                  .padding({ left: 12, right: 12 })
                  .onChange((value: string) => {
                    this.newModel = value;
                  })

                Button('添加')
                  .height(40)
                  .width(80)
                  .margin({ left: 8 })
                  .onClick(() => {
                    if (this.newModel.trim()) {
                      this.getUIContext().getFocusController().clearFocus();
                      this.addModel(this.newModel);
                    }
                  })
              }
              .margin({ bottom: 12 })

              List() {
                ForEach(this.config.models, (model: string, index: number) => {
                  ListItem() {
                    Row() {
                      Text(model)
                        .fontSize(16)
                        .layoutWeight(1)

                      Button({ type: ButtonType.Circle }) {
                        Image($r('app.media.ic_delete'))
                          .width(20)
                          .height(20)
                      }
                      .width(36)
                      .height(36)
                      .margin({ left: 8 })
                      .backgroundColor('#FF3B30')
                      .onClick(() => {
                        this.deleteModel(index);
                      })
                    }
                    .width('100%')
                    .padding(12)
                    .backgroundColor(Color.White)
                    .borderRadius(8)
                  }
                })
              }
              .divider({ strokeWidth: 1, color: '#F5F5F5' })
            }
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)


            // 模型参数设置
            Column() {
              Text('模型参数')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 16 })

              SliderItem({
                label: '随机属性[1]', value: this.config.temperature, onChange: (value: number) => {
                  this.config.temperature = value;
                }
              });
              SliderItem({
                label: '话题属性[0]', value: this.config.presencePenalty, onChange: (value: number) => {
                  this.config.presencePenalty = value;
                }
              });
              SliderItem({
                label: '重复属性[0]', value: this.config.frequencyPenalty, onChange: (value: number) => {
                  this.config.frequencyPenalty = value;
                }
              });
              SliderItem({
                label: '词汇属性[1]', value: this.config.topP, onChange: (value: number) => {
                  this.config.topP = value;
                }
              });

            }
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)

          }
          .padding({ left: 16, right: 16 })
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
        .scrollBar(BarState.Off) // 滚动条常驻显示
        .layoutWeight(1)
        .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹


        Button('保存')
          .width(60)
          .height(60)
          .position({x: '80%', y: 600})
          .shadow({radius: 10})
          .onClick(async () => {
            try {
              await this.configService.saveConfig(this.config);
              router.back();
            } catch (error) {
              console.error('保存配置失败:', error);
            }
          })


      } .width('100%')
      .height('100%')

    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F5F5')
  }
}

@Component
struct SettingItem {
  label: string = '';
  @Prop value: string = '';
  onChange: (value: string) => void = () => {
  };

  build() {
    Column() {
      Text(this.label)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 4 })

      TextInput({ text: this.value })
        .width('100%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(4)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.onChange(value);
        })
    }
    .width('100%')
    .margin({ bottom: 12 })
  }
}

@Component
struct SliderItem {
  label: string = '';
  @Prop value: number = 0;
  onChange: (value: number) => void = () => {
  };

  build() {

    Column() {
      Row() {
        Text(this.label)
          .fontSize(14)
          .fontColor('#666666')
        Text(`${this.value.toFixed(2)}`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 4 })

      Slider({
        value: this.value,
        min: 0,
        max: 2,
        step: 0.1
      })
        .width('100%')
        .showSteps(true)
        .showTips(true)
        .onChange((value: number) => {
          // 四舍五入保留两位小数
          const roundedValue = Math.round(value * 100) / 100;
          this.onChange(roundedValue);
        })
    }
    .width('100%')
    .margin({ bottom: 12 })

  }
}

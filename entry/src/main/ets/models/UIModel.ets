
export class SelectOption {
  value: string;
  icon?: Resource;

  constructor(value: string, icon?: Resource) {
    this.value = value;
    this.icon = icon;
  }
}

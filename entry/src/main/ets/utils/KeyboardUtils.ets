import { KeyboardAvoidMode, UIContext } from '@kit.ArkUI';

export class KeyboardUtils {
  static dismissKeyboard(context: UIContext): void {
    context.getFocusController().clearFocus();
  }

  static setKeyboardAvoidMode(context: UIContext, mode: KeyboardAvoidMode): void {
    context.setKeyboardAvoidMode(mode);
  }
}

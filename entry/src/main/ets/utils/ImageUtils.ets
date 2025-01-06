import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import { fileIo as fs } from '@kit.CoreFileKit';

export class ImageUtils {
  private static arrayBufferToBase64(buffer: ArrayBuffer): string {

    let BASE64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    const bytes = new Uint8Array(buffer);
    let base64 = '';
    const len = bytes.length;
    for (let i = 0; i < len; i += 3) {
      base64 += BASE64_CHARS[bytes[i] >> 2];
      base64 += BASE64_CHARS[((bytes[i] & 3) << 4) | (bytes[i + 1] >> 4)];
      base64 += BASE64_CHARS[((bytes[i + 1] & 15) << 2) | (bytes[i + 2] >> 6)];
      base64 += BASE64_CHARS[bytes[i + 2] & 63];
    }

    if (len % 3 === 2) {
      base64 = base64.substring(0, base64.length - 1) + '=';
    } else if (len % 3 === 1) {
      base64 = base64.substring(0, base64.length - 2) + '==';
    }

    return base64;
  }

  static async getPictureFromAlbumWithBase64(): Promise<string> {
    try {
      // 拉起相册，选择图片
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      let photoSelectResult: photoAccessHelper.PhotoSelectResult = await photoPicker.select(PhotoSelectOptions);
      const albumPath = photoSelectResult.photoUris[0];
      // 读取图片为buffer
      const file = fs.openSync(albumPath, fs.OpenMode.READ_ONLY);
      const photoSize = fs.statSync(file.fd).size;
      let buffer = new ArrayBuffer(photoSize);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);

      // 使用自定义方法将buffer转换为base64字符串
      const base64String = ImageUtils.arrayBufferToBase64(buffer);

      // 添加data URI前缀
      return `data:image/jpeg;base64,${base64String}`;
    } catch (error) {
      console.error('获取和转换图片失败:', error);
      throw error as Error;
    }
  }
}

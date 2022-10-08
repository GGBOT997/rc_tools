/*
* @overview: Tag-标识
* @Author: rcc 
* @Date: 2022-07-14 09:45:10 
*/

class RcTag {
  RcTag._();

  /// Tag标识
  static String tag = '';

  /// 创建Tag标识
  static initTag() {
    tag = DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 更新Tag标识
  static void updateTag() {
    tag = DateTime.now().millisecondsSinceEpoch.toString();
  }
}

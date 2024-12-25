
class StringManipulator {
  // 返回字符串的反转
  String reverse(String str) {
    return str.split('').reversed.join('');
  }

  // 将字符串转换为大写
  String toUpperCase(String str) {
    return str.toUpperCase();
  }

  // 判断字符串是否是回文
  bool isPalindrome(String str) {
    String reversed = reverse(str);
    return str == reversed;
  }
}
import 'dart:convert';

class BaseEncoder {
  static final _stringToBase64 = utf8.fuse(base64);
  static String encode(String input) {
    return _stringToBase64.encode(input);
  }

  static String decode(String input) {
    return _stringToBase64.decode(input);
  }
}
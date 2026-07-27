import 'dart:typed_data';

import 'package:crypto/crypto.dart';

String? sha256StringOfNullable(Uint8List? bytes) {
  if (bytes == null) {
    return null;
  }
  return sha256.convert(bytes).toString();
}
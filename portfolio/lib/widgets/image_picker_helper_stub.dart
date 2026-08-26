import 'dart:typed_data';

class PickedFileData {
  final Uint8List bytes;
  final String mimeType;
  final String name;
  final int size;

  PickedFileData({
    required this.bytes,
    required this.mimeType,
    required this.name,
    required this.size,
  });
}

Future<String?> pickImageAsBase64() async {
  return null;
}

Future<String?> pickVideoAsBase64() async {
  return null;
}

Future<PickedFileData?> pickVideoFile() async {
  return null;
}

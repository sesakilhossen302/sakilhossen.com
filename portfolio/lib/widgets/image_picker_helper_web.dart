import 'dart:async';
import 'dart:html' as html;
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
  final completer = Completer<String?>();
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();
  input.onChange.listen((event) {
    if (input.files == null || input.files!.isEmpty) {
      completer.complete(null);
      return;
    }
    final file = input.files![0];
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((loadEvent) {
      completer.complete(reader.result as String?);
    });
    reader.onError.listen((errorEvent) {
      completer.complete(null);
    });
  });
  return completer.future;
}

Future<String?> pickVideoAsBase64() async {
  final completer = Completer<String?>();
  final input = html.FileUploadInputElement()..accept = 'video/*';
  input.click();
  input.onChange.listen((event) {
    if (input.files == null || input.files!.isEmpty) {
      completer.complete(null);
      return;
    }
    final file = input.files![0];
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((loadEvent) {
      completer.complete(reader.result as String?);
    });
    reader.onError.listen((errorEvent) {
      completer.complete(null);
    });
  });
  return completer.future;
}

Future<PickedFileData?> pickVideoFile() async {
  final completer = Completer<PickedFileData?>();
  final input = html.FileUploadInputElement()..accept = 'video/*';
  input.click();
  input.onChange.listen((event) {
    if (input.files == null || input.files!.isEmpty) {
      completer.complete(null);
      return;
    }
    final file = input.files![0];
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((loadEvent) {
      final bytes = Uint8List.fromList(reader.result as List<int>);
      completer.complete(PickedFileData(
        bytes: bytes,
        mimeType: file.type.isNotEmpty ? file.type : 'video/mp4',
        name: file.name,
        size: file.size,
      ));
    });
    reader.onError.listen((errorEvent) {
      completer.complete(null);
    });
  });
  return completer.future;
}

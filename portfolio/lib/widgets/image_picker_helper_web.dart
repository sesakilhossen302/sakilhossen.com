import 'dart:async';
import 'dart:html' as html;

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

import 'package:dart_frog/dart_frog.dart';

abstract class FileTools {
  FileTools._();

  /// Gets an image, saves it in the cdn, and returns the url
  static Future<String> saveImage(UploadedFile image) async {
    // TODO: implement image saving
    return 'https://fastly.picsum.photos/id/50/4608/3072.jpg';
  }
}

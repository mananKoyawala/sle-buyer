import 'dart:io';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();
File? _imageFile;

Future<File> pickImage(ImageSource source) async {
  final XFile? pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }

  return File("");
}

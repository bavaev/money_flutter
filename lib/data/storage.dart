import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class RepositoryStorage {
  final storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  XFile? image;
  bool isPicked = false;
  bool isLoading = true;

  Future<XFile?> getImageFromGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      isPicked = true;
    }
    return null;
  }

  Future<String> uploadImage(String userId, XFile image) async {
    Reference query = storage.ref().child('user_images/$userId');

    isLoading = false;
    UploadTask uploadTask = query.putFile(File(image.path));

    await Future.value(uploadTask);
    isPicked = false;
    var newUrl = await query.getDownloadURL();

    await FirebaseAuth.instance.currentUser?.updatePhotoURL(newUrl);
    isLoading = true;

    return newUrl;
  }
}

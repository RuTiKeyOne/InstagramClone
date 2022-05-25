import 'dart:typed_data';

import 'package:instagram_clone/core/service/storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageImpl extends Storage {
  late final FirebaseStorage _storage;
  late final FirebaseAuth _auth;

  StorageImpl() {
    _storage = FirebaseStorage.instance;
    _auth = FirebaseAuth.instance;
  }

  @override
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference reference =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
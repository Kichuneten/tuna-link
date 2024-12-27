import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';

// import 'package:tunalink/src/infrastructure/server/server_userinfo.dart';

const userInfoStorage = FlutterSecureStorage();

Future<void> saveUIDToSecureStorage() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await userInfoStorage.write(key: 'uid', value: user.uid);
  }
}

Future<String?> getUIDFromSecureStorage() async {
  return await userInfoStorage.read(key: 'uid');
}

Future<void> saveEmailToSecureStorage(String? email) async {
  await userInfoStorage.write(key: 'email', value: email);
}

Future<String?> getEmailFromSecureStorage() async {
  return await userInfoStorage.read(key: 'email');
}



//これもとりあえずの素材置き場


// Create storage
// final storage = new FlutterSecureStorage();





// Read value
// String value = await storage.read(key: key);

// Read all values
// Map<String, String> allValues = await storage.readAll();

// Delete value
// await storage.delete(key: key);

// Delete all
// await storage.deleteAll();

// Write value
// await storage.write(key: key, value: value);
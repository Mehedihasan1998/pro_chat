import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pro_chat/model/user_model.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Variable for storing the person's data who is logged in
  static late UserModel myData;

  // Checking who is logged in
  static User get user => auth.currentUser!;

  // Checking if user exists or not
  static Future<bool> userExists() async {
    return (await fireStore.collection('users').doc(user.uid).get()).exists;
  }

  // Getting the person's data who is logged in
  static Future<void> getPersonalData() async {
    await fireStore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        myData = UserModel.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getPersonalData());
      }
    });
  }

  // Creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = UserModel(
      image: user.photoURL.toString(),
      about: "Hey there, I am using Pro Chat",
      name: user.displayName.toString(),
      createdAt: time,
      id: user.uid,
      lastActive: time,
      isOnline: false,
      pushToken: '',
      email: user.email.toString(),
    );
    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

  // Getting all the users except currently logged in user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // Updating user info
  static Future<void> updateUserData() async {
    await fireStore.collection('users').doc(user.uid).update({
      'name': myData.name,
      'about': myData.about,
    });
  }

  // Update Profile Picture
  static Future<void> updateProfilePicture(File file) async {
    // Image extension
    final ext = file.path.split('.').last;
    print("Extension: $ext");

    // storage file reference with the path
    final reference = storage.ref().child('profile_picture/${user.uid}.$ext');

    // Upload image
    await reference.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      print("Image size: ${p0.bytesTransferred / 1000} kb");
    });

    // Update image in firestore database
    myData.image = await reference.getDownloadURL();
    await fireStore.collection('users').doc(user.uid).update({
      'image': myData.image,
    });
  }

}

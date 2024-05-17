import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pro_chat/model/message_model.dart';
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
    await reference
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Image size: ${p0.bytesTransferred / 1000} kb");
    });

    // Update image in firestore database
    myData.image = await reference.getDownloadURL();
    await fireStore.collection('users').doc(user.uid).update({
      'image': myData.image,
    });
  }

  /// ********************Chat messages***********************

  // Get the conversation ID
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // Get all the text of specific conversion
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllText(
      UserModel user) {
    return fireStore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  // Send text
  static Future<void> sendText(UserModel chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = fireStore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  // Update read status
  static Future<void> updateMessageReadStatus(MessageModel message) async {
    fireStore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastText(
      UserModel user) {
    return fireStore
        .collection('chats/${getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // Last message time
  static String getLastTextTime(MessageModel message) {
    final DateTime currentTime = DateTime.now();
    final DateTime textTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(message.sent));

    if (currentTime.day == textTime.day &&
        currentTime.month == textTime.month &&
        currentTime.year == textTime.year) {
      return "${Jiffy.parse("${DateTime.fromMillisecondsSinceEpoch(int.parse(message!.sent))}").format(pattern: "hh:mm a")}";
    }
    return "${Jiffy.parse("${DateTime.fromMillisecondsSinceEpoch(int.parse(message!.sent))}").format(pattern: "MMM d")}";
  }

  // Chat image sending
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last;

    // storage file reference with the path
    final reference = storage.ref().child(
        'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Upload image
    await reference
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print("Image size: ${p0.bytesTransferred / 1000} kb");
    });

    // Update image in firestore database
    final imageUrl = await reference.getDownloadURL();
    await sendText(chatUser, imageUrl, Type.image);
  }
}

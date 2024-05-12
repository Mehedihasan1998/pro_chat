import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro_chat/model/user_model.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static late UserModel myData;

  static User get user => auth.currentUser!;

  static Future<bool> userExists()async{
    return (await fireStore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> getPersonalData() async{
    await fireStore.collection('users').doc(user.uid).get().then((user) async{
      if(user.exists){
        myData = UserModel.fromJson(user.data()!);
      }else{
        await createUser().then((value) => getPersonalData());
      }
    });
  }

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return fireStore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_posts/features/authentication/data/models/user_model.dart';

class AuthenticationDataSources {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationDataSources({
    required FirebaseAuth auth,
    required FirebaseFirestore firebaseFirestore,
  }) : _auth = auth,
       _firebaseFirestore = firebaseFirestore;

  Future<UserModel> signIn(String? email, String? password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email ?? '',
      password: password ?? '',
    );

    final user = credential.user;
    if (user == null) {
      throw Exception("Login failed!!!");
    }

    // get user-id
    final doc = await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) {
      throw Exception("No user found!!!");
    }

    return UserModel.fromJson(doc.data());
  }

  Future<void> registerUser(UserModel? user, String? password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: user?.email ?? '',
      password: password ?? '',
    );

    final createUser = credential.user;
    if (createUser == null) {
      throw Exception('Failed registering user with ${user?.email}');
    }

    final userModel = user?.copyWith(uid: createUser.uid);

    await _firebaseFirestore
        .collection('users')
        .doc(createUser.uid)
        .set(userModel?.toJson() ?? {});
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    final doc = await _firebaseFirestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromJson(doc.data());
  }
}

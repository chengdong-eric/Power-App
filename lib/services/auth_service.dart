import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:power/models/user_model.dart';
import 'package:power/screens/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> continueAsGuest() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> signUpWithEmail(
    String email,
    String password,
    String username,
  ) async {
    final dbService = DatabaseService();
    final isUsernameTaken = await dbService.isUsernameTaken(username);
    if (isUsernameTaken) {
      return 'This username is already taken, please choose another one.';
    }

    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await dbService.createUserDocument(
          uid: user.uid,
          email: email,
          username: username.toLowerCase().trim(),
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email address is already in use.';
      } else if (e.code == 'weak-password') {
        return 'The password is too weak.';
      }
      return 'An error occurred. Please try again.';
    } catch (e) {
      print(e.toString());
      return 'An unexpected error occured.';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithIdentifier(String identifier, String password) async {
    String email;

    if (identifier.contains('@')) {
      email = identifier.trim();
    } else {
      // lookup email by username
      final fetchedEmail = await DatabaseService().getEmailByUsername(
        identifier.trim(),
      );
      if (fetchedEmail == null || fetchedEmail.isEmpty) return null;
      email = fetchedEmail;
    }
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // TODO: Implement other methods like signInWithEmail, signOut, etc. later
}

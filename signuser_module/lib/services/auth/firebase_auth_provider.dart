import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'auth_user.dart';
import 'auth_exception.dart';
import 'auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException, FirebaseException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final curUser = currentUser;
      if (curUser != null) {
        return curUser;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();

        case 'invalid-email':
          throw InvalidEmailAuthException();

        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();

        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final curUser = currentUser;
      if(curUser != null){
        return curUser;
      }else{
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'wrong-password':
          throw WrongPasswordAuthException();

        case 'invalid-email':
          throw InvalidEmailAuthException();

        case 'user-not-found':
          throw UserNotFoundAuthException();

        default:
          throw GenericAuthException();
      }
    } catch (_){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    final curUser = FirebaseAuth.instance.currentUser;
    if(curUser != null) {
      await FirebaseAuth.instance.signOut();
    }else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final curUser = FirebaseAuth.instance.currentUser;
    if (curUser != null) {
      await curUser.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async => await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

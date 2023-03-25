import 'package:flutter_test/flutter_test.dart';
import 'package:signuser_module/services/auth/auth_exception.dart';
import 'package:signuser_module/services/auth/auth_provider.dart';
import 'package:signuser_module/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthService();

    test('Should not be initialized at the beginning', () {
      expect(provider.isInitialized, false);
    });

    test(
      'can not log out if not initialized',
      () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      },
    );

    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(
        Duration(seconds: 2),
      ),
    );

    test('User should be logged in', () async{
      final badEmail = provider.createUser(
        email: 'tom@mail.com',
        password: 'anypassword',
      );

      expect(
        badEmail,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPassword = provider.createUser(
        email: "simba@mail.com",
        password: 'test12',
      );

      expect(
        badPassword,
        throwsA(
          const TypeMatcher<WrongPasswordAuthException>(),
        ),
      );

      final user = await provider.createUser(email: 'tom', password: 'test');
      
      expect(provider.currentUser,user);
      expect(user?.isEmailVerified, false);
    });

    test('User should be able to be verified', (){
      provider.sendEmailVerification();
      final user = provider.currentUser;

      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test('User should be able to logout and login again', () async{
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');

      final user = provider.currentUser;
      expect(user, isNotNull);
    });

  });
}

class NotInitializedException implements Exception {}

class MockAuthService implements AuthProvider {
  AuthUser? user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'tom@mail.com') throw UserNotFoundAuthException();
    if (password == 'test12') throw WrongPasswordAuthException();
    const _user = AuthUser(isEmailVerified: false);
    user = _user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    user == null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    var _user = user;
    if (_user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    user = newUser;
  }
}

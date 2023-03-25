// Login Exceptions

class WrongPasswordAuthException implements Exception{}

class InvalidEmailAuthException implements Exception{}

class UserNotFoundAuthException implements Exception{}


//SignUp Exceptions
class EmailAlreadyInUseAuthException implements Exception{}

class WeakPasswordAuthException implements Exception{}

//generic Exceptions

class GenericAuthException implements Exception{}

class UserNotLoggedInException implements Exception{}

class NotInitializedException implements Exception{}
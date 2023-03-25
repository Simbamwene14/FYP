import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signuser_module/exceptions/exceptionHandling.dart';
import '../firebase_options.dart';
import '../services/auth/auth_exception.dart';
import '../routes/route.dart';
import '../services/auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _yaEmail;
  late final TextEditingController _yaPassword;

  //Conditional Variable
  bool isObscure = true;

  //key for the form
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _yaEmail = TextEditingController();
    _yaPassword = TextEditingController();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  void dispose() {
    _yaEmail.dispose();
    _yaPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _yaEmail,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The field is required, please fill!";
                  }
                  return null;
                },
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(fontSize: 18),
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 16),
                    alignLabelWithHint: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 25)),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _yaPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "The field is required, please fill!";
                  }
                  return null;
                },
                enableSuggestions: false,
                obscureText: isObscure,
                decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    hintStyle: const TextStyle(fontSize: 18),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: toggleVisibility,
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorStyle: const TextStyle(fontSize: 16),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25)),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Forgot your Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () async {
                      var email = _yaEmail.text;
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                        } on FirebaseAuthException catch (error) {
                          if (error.code == 'unknown') {
                            if (kDebugMode) {
                              print("Please Fill the Email field");
                            }
                          }
                        }
                      }
                    },
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  var emailValue = _yaEmail.text;
                  var passValue = _yaPassword.text;
                  if (_formKey.currentState!.validate()) {
                    try {
                      await AuthService.firebase()
                          .logIn(email: emailValue, password: passValue);
                      final user = AuthService.firebase().currentUser;
                      if (user != null) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          contentRoute,
                          (route) => false,
                        );
                      }
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Wrong Credentials",
                      );
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        "User Doesn't Exist!",
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        "Invalid Email Format!",
                      );
                    }on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Error: Authentication Error!",
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  alignment: Alignment.center,
                  fixedSize: const Size(150, 70),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Sign Up now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }
}

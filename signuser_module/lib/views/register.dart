import 'package:flutter/material.dart';
import 'package:signuser_module/exceptions/exceptionHandling.dart';
import 'package:signuser_module/services/auth/auth_exception.dart';
import 'package:signuser_module/services/auth/auth_services.dart';
import '../routes/route.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _yaEmail;
  late final TextEditingController _yaPassword;

  //conditional variables
  bool isObscure = true;

  //Global key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _yaEmail = TextEditingController();
    _yaPassword = TextEditingController();
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
                'Register',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 16),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 25)),
              ),
              const SizedBox(
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
                      icon: Icon(isObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                    errorStyle: const TextStyle(fontSize: 16),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25)),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  var emailValue = _yaEmail.text;
                  var passValue = _yaPassword.text;

                  if (_formKey.currentState!.validate()) {
                    try {
                      await AuthService.firebase().createUser(
                        email: emailValue,
                        password: passValue,
                      );
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginRoute, (route) => false);
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        "User Already Exists!",
                      );
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        "Required Password 8 characters and Above!",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Error: Failed To Register",
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
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Do you have an account?",
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
                          context, loginRoute, (route) => false);
                    },
                    child: const Text(
                      'Sign In now',
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

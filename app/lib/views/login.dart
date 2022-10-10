import 'package:flutter/material.dart';
import 'package:tactibetter/api/api_common.dart';
import 'package:tactibetter/api/login.dart';
import 'package:tactibetter/util/prefs.dart';
import 'package:tactibetter/views/home.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login')
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            _LoginForm(),
          ],
        ),
      )
    );
  }
}

class _LoginForm extends StatefulWidget {
  _LoginForm({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {

    return Form(
      key: widget._formState,
      child: Column(
        children: [
          TextFormField(
            controller: widget._usernameController,
            validator: _validateRequiredField,
            autovalidateMode: AutovalidateMode.always,
            decoration: const InputDecoration(
              labelText: 'Gebruikersnaam'
            ),
          ),
          TextFormField(
            controller: widget._passwordController,
            validator: _validateRequiredField,
            autovalidateMode: AutovalidateMode.always,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Wachtwoord'
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                if(!widget._formState.currentState!.validate()) {
                  debugPrint("Login form is invalid");
                  return;
                }

                debugPrint("Logging in..");
                _handleLogin();
              },
            )
          )
        ],
      ),
    );
  }

  void _handleLogin() async {
    Response<Session> response = await Login.login(widget._usernameController.text, widget._passwordController.text);
    debugPrint("Login request completed");

    if(!mounted) {
      debugPrint("No longer mounted");
      return;
    }

    switch(response.status) {
      case -1:
        debugPrint("Request failed");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Er is iets verkeerd gegaan. Probeer het later opnieuw.")));
        });
        break;

      case 401:
        debugPrint("Invalid credentials");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gebruikersnaam of wachtwoord is incorrect")));
        });
        break;

      case 200:
        debugPrint("Login OK");
        Session session = response.value!;
        await Prefs.setSessionId(session.id);
        if(!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => HomeView(session: session)));
        break;

      default:
        debugPrint("Login failed ${response.status}");
        Future<void>.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message!)));
        });
        break;
    }
  }

  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vereist';
    }

    return null;
  }
}
import 'package:app/auth/login_page.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/constants.dart';
// import 'package:my_chat_app/pages/chat_page.dart';
// import 'package:my_chat_app/pages/login_page.dart';
// import 'package:my_chat_app/utils/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.isRegistering}) : super(key: key);

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => RegisterPage(isRegistering: isRegistering),
    );
  }

  final bool isRegistering;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    try {
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      // Navigator.of(context)
      //     .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occured.');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Resgister',
        showOptions: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                if (val.length < 6) {
                  return '6 characters minimum';
                }
                return null;
              },
            ),
            formSpacer,
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                label: Text('Username'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                if (!isValid) {
                  return '3-24 long with alphanumeric or underscore';
                }
                return null;
              },
            ),
            formSpacer,
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: const Text('Register'),
            ),
            formSpacer,
            TextButton(
              onPressed: () {
                Navigator.of(context).push(LoginPage.route());
              },
              child: const Text('I already have an account'),
            )
          ],
        ),
      ),
    );
  }
}

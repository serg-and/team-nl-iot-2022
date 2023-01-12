import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DebugConfig {
  static const loginDisabled = false;
}

/// Supabase client
final supabase = Supabase.instance.client;

// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

const PERSIST_SESSION_KEY = 'PERSIST_SESSION_KEY';

/// Environment variables and shared app constants.
abstract class Secrets {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );

  static const String server = String.fromEnvironment(
    'SERVER',
    defaultValue: 'http://teamnl-t-iot-vm.westeurope.cloudapp.azure.com',
  );
}

// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    print('snackbar printing error: ${message}');
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

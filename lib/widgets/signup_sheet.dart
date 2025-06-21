import 'dart:async';

import 'package:flutter/material.dart';
import 'package:power/screens/database_service.dart';
import 'package:power/services/auth_service.dart';
import 'package:power/utils/validators.dart';

class SignupSheet extends StatefulWidget {
  const SignupSheet({super.key});

  @override
  State<SignupSheet> createState() => _SignupSheetState();
}

class _SignupSheetState extends State<SignupSheet> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Timer? _debounce;
  bool _isCheckingUsername = false;
  bool? _isUsernameAvailable;
  String? _usernameValidationError;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  Future<void> _trySignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authService = AuthService();

    final String? error = await authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
    );

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isLoading = false;
      });
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onUsernameChanged() {
    setState(() {
      _usernameValidationError = validateUsername(_usernameController.text);
    });

    if (_usernameValidationError != null) {
      setState(() => _isUsernameAvailable = null);
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    setState(() {
      _isCheckingUsername = true;
      _isUsernameAvailable = null;
    });

    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      final dbService = DatabaseService();
      final isTaken = await dbService.isUsernameTaken(
        _usernameController.text.trim(),
      );
      if (mounted) {
        setState(() {
          _isUsernameAvailable = !isTaken;
          _isCheckingUsername = false;
        });
      }
    });
  }

  Widget? _buildUsernameSuffixIcon() {
    if (_isCheckingUsername) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_isUsernameAvailable == null) {
      return null;
    }

    if (_isUsernameAvailable!) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else {
      return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create your Account',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                suffixIcon: _buildUsernameSuffixIcon(),
              ),
              validator: (value) {
                if (_usernameValidationError != null)
                  return _usernameValidationError;
                if (_isUsernameAvailable == false)
                  return 'This username is already taken.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: validatePassword,
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _trySignUp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Sign Up'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

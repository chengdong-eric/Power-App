import 'package:flutter/material.dart';
import 'package:power/services/auth_service.dart';
import 'package:power/widgets/signin_sheet.dart';
import 'package:power/widgets/signup_sheet.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              Text(
                'You have the power.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Be informed, be aware.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const Spacer(flex: 3),

              // TODO: Implement Google/Apple sign in
              _buildSocialButton(
                context,
                'Continue with Google',
                Icons.g_mobiledata,
              ),
              const SizedBox(height: 16),
              _buildSocialButton(context, 'Continue with Apple', Icons.apple),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (ctx) => const SignupSheet(),
                  );
                },
                child: const Text('Sign up with Email'),
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const SigninSheet(),
                  );
                },
                child: const Text('Already have an account? Sign In'),
              ),

              TextButton(
                onPressed: () async {
                  await authService.continueAsGuest();
                },
                child: const Text('Continue as Guest'),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSocialButton(BuildContext context, String text, IconData icon) {
  return ElevatedButton.icon(
    onPressed: () {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$text is not yet implemented')));
    },
    label: Text(text),
    icon: Icon(icon, size: 28),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      side: BorderSide(color: Colors.grey.shade300),
    ),
  );
}

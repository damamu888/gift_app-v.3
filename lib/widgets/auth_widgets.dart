import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatelessWidget {
  final AuthenticatorState state;
  const SignInWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // App Logo
              Center(
                child: Image.asset(
                  "lib/assets/present.png",
                  scale: 1.5,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Amplify Sign In Form
              SignInForm(),
            ],
          ),
        ),
      ),
      // Buttom um den Benutzer zum Registrierungsbildschirm zu bringen
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Noch keinen Account?'),
            TextButton(
              onPressed: () => state.changeStep(
                AuthenticatorStep.signUp,
              ),
              child: const Text('Registrieren'),
            ),
          ],
        ),
      ],
    );
  }
}

class SignUpWidget extends StatelessWidget {
  final AuthenticatorState state;
  const SignUpWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // App Logo
              Center(
                child: Image.asset(
                  "lib/assets/present.png",
                  scale: 1.5,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Unsere angepasste Sign Up Form
              SignUpForm.custom(
                fields: [
                  SignUpFormField.username(),
                  SignUpFormField.email(required: true),
                  SignUpFormField.custom(
                    required: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte gib einen Nickname ein";
                      }
                      return null;
                    },
                    title: 'Nickname',
                    attributeKey: CognitoUserAttributeKey.nickname,
                  ),
                  SignUpFormField.password(),
                  SignUpFormField.passwordConfirmation(),
                ],
              ),
            ],
          ),
        ),
      ),
      // Buttom um den Benutzer zum Anmeldebildschirm zu bringen
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Du hast bereits einen Account?'),
            TextButton(
              onPressed: () => state.changeStep(
                AuthenticatorStep.signIn,
              ),
              child: const Text('Einloggen'),
            ),
          ],
        ),
      ],
    );
  }
}

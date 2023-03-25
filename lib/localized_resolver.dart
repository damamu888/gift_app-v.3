import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomButtonResolver extends ButtonResolver {
  const CustomButtonResolver();

  @override
  String signIn(BuildContext context) {
    return AppLocalizations.of(context)!.signin;
  }

  @override
  String forgotPassword(BuildContext context) {
    return AppLocalizations.of(context)!.forgotPassword;
  }
}

class CustomInputResolver extends InputResolver {
  const CustomInputResolver();

  @override
  String title(BuildContext context, InputField field) {
    switch (field) {
      case InputField.username:
        return AppLocalizations.of(context)!.username;
      case InputField.password:
        return AppLocalizations.of(context)!.password;
      default:
        return super.title(context, field);
    }
  }

  @override
  String hint(BuildContext context, InputField field) {
    return AppLocalizations.of(context)!.promptFill;
  }
}

const stringResolver = AuthStringResolver(
  buttons: CustomButtonResolver(),
  inputs: CustomInputResolver(),
);

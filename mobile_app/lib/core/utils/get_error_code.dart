import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/l10n.dart';

String getErrorMessage(BuildContext context, String errorCode) {
  final l10n = AppLocalizations.of(context)!;
  String errorMessage = "";
  switch (errorCode) {
    case 'error_code_no_user':
      errorMessage = l10n.no_user;
    case 'error_code_no_do':
      errorMessage = l10n.no_profile;
    default:
      errorMessage = errorCode;
  }

  return errorMessage;
}

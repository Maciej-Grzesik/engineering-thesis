import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

class AuthInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool isObscureText;
  const AuthInput({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.isObscureText,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _isPasswordVisible = false;

  String _getLocalizedHintText(String hintKey, BuildContext context, AppLocalizations l10n) {
    switch (hintKey) {
      case "email":
        return l10n.email;
      case "password":
        return l10n.password;
      case "confirm_password":
        return l10n.confirm_password;
      default:
        return hintKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      validator: (value) => value!.isEmpty
          ? l10n.field_cannot_be_empty
          : null,
      controller: widget.textEditingController,
      style: TextStyle(color: colorScheme.onSurface),
      obscureText: widget.isObscureText ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        hintText: _getLocalizedHintText(widget.hintText, context, l10n),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        suffixIcon: widget.isObscureText
            ? IconButton(
                color: colorScheme.onSurface,
                icon: _isPasswordVisible
                    ? const Icon(Icons.visibility_rounded)
                    : const Icon(Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      autofillHints: widget.hintText == "email"
          ? const [AutofillHints.email]
          : [AutofillHints.password],
    );
  }
}

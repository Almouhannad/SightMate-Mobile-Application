import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/entities/profile.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/tts/domain/tts_provider.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String? errorMessage;
  final _ttsProvider = DI.get<TtsProvider>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ttsProvider.stopAndSpeak(L10n.current.register);
  }

  Future<void> _submit(
    BuildContext context,
    AuthenticationNotifier authNotifier,
  ) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    Result<Profile> regResult = Result(isSuccess: false);
    await authNotifier
        .register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        )
        .then((value) {
          regResult = value;
          setState(() => _isLoading = false);
        });

    if (regResult.isSuccess) {
      if (!context.mounted) return;
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
      _ttsProvider.stop();
      _ttsProvider.speak(
        L10n.current.actionDoneSuccessfully(L10n.current.register),
      );
      return;
    } else if (regResult.hasValidationErrors != null) {
      setState(() {
        errorMessage = regResult.validationErrors![0];
      });
    } else if (regResult.error != null) {
      setState(() {
        errorMessage = regResult.error;
      });
    } else {
      setState(() {
        errorMessage = L10n.current.errorOccurred;
      });
    }
    _ttsProvider.stopAndSpeak(L10n.current.errorOccurred);
    return;
  }

  void _onLogin(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).pushNamed(LoginPageRoute().link);
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthenticationNotifier>();
    final theme = Theme.of(context);

    return WidgetScaffold(
      title: L10n.current.register,
      withDrawer: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorMessage != null && errorMessage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      errorMessage!,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // First & Last Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: L10n.current.firstName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return L10n.current.pleaseEnterYour(
                              L10n.current.firstName,
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: L10n.current.lastName,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return L10n.current.pleaseEnterYour(
                              L10n.current.lastName,
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  textDirection: TextDirection.ltr,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: L10n.current.email,
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return L10n.current.pleaseEnterYour(L10n.current.email);
                    }
                    const emailPattern =
                        r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$";
                    if (!RegExp(emailPattern).hasMatch(value.trim())) {
                      return L10n.current.validEmailValidationMessage;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  textDirection: TextDirection.ltr,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: L10n.current.password,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return L10n.current.pleaseEnterYour(
                        L10n.current.password,
                      );
                    }
                    const minLength = 6;
                    if (value.length < minLength) {
                      return L10n.current.passwordLengthValidationMessage(
                        minLength,
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Accept Terms Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (val) {
                        setState(() {
                          _acceptedTerms = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        L10n.current.acceptTerms,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !_acceptedTerms || _isLoading
                        ? null
                        : () => _submit(context, authNotifier),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            L10n.current.register,
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                // Login Option
                TextButton(
                  onPressed: () => _onLogin(context),
                  child: Text(
                    L10n.current.alreadyHaveAccount,
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/entities/profile.dart';
import 'package:sight_mate/modules/shared/authentication/presentation/authentication_presentation.dart';
import 'package:sight_mate/modules/shared/i18n/data/l10n/l10n.dart';
import 'package:sight_mate/modules/shared/widgets/shared_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(
    BuildContext context,
    AuthenticationNotifier authenticationNotifier,
  ) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        errorMessage = null;
      });
      Result<Profile> loginResult = Result(isSuccess: false);
      await authenticationNotifier
          .login(_emailController.text.trim(), _passwordController.text.trim())
          .then((value) {
            setState(() {
              _isLoading = false;
            });
            loginResult = value;
          });
      if (loginResult.isSuccess) {
        // Guard against using context after async gap
        if (!context.mounted) return;
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } else if (loginResult.hasValidationErrors != null) {
        setState(() {
          errorMessage = loginResult.validationErrors![0];
        });
      } else if (loginResult.error != null) {
        errorMessage = loginResult.error;
      } else {
        setState(() {
          errorMessage = L10n.current.errorOccurred;
        });
      }
    }
  }

  void _onRegister(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).pushNamed(RegisterPageRoute().link);
  }

  @override
  Widget build(BuildContext context) {
    final authenticationNotifier = context.watch<AuthenticationNotifier>();
    final theme = Theme.of(context);
    return WidgetScaffold(
      title: L10n.current.login,
      withDrawer: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                L10n.current.loginMessage,
                textAlign: TextAlign.center,
                softWrap: true,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (errorMessage != null && errorMessage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              errorMessage!,
                              style: theme.textTheme.displaySmall!.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),

                      // Email field
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
                          if (value == null || value.isEmpty) {
                            return L10n.current.pleaseEnterYour(
                              L10n.current.email,
                            );
                          }
                          const emailPattern =
                              r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$";
                          final regex = RegExp(emailPattern);
                          if (!regex.hasMatch(value)) {
                            return L10n.current.validEmailValidationMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password field
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
                          int passowrdMinLength = 6;
                          if (value.length < passowrdMinLength) {
                            return L10n.current.passwordLengthValidationMessage(
                              passowrdMinLength,
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _submit(context, authenticationNotifier);
                                },
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
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  L10n.current.login,
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Register option
                      TextButton(
                        onPressed: () => _onRegister(context),
                        child: Text(
                          L10n.current.registerMessage,
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
          ),
        ],
      ),
    );
  }
}

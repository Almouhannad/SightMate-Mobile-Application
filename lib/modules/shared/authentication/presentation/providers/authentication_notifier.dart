import 'package:flutter/material.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

class AuthenticationNotifier extends ChangeNotifier {
  AuthenticationProvider _authenticationProvider;
  ProfileRepository _profileRepository;
  AuthenticationNotifier(this._authenticationProvider, this._profileRepository);

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _isInitialized = true;
    notifyListeners();
    return Future.value();
  }
}

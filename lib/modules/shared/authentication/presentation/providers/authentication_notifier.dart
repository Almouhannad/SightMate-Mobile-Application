import 'package:flutter/material.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

class AuthenticationNotifier extends ChangeNotifier {
  final AuthenticationProvider _authenticationProvider;
  final ProfileRepository _profileRepository;
  AuthenticationNotifier(this._authenticationProvider, this._profileRepository);

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Profile? _profile;
  Profile get profile {
    if (!_isLoggedIn) throw Exception("Requested profile without login");
    return _profile!;
  }

  Future<void> initialize() async {
    var loadProfileResult = await _profileRepository.loadProfile();
    _isLoggedIn = loadProfileResult.isSuccess;
    if (_isLoggedIn) {
      _profile = loadProfileResult.value!;
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<Result<Profile>> login(String email, String password) async {
    var loginResult = await _authenticationProvider.login(email, password);
    if (loginResult.isSuccess) {
      _isLoggedIn = true;
      _profile = loginResult.value!;
      await _profileRepository.updateProfile(_profile!);
      notifyListeners();
    }
    return loginResult;
  }

  Future<Result<Profile>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    var registerResult = await _authenticationProvider.register(
      firstName,
      lastName,
      email,
      password,
    );
    if (registerResult.isSuccess) {
      _isLoggedIn = true;
      _profile = registerResult.value;
      await _profileRepository.updateProfile(_profile!);
      notifyListeners();
    }
    return registerResult;
  }

  Future<void> logout() async {
    await _authenticationProvider.logout();
    await _profileRepository.clearProfile();
    _isLoggedIn = false;
    _profile = null;
    notifyListeners();
  }
}

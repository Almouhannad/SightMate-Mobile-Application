import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/app/injection.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

/// A concrete implementation of [ProfileRepository] using SharedPreferences.
class ProfileRepositoryImpl implements ProfileRepository {
  static const _keyFirstName = 'profile_firstName';
  static const _keyLastName = 'profile_lastName';
  static const _keyEmail = 'profile_email';
  final SharedPreferences _sharedPreferences = DI.get<SharedPreferences>();

  @override
  Future<Result<Profile>> loadProfile() async {
    try {
      final firstName = _sharedPreferences.getString(_keyFirstName);
      final lastName = _sharedPreferences.getString(_keyLastName);
      final email = _sharedPreferences.getString(_keyEmail);

      if (firstName == null || lastName == null || email == null) {
        return Result(isSuccess: false);
      }

      final profile = Profile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      return Result(isSuccess: true, value: profile);
    } catch (e) {
      return Result(isSuccess: false);
    }
  }

  @override
  Future<Result> updateProfile(Profile newProfile) async {
    try {
      await Future.wait([
        _sharedPreferences.setString(_keyFirstName, newProfile.firstName),
        _sharedPreferences.setString(_keyLastName, newProfile.lastName),
        _sharedPreferences.setString(_keyEmail, newProfile.email),
      ]);
      return Result(isSuccess: true);
    } catch (e) {
      return Result(isSuccess: false);
    }
  }

  @override
  Future<Result> clearProfile() async {
    try {
      await _sharedPreferences.remove(_keyFirstName);
      await _sharedPreferences.remove(_keyLastName);
      await _sharedPreferences.remove(_keyEmail);
    } catch (e) {
      return Result(isSuccess: false);
    }
    return Result(isSuccess: true);
  }
}

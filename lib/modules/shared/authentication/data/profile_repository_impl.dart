import 'package:shared_preferences/shared_preferences.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

/// A concrete implementation of [ProfileRepository] using SharedPreferences.
class ProfileRepositoryImpl implements ProfileRepository {
  static const _keyFirstName = 'profile_firstName';
  static const _keyLastName = 'profile_lastName';
  static const _keyEmail = 'profile_email';

  @override
  Future<Result<Profile>> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final firstName = prefs.getString(_keyFirstName);
      final lastName = prefs.getString(_keyLastName);
      final email = prefs.getString(_keyEmail);

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
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString(_keyFirstName, newProfile.firstName),
        prefs.setString(_keyLastName, newProfile.lastName),
        prefs.setString(_keyEmail, newProfile.email),
      ]);
      return Result(isSuccess: true);
    } catch (e) {
      return Result(isSuccess: false);
    }
  }
}

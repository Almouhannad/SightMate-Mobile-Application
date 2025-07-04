import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

abstract class ProfileRepository {
  Future<Result<Profile>> loadProfile();
  Future<Result> updateProfile(Profile newProfile);
}

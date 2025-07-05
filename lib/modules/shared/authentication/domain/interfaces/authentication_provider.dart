import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/authentication/domain/entities/profile.dart';

abstract class AuthenticationProvider {
  Future<Result<Profile>> login(String email, String password);
  Future<Result<Profile>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  );
  Future<void> logout();
}

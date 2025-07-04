import 'package:dio/src/response.dart';
import 'package:sight_mate/app/config.dart';
import 'package:sight_mate/core/result.dart';
import 'package:sight_mate/modules/shared/api_client/api_client.dart';
import 'package:sight_mate/modules/shared/api_client/secure_storage.dart';
import 'package:sight_mate/modules/shared/authentication/domain/authentication_domain.dart';

class AuthenticationProviderImpl extends AuthenticationProvider {
  final ApiClient _client = ApiClient();
  final String _identityApi = Config.identityApi;
  final String _serverErrorDetailProperty =
      Config.serverErrorDetailPropertyName;
  final String _clientValidationErrorsProperty =
      Config.clientValidationErrorsPropertyName;
  final SecureStorage _keyStorage = SecureStorage.instance;

  @override
  Future<Result<Profile>> login(String email, String password) async {
    Response loginResult;
    try {
      loginResult = await _client.post(
        "$_identityApi/login",
        body: {"email": email, "password": password},
      );
      if (loginResult.statusCode == 400) {
        return _getServerValidationErrors(loginResult);
      }
      if (loginResult.statusCode != 200) {
        return _getServerErrorResult(loginResult);
      }
    } catch (e) {
      return _getNetworkError();
    }
    var token = loginResult.data["token"];
    _keyStorage.writeToken(accessToken: token);
    var getProfileResult = await _getProfile(email, password);
    if (!getProfileResult.isSuccess) {
      _keyStorage.clearTokens();
    }
    return getProfileResult;
  }

  @override
  Future<void> logout() async {
    await _keyStorage.clearTokens();
  }

  @override
  Future<Result<Profile>> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    Response registerResult;
    try {
      registerResult = await _client.post(
        "$_identityApi/register",
        body: {
          "firstname": firstName,
          "lastname": lastName,
          "email": email,
          "password": password,
        },
      );
      if (registerResult.statusCode == 400) {
        return _getServerValidationErrors(registerResult);
      }
      if (registerResult.statusCode != 201) {
        return _getServerErrorResult(registerResult);
      }
    } catch (e) {
      return _getNetworkError();
    }
    return await login(email, password);
  }

  Future<Result<Profile>> _getProfile(String email, String password) async {
    Response profileResult;
    try {
      profileResult = await _client.get("$_identityApi/profile");
      if (profileResult.statusCode != 200) {
        return _getServerErrorResult(profileResult);
      }
    } catch (e) {
      return _getNetworkError();
    }
    var profileData = profileResult.data;
    return Result(
      isSuccess: true,
      value: Profile(
        firstName: profileData['firstName'],
        lastName: profileData['lastName'],
        email: profileData['email'],
      ),
    );
  }

  Result<Profile> _getNetworkError() {
    return Result(
      isSuccess: false,
      error:
          "An error occurred. Please check your internet connection and try again.",
    );
  }

  Result<Profile> _getServerErrorResult(Response response) {
    return Result(
      isSuccess: false,
      error: response.data[_serverErrorDetailProperty],
    );
  }

  Result<Profile> _getServerValidationErrors(Response response) {
    return Result(
      isSuccess: false,
      hasValidationErrors: true,
      validationErrors: response.data[_clientValidationErrorsProperty],
    );
  }
}

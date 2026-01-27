import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like authentication tokens.
/// Uses platform-specific secure storage mechanisms:
/// - Android: EncryptedSharedPreferences
/// - iOS: Keychain
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  /// Saves both access and refresh tokens securely.
  /// Executes both write operations concurrently for better performance.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Retrieves the stored access token.
  /// Returns null if no token is stored.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Retrieves the stored refresh token.
  /// Returns null if no token is stored.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Clears all stored tokens.
  /// Typically called during logout.
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// Checks if an access token exists.
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

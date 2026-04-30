import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ── Storage keys ───────────────────────────
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kLoggedIn = 'isLoggedIn';
  // ── In-memory cache ────────────────────────
  String? _accessToken;
  String? _refreshToken;
  bool _isLoggedIn = false;

  // ── Refresh lock ───────────────────────────
  Completer<bool>? _refreshCompleter;

  // ── Init ──────────────────────────────────
  Future<void> init() async {
    final results = await Future.wait([
      _storage.read(key: _kAccessToken),
      _storage.read(key: _kRefreshToken),
      _storage.read(key: _kLoggedIn),
    ]);

    final String? access = results[0];
    final String? refresh = results[1];
    final bool loggedInFlag = results[2] == 'true';

    // Even if flag is missing, if we have tokens, consider logged in
    _isLoggedIn = loggedInFlag || (access != null && refresh != null);
    _accessToken = _isLoggedIn ? access : null;
    _refreshToken = _isLoggedIn ? refresh : null;

    if (_isLoggedIn) {
      debugPrint('TokenStorage: Initialized. Logged In: $_isLoggedIn');
    }
  }

  // ── Getters ───────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get hasToken => _accessToken?.isNotEmpty ?? false;
  
  bool get hasRefreshToken {
    return _refreshToken != null && _refreshToken!.isNotEmpty;
  }

  Future<String?> getAccessToken() async => _accessToken;
  Future<String?> getRefreshToken() async => _refreshToken;

  // ── JWT Decode ────────────────────────────
  Map<String, dynamic>? _decodePayload(String? jwt) {
    try {
      if (jwt == null || jwt.isEmpty) return null;

      final parts = jwt.split('.');
      if (parts.length != 3) return null;

      return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
    } catch (_) {
      return null;
    }
  }

  bool get isTokenExpired {
    final payload = _decodePayload(_accessToken);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp == null) return false;

    final expiry = DateTime.fromMillisecondsSinceEpoch(
      exp * 1000,
    ).subtract(const Duration(minutes: 2)); // Refresh 2 minutes before actual expiry

    return DateTime.now().isAfter(expiry);
  }

  // ── Save Tokens ───────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken.trim();
    _refreshToken = refreshToken.trim();
    _isLoggedIn = true; 

    debugPrint('Tokens saved in memory: ACCESS=${_accessToken?.substring(0, 10)}..., REFRESH=${_refreshToken?.substring(0, 10)}...');

    await Future.wait([
      _storage.write(key: _kAccessToken, value: _accessToken),
      _storage.write(key: _kRefreshToken, value: _refreshToken),
      _storage.write(key: _kLoggedIn, value: 'true'),
    ]);
  }

  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    await _storage.write(key: _kLoggedIn, value: value.toString());
  }

  // ── Refresh Token ─────────────────────────
  Future<bool> refreshAccessToken(
    Future<Map<String, String>?> Function(String refreshToken) onRefresh,
  ) async {
    if (_refreshCompleter != null) {
      debugPrint('TokenStorage: Refresh already in progress, waiting...');
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      // In-memory se pehle read karo, fir storage se
      String? token = _refreshToken;
      if (token == null || token.isEmpty) {
        debugPrint('TokenStorage: In-memory refresh token missing, reading from storage...');
        token = await _storage.read(key: _kRefreshToken);
      }

      if (token == null || token.isEmpty) {
        debugPrint('TokenStorage: No refresh token found anywhere.');
        _refreshCompleter!.complete(false);
        return false;
      }

      final result = await onRefresh(token);

      if (result == null || result['accessToken'] == null) {
        debugPrint('TokenStorage: onRefresh returned null or missing accessToken.');
        _refreshCompleter!.complete(false);
        return false;
      }

      final newAccess = result['accessToken']!;
      final newRefresh = result['refreshToken'] ?? token; // Fallback to old if new not provided

      await saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      debugPrint('TokenStorage: Tokens updated successfully.');
      _refreshCompleter!.complete(true);
      return true;
    } catch (e) {
      debugPrint('TokenStorage: Exception during refresh: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  // ── Logout ────────────────────────────────
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _isLoggedIn = false;

    await _storage.deleteAll();
  }
}

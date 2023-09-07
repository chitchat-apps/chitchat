import "dart:io";

import "package:chitchat/services/desktop_auth_service.dart";
// import "package:chitchat/services/mobile_auth_service.dart";

class AuthService with AuthServiceMixin {
  late final AuthServiceMixin _authService;

  AuthService() {
    if (Platform.isAndroid || Platform.isIOS) {
      // TODO: Implement mobile auth service
      // _authService = MobileAuthService();
      _authService = DesktopAuthService();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _authService = DesktopAuthService();
    } else {
      throw UnsupportedError("Unsupported platform.");
    }
  }

  @override
  Future<String> signInWithTwitch() {
    return _authService.signInWithTwitch();
  }
}

abstract mixin class AuthServiceMixin {
  Future<String> signInWithTwitch();
}

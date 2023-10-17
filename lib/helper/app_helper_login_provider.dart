import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flexicomponents/extension/app_simple_extensions.dart';
import 'package:flutter/foundation.dart';

enum LoginProvider { google, azure }

extension LoginProviderExtension on LoginProvider {
  String get key {
    switch (this) {
      case LoginProvider.google:
        return 'google';
      case LoginProvider.azure:
        return 'azure';
    }
  }

  String get authorizationEndpoint {
    switch (this) {
      case LoginProvider.google:
        return "https://accounts.google.com/o/oauth2/v2/auth";
      case LoginProvider.azure:
        return "https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize";
    }
  }

  String get authorizeOutEndpoint {
    switch (this) {
      case LoginProvider.google:
        return "https://accounts.google.com/o/oauth2/v2/auth";
      case LoginProvider.azure:
        return "https://login.microsoftonline.com/common/oauth2/v2.0/logout";
    }
  }

  String get tokenEndpoint {
    switch (this) {
      case LoginProvider.google:
        return "https://oauth2.googleapis.com/token";
      case LoginProvider.azure:
        return "https://login.microsoftonline.com/common/oauth2/v2.0/token";
    }
  }

  String get clientId {
    switch (this) {
      case LoginProvider.google:
        return "GOOGLE_CLIENT_ID";
      case LoginProvider.azure:
        return "cdfca89f-87e6-4419-8b16-dca33d94c787";
    }
  }

  List<String> get scopes {
    return ['openid', 'email', 'profile', 'User.Read']; // OAuth Scopes
  }
}

class DesktopOAuthManager extends DesktopLoginManager {
  final LoginProvider loginProvider;
  String? clientId = "cdfca89f-87e6-4419-8b16-dca33d94c787";
  String? appName;
  bool onlyWeb = false;

  DesktopOAuthManager({
    this.loginProvider = LoginProvider.azure,
    this.clientId = "cdfca89f-87e6-4419-8b16-dca33d94c787",
    this.appName = "FlexiComponent",
    this.onlyWeb = false,
  }) : super();

  Future<void> logout() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost

    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${redirectServer?.port}/auth';
    await _getOAuthOutClient(Uri.parse(redirectURL));
    return;
  }
  
  Future<Map<String, dynamic>?> _details({required String? token}) async {
    var response = await http.get(Uri.parse("https://graph.microsoft.com/v1.0/me/"), headers: {"Authorization" : "Bearer $token"});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> SSO() async {
    oauth2.Client loginResult = await login();
    Map<String, dynamic>? userDetails = {};
    if (loginResult.credentials.accessToken.isNotNullOrEmpty) {
      userDetails = await _details(token: loginResult.credentials.accessToken);
      if (userDetails != null) {
        return {
          "result" : loginResult,
          "details" : userDetails
        };
      }
    }
    return {
      "result" : loginResult,
    };
  }

  Future<oauth2.Client> login() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost

    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${redirectServer?.port}/auth';
    var authenticatedHttpClient =
    await _getOAuth2Client(Uri.parse(redirectURL));

    /// HANDLE SUCCESSFULL LOGIN RESPONSE HERE
    return authenticatedHttpClient;
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      clientId.toNotNull,
      Uri.parse(loginProvider.authorizationEndpoint),
      Uri.parse(loginProvider.tokenEndpoint),
      httpClient: _JsonAcceptingHttpClient(),
    );

    var authorizationUrl =
    grant.getAuthorizationUrl(redirectUrl, scopes: loginProvider.scopes);

    await redirect(authorizationUrl, appName: appName, onlyWeb: onlyWeb);
    var responseQueryParameters = await listen();
    var client =
    await grant.handleAuthorizationResponse(responseQueryParameters ?? {});
    return client;
  }

  Future<void> _getOAuthOutClient(Uri redirectUrl) async {
    var uri = Uri.parse("${loginProvider.authorizeOutEndpoint}?post_logout_redirect_uri=${redirectUrl.toString()}");
    var grant = oauth2.AuthorizationCodeGrant(
      clientId.toNotNull,
      uri,
      Uri.parse(loginProvider.tokenEndpoint),
      httpClient: _JsonAcceptingHttpClient(),
    );

    var authorizationUrl =
    grant.getAuthorizationUrl(redirectUrl, scopes: []);
    await redirect(authorizationUrl, appName: appName, onlyWeb: onlyWeb);
    _webview?.close();
    await listen();
    return;
  }
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

class DesktopLoginManager {
  HttpServer? redirectServer;
  oauth2.Client? client;
  Webview? _webview;

  // Launch the URL in the browser using url_launcher
  Future<void> redirect(Uri authorizationUrl, {String? appName, bool onlyWeb = false}) async {
    bool isWebViewAvailable = true;
    if (Platform.isWindows) {
      isWebViewAvailable = await WebviewWindow.isWebviewAvailable();
    }
    if (isWebViewAvailable && !onlyWeb){
      _webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: appName.toNotNull,
          titleBarHeight: 0,
          windowHeight: 520,
          windowWidth: 420,
          userDataFolderWindows: await _getWebViewPath(),
          titleBarTopPadding: Platform.isMacOS ? 30 : 0,
        ),
      );
      _webview
        ?..setBrightness(Brightness.dark)
        ..setApplicationNameForUserAgent("WebviewExample/1.0.0")
        ..launch(authorizationUrl.toString())
        ..addOnUrlRequestCallback((url) {
          final uri = Uri.parse(url);
          if (authorizationUrl.queryParameters[''].toString().contains(url) && uri.queryParameters['code'] != null) {
            _webview?.close();
          } else if (url.contains("logoutsession")) {
            _webview?.close();
          }
        })
        ..onClose.whenComplete(() {
          log("on close");
        });
    } else {
      var url = authorizationUrl;
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw Exception('Could not launch $url');
      }
    }
  }

  Future<Map<String, String>?> listen() async {
    var request = await redirectServer?.first;
    var params = request?.uri.queryParameters;

    request?.response.statusCode = 200;
    request?.response.headers.set('content-type', 'text/plain');
    request?.response.writeln('Authenticated! You can close this tab.');
    await request?.response.close();
    await redirectServer?.close();
    _webview?.close();
    await WindowToFront.activate(); // Using window_to_front package to bring the window to the front after successful login.
    redirectServer = null;
    return params;
  }

  Future<String> _getWebViewPath() async {
    final document = await getTemporaryDirectory();
    return p.join(
      document.path,
      'desktop_webview_window',
    );
  }
}
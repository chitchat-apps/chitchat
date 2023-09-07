import "dart:io";
import "package:chitchat/services/auth_service.dart";
import "package:url_launcher/url_launcher.dart";

class DesktopAuthService with AuthServiceMixin {
  HttpServer? redirectServer;

  @override
  Future<String> signInWithTwitch() async {
    await redirectServer?.close();

    redirectServer = await HttpServer.bind("localhost", 6749);
    final redirectUri = "http://localhost:${redirectServer!.port}/auth";

    var uri = Uri(
      scheme: "https",
      host: "id.twitch.tv",
      path: "/oauth2/authorize",
      queryParameters: {
        "client_id": "cr5v4rf64hsx0n086rmng66l56nr9b",
        "redirect_uri": redirectUri,
        "response_type": "token",
        "scope":
            "chat:read chat:edit user:read:follows user:read:blocked_users user:manage:blocked_users",
        "force_verify": "true",
      },
    );

    await _redirect(uri);
    var responseQueryParams = await _listen();
    var accessToken = responseQueryParams["access_token"];

    if (accessToken != null) {
      return accessToken;
    }

    return Future.error("Could not authenticate.");
  }

  Future<void> _redirect(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception("Could not launch $uri");
    }
  }

  Future<Map<String, String>> _listen() async {
    Map<String, String> params = {};

    await for (HttpRequest request in redirectServer!) {
      if (request.uri.path == "/auth") {
        request.response.headers.set("content-type", "text/html");
        request.response.statusCode = 200;
        request.response.writeln(_getRedirectHtml());
        await request.response.close();
      } else if (request.uri.path == "/callback") {
        request.response.headers.set("content-type", "text/html");
        request.response.statusCode = 200;
        params = request.uri.queryParameters;
        request.response.writeln(_getSuccessHtml());
        await request.response.close();
        await redirectServer!.close();
        redirectServer = null;
      } else {
        request.response.headers.set("content-type", "text/plain");
        request.response.writeln(_getFailedHtml());
        request.response.statusCode = 404;
        await request.response.close();
        await redirectServer!.close();
        redirectServer = null;
      }
    }

    return params;
  }

  String _getSuccessHtml() {
    return """
    <html>
      <head>
        <title>Success!</title>
        $_htmlStyle
      </head>
      <body>
        <h1>Authenticated! You can now close this window.</h1>
      </body>
    </html>
    """;
  }

  String _getFailedHtml() {
    return """
    <html>
      <head>
        <title>Failed!</title>
        $_htmlStyle
      </head>
      <body>
        <h1>Could not authenticated.</h1>
      </body>
    </html>
    """;
  }

  String _getRedirectHtml() {
    return """
    <html>
      <head>
        <title>Loading...</title>
        $_htmlStyle
        <script>
          window.onload = function() {
            const hash = window.location.hash.substring(1);
            window.location.replace("http://localhost:${redirectServer!.port}/callback?" + hash);
          }
        </script>
      </head>
      <body>
        <h1></h1>
      </body>
    </html>
    """;
  }

  final _htmlStyle = """
    <style>
      body {
        font-family: sans-serif;
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 0;
        margin: 0;
      }
    </style>
  """;
}

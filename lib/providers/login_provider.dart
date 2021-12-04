import 'package:parcial_final/models/token.dart';

import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginProvider extends Provider {
  LoginProvider() {
    localPath = "/Account/SocialLogin";
  }

  Future googleLogin(Map<String, dynamic> request) async {
    var url = Uri.parse(baseUrl + localPath);
    var bodyRequest = jsonEncode(request);
    http.Response response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: bodyRequest,
    );

    Token token = Token.fromJson(jsonDecode(response.body));

    return token;
  }
}

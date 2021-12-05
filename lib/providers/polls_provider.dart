import 'package:parcial_final/models/polls.dart';
import 'package:parcial_final/models/response.dart';
import 'package:parcial_final/models/token.dart';

import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PollsProvider extends Provider {
  PollsProvider() {
    localPath = "/Finals";
  }

  Future<Response> getPolls(Token token) async {
    if (!_validToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse(baseUrl + localPath);
    http.Response response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Polls.fromJson(decodedJson));
  }

  Future<Response> saveOrUpdatePolls(Polls poll, Token token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ${token.token}',
    };
    var url = Uri.parse(baseUrl + localPath);
    http.Response response =
        await http.post(url, body: jsonEncode(poll), headers: headers);

    return Response(
        isSuccess: true, result: Polls.fromJson(jsonDecode(response.body)));
  }

  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }
}

import 'package:parcial_final/models/polls.dart';

import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PollsProvider extends Provider {
  PollsProvider() {
    localPath = "/Finals";
  }

  Future<List<Polls>> getPolls() async {
    var url = Uri.parse(baseUrl + localPath);
    http.Response response = await http.get(url);
    List<Polls> polls = [];

    return polls;
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;


class NetworkData {
  NetworkData(this.url);

  final String url;

   Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
    else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }
}


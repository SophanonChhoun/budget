import '../models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<ArticleData> getData() async {
  String url = "http://localhost:8889/db4flutter/read.php";
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return compute(articleDataFromJson, response.body);
  } else {
    throw Exception("Error while reading: ${response.statusCode}");
  }
}

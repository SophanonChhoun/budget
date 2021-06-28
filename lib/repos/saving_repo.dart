import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/saving_model.dart';

Future<SavingModel> readSavingData() async {
  String url = "http://localhost:8889/db4flutter/read_saving_data.php";
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    return compute(savingModelFromJson, response.body);
  } else {
    throw Exception("Exception while reading data!");
  }
}

Future<String> insertSavingData(Saving saving) async {
  String url =
      "http://localhost:8889/db4flutter/read_saving_data.php/insert_saving_data.php";
  http.Response response = await http.post(url, body: saving.toJson());

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Exception while sending data!");
  }
}

Future<String> updateSavingData(Saving saving) async {
  String url =
      "http://localhost:8888/db4flutter/read_saving_data.php/updata_saving_data.php";
  http.Response response = await http.post(url, body: saving.toJson());

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Exception while updating data!");
  }
}

Future<String> deleteSavingData(Saving saving) async {
  String url =
      "http://localhost:8888/db4flutter/read_saving_data.php/delete_saving_data.php";
  http.Response response = await http.post(url, body: saving.toJson());

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Exception while deleting data!");
  }
}

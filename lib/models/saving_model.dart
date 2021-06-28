// To parse this JSON data, do
//
//     final savingModel = savingModelFromJson(jsonString);

import 'dart:convert';

SavingModel savingModelFromJson(String str) => SavingModel.fromJson(json.decode(str));

String savingModelToJson(SavingModel data) => json.encode(data.toJson());

class SavingModel {
  SavingModel({
    this.saving,
  });

  List<Saving> saving;

  factory SavingModel.fromJson(Map<String, dynamic> json) => SavingModel(
    saving: json["saving"] == null ? null : List<Saving>.from(json["saving"].map((x) => Saving.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "saving": saving == null ? null : List<dynamic>.from(saving.map((x) => x.toJson())),
  };
}

class Saving {
  Saving({
    this.id,
    this.title,
    this.note,
    this.amount,
    this.date,
  });

  String id;
  String title;
  String note;
  String amount;
  String date;

  factory Saving.fromJson(Map<String, dynamic> json) => Saving(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    note: json["note"] == null ? null : json["note"],
    amount: json["amount"] == null ? null : json["amount"],
    date: json["date"] == null ? null : json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "note": note == null ? null : note,
    "amount": amount == null ? null : amount,
    "date": date == null ? null : date,
  };
}

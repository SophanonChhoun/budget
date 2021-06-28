// To parse this JSON data, do
//
//     final savingMoney = savingMoneyFromJson(jsonString);

import 'dart:convert';

SavingMoney savingMoneyFromJson(String str) => SavingMoney.fromJson(json.decode(str));

String savingMoneyToJson(SavingMoney data) => json.encode(data.toJson());

class SavingMoney {
  SavingMoney({
    this.savingMoney,
  });

  List<SavingMoneyElement> savingMoney;

  factory SavingMoney.fromJson(Map<String, dynamic> json) => SavingMoney(
    savingMoney: List<SavingMoneyElement>.from(json["Saving_Money"].map((x) => SavingMoneyElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Saving_Money": List<dynamic>.from(savingMoney.map((x) => x.toJson())),
  };
}

class SavingMoneyElement {
  SavingMoneyElement({
    this.id,
    this.amount,
    this.remark,
    this.inputDate,
    this.title,
  });

  String id;
  String amount;
  String remark;
  DateTime inputDate;
  String title;

  factory SavingMoneyElement.fromJson(Map<String, dynamic> json) => SavingMoneyElement(
    id: json["id"],
    amount: json["amount"],
    remark: json["remark"],
    inputDate: DateTime.parse(json["input_date"]),
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "remark": remark,
    "input_date": "${inputDate.year.toString().padLeft(4, '0')}-${inputDate.month.toString().padLeft(2, '0')}-${inputDate.day.toString().padLeft(2, '0')}",
    "title": title,
  };
}

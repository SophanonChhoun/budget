// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromJson(jsonString);

import 'dart:convert';

String expenseModelToJson(ExpenseModel data) => json.encode(data.toJson());
ExpenseModel expenseModelFromJson(String str) => ExpenseModel.fromJson(json.decode(str));


class ExpenseModel {
  ExpenseModel({
    this.expenses,
  });

  List<Expense> expenses;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    expenses: json["expenses"] == null ? null : List<Expense>.from(json["expenses"].map((x) => Expense.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
        "expenses": expenses == null ? null : List<dynamic>.from(expenses.map((x) => x.toJson())),
      };
}

class Expense {
  Expense({
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

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
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

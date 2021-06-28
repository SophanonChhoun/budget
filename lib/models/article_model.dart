// To parse this JSON data, do
//
//     final articleData = articleDataFromJson(jsonString);

import 'dart:convert';

ArticleData articleDataFromJson(String str) => ArticleData.fromJson(json.decode(str));

String articleDataToJson(ArticleData data) => json.encode(data.toJson());

class ArticleData {
  ArticleData({
    this.articles,
  });

  List<Article> articles;

  factory ArticleData.fromJson(Map<String, dynamic> json) => ArticleData(
    articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Article({
    this.shopId,
    this.discount,
    this.discription,
    this.map,
    this.shopName,
    this.img,
  });

  String shopId;
  String discount;
  String discription;
  dynamic map;
  String shopName;
  String img;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    shopId: json["shopID"],
    discount: json["discount"],
    discription: json["discription"],
    map: json["map"],
    shopName: json["shopName"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "shopID": shopId,
    "discount": discount,
    "discription": discription,
    "map": map,
    "shopName": shopName,
    "img": img,
  };
}

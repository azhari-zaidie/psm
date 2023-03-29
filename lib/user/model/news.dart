// ignore_for_file: non_constant_identifier_names

class News {
  int? news_id;
  String? news_title;
  String? news_desc;
  String? main_image;

  News({
    this.news_id,
    this.news_title,
    this.news_desc,
    this.main_image,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        news_id: json["news_id"],
        news_title: json["news_title"],
        news_desc: json["news_desc"],
        main_image: json["news_image"],
      );
}

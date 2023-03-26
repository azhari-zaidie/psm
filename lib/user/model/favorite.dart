class Favorite {
  int? favorite_id;
  int? user_id;
  int? makro_id;
  String? makro_name;
  String? makro_desc;
  String? makro_image;
  int? family_id;
  double? makro_mark;

  Favorite({
    this.favorite_id,
    this.user_id,
    this.makro_id,
    this.makro_name,
    this.makro_desc,
    this.makro_image,
    this.family_id,
    this.makro_mark,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favorite_id: int.parse(json["favorite_id"]),
        user_id: int.parse(json["user_id"]),
        makro_id: int.parse(json["makro_id"]),
        makro_name: json["makro_name"],
        makro_desc: json["makro_desc"],
        makro_image: json["makro_image"],
        family_id: int.parse(json["family_id"]),
        makro_mark: double.parse(json['makro_mark']),
      );
}

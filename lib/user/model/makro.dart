// ignore_for_file: non_constant_identifier_names

class Makro {
  int? makro_id;
  String? makro_name;
  String? makro_desc;
  String? makro_image;
  int? family_id;
  int? makro_mark;
  String? makro_features;

  Makro({
    this.makro_id,
    this.makro_name,
    this.makro_desc,
    this.makro_image,
    this.family_id,
    this.makro_mark,
    this.makro_features,
  });

  factory Makro.fromJson(Map<String, dynamic> json) => Makro(
        makro_id: json["makro_id"],
        makro_name: json["makro_name"],
        makro_desc: json["makro_desc"],
        makro_image: json["makro_image"],
        family_id: json["family_id"],
        makro_mark: json["makro_mark"],
        makro_features: json["makro_features"],
      );
}

class FamilyMakro {
  int? family_id;
  String? family_name;
  String? family_desc;
  String? family_image;

  FamilyMakro({
    this.family_id,
    this.family_name,
    this.family_desc,
    this.family_image,
  });

  factory FamilyMakro.fromJson(Map<String, dynamic> json) => FamilyMakro(
        family_id: json["family_id"],
        family_name: json["family_name"],
        family_desc: json["family_desc"],
        family_image: json["family_image"],
      );
}

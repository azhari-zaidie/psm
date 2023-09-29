// ignore_for_file: non_constant_identifier_names

class Makro {
  int? makro_id;
  String? makro_name;
  String? makro_desc;
  String? makro_image;
  int? family_id;
  int? makro_mark;
  String? makro_features;
  String? status;
  String? url;

  Makro({
    this.makro_id,
    this.makro_name,
    this.makro_desc,
    this.makro_image,
    this.family_id,
    this.makro_mark,
    this.makro_features,
    this.status,
    this.url,
  });

  factory Makro.fromJson(Map<String, dynamic> json) => Makro(
        makro_id: json["makro_id"],
        makro_name: json["makro_name"],
        makro_desc: json["makro_desc"],
        makro_image: json["makro_image"],
        family_id: json["family_id"],
        makro_mark: json["makro_mark"],
        makro_features: json["makro_features"],
        status: json["status"],
        url: json["url"],
      );
}

class MakroFeature {
  int? id;
  int? makroId;
  String? featureName;
  String? featureDesc;
  String? featureImage;
  String? url;

  MakroFeature({
    this.id,
    this.makroId,
    this.featureName,
    this.featureDesc,
    this.featureImage,
    this.url,
  });

  factory MakroFeature.fromJson(Map<String, dynamic> json) => MakroFeature(
        id: json["id"],
        makroId: json["makro_id"],
        featureName: json["feature_name"],
        featureDesc: json["feature_desc"],
        featureImage: json["feature_image"],
        url: json["url"],
      );
}

class FamilyMakro {
  int? family_id;
  String? family_name;
  String? family_desc;
  String? family_image;
  String? status;
  String? family_scientific_name;
  String? url;

  FamilyMakro({
    this.family_id,
    this.family_name,
    this.family_desc,
    this.family_image,
    this.status,
    this.family_scientific_name,
    this.url,
  });

  factory FamilyMakro.fromJson(Map<String, dynamic> json) => FamilyMakro(
        family_id: json["family_id"],
        family_name: json["family_name"],
        family_desc: json["family_desc"],
        family_image: json["family_image"],
        status: json["status"],
        family_scientific_name: json["family_scientific_name"],
        url: json["url"],
      );
}

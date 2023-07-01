// ignore_for_file: non_constant_identifier_names

class Record {
  int? record_id;
  String? selected_makro;
  int? user_id;
  DateTime? created_at;
  double? record_average;
  String? location;
  double? latitude;
  double? longitude;
  String? record_desc;

  Record({
    this.record_id,
    this.selected_makro,
    this.user_id,
    this.created_at,
    this.record_average,
    this.location,
    this.latitude,
    this.longitude,
    this.record_desc,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        record_id: json["record_id"],
        selected_makro: json["selected_makro"].toString(),
        user_id: json["user_id"],
        created_at: DateTime.parse(json["created_at"]),
        record_average: double.parse(json["record_average"]),
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        record_desc: json["record_desc"],
      );

  Map<String, dynamic> toJson() => {
        "selected_makro": selected_makro,
        "user_id": user_id.toString(),
        "record_average": record_average!.toStringAsFixed(2),
        "location": location,
        "latitude": latitude!.toString(),
        "longitude": longitude!.toString(),
        "record_desc": record_desc,
      };
}

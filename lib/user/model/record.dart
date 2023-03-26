// ignore_for_file: non_constant_identifier_names

class Record {
  int? record_id;
  String? selected_makro;
  int? user_id;
  DateTime? record_date;
  double? record_average;

  Record({
    this.record_id,
    this.selected_makro,
    this.user_id,
    this.record_date,
    this.record_average,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        record_id: int.parse(json["record_id"]),
        selected_makro: json["selected_makro"],
        user_id: int.parse(json["user_id"]),
        record_date: DateTime.parse(json["record_date"]),
        record_average: double.parse(json["record_average"]),
      );

  Map<String, dynamic> toJsonn() => {
        "record_id": record_id.toString(),
        "selected_makro": selected_makro,
        "user_id": user_id.toString(),
        "record_average": record_average!.toStringAsFixed(2),
      };
}

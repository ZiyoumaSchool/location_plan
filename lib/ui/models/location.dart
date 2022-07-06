import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 1)
class LocationMap {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? surname;

  @HiveField(2)
  String? phone;

  @HiveField(3)
  String? describe;

  @HiveField(4)
  double? lat;

  @HiveField(5)
  double? lng;

  @HiveField(6)
  String? path;

  LocationMap({
    this.name,
    this.surname,
    this.phone,
    this.describe,
    this.lat,
    this.lng,
    this.path,
  });
}

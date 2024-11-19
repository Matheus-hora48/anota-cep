import 'dart:convert';

class LocationModel {
  final int? id;
  final String zipCode;
  final String address;
  final String? lat;
  final String? lng;
  final String? number;
  final String? complement;

  LocationModel({
    this.id,
    required this.zipCode,
    required this.address,
    required this.lat,
    required this.lng,
    this.number,
    this.complement,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] as int,
      zipCode: map['zipCode'] as String,
      address: map['address'] as String,
      lat: map['lat'] as String?,
      lng: map['lng'] as String?,
      number: map['number'] as String?,
      complement: map['complement'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zipCode': zipCode,
      'address': address,
      'number': number,
      'complement': complement,
    };
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

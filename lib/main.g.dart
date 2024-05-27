// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'main.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// Polygon _$PolygonFromJson(Map<String, dynamic> json) => Polygon(
//       bbox: json['bbox'] == null
//           ? null
//           : BBox.fromJson(json['bbox'] as Map<String, dynamic>),
//       coordinates: (json['coordinates'] as List<dynamic>?)
//               ?.map((e) => (e as List<dynamic>)
//                   .map((e) => Position.fromJson(e as Map<String, dynamic>))
//                   .toList())
//               .toList() ??
//           const [],
//     );
//
// Map<String, dynamic> _$PolygonToJson(Polygon instance) => <String, dynamic>{
//       'coordinates': instance.coordinates
//           .map((e) => e.map((e) => e.toJson()).toList())
//           .toList(),
//       'bbox': instance.bbox?.toJson(),
//     };
//
// Position _$PositionFromJson(Map<String, dynamic> json) => Position(
//       (json['latitude'] as num).toDouble(),
//       (json['longitude'] as num).toDouble(),
//     );
//
// Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
//       'latitude': instance.latitude,
//       'longitude': instance.longitude,
//     };
//
// BBox _$BBoxFromJson(Map<String, dynamic> json) => BBox(
//       (json['west'] as num).toDouble(),
//       (json['south'] as num).toDouble(),
//       (json['east'] as num).toDouble(),
//       (json['north'] as num).toDouble(),
//     );
//
// Map<String, dynamic> _$BBoxToJson(BBox instance) => <String, dynamic>{
//       'west': instance.west,
//       'south': instance.south,
//       'east': instance.east,
//       'north': instance.north,
//     };
//
// Point _$PointFromJson(Map<String, dynamic> json) => Point(
//       Position.fromJson(json['coordinates'] as Map<String, dynamic>),
//     );
//
// Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
//       'coordinates': instance.coordinates,
//     };

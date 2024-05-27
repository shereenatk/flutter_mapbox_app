import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(MaterialApp(home: FullMap()));
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  PolygonAnnotation? polygon;
  PolygonAnnotationManager? polygonAnnotationManager;
  PointAnnotationManager? pointAnnotationManager;
  List<PointAnnotation> pointAnnotations = [];
  int? activePointIndex;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    this.mapboxMap?.setCamera(CameraOptions(
      center: Point(coordinates: Position(55.2708, 25.2048)).toJson(),
      zoom: 12.0,
    ));

    _addPolygon();
  }

  int _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor; // Add the alpha value if not provided
    }
    return int.parse(hexColor, radix: 16);
  }

  Future<void> _addPolygon() async {
    if (mapboxMap != null) {
      polygonAnnotationManager = await mapboxMap!.annotations.createPolygonAnnotationManager();
      pointAnnotationManager = await mapboxMap!.annotations.createPointAnnotationManager();

      List<List<double>> points = [
        [55.2708, 25.2048],
        [55.2708, 25.2148],
        [55.2808, 25.2148],
        [55.2808, 25.2048],
        [55.2758, 25.2098], // Example additional point
      ];

      Map<String?, Object?> geometry = {
        'type': 'Polygon',
        'coordinates': [points]
      };

      PolygonAnnotationOptions polygonOptions = PolygonAnnotationOptions(
        geometry: geometry,
        fillColor: _colorFromHex("#FF0000"),
        fillOutlineColor: _colorFromHex("#ffffff"),
        fillOpacity: 0.8,
      );

      polygon = await polygonAnnotationManager!.create(polygonOptions);
      final ByteData bytes = await rootBundle.load('assets/pin.png');
      final Uint8List list = bytes.buffer.asUint8List();

      for (var point in points) {
        PointAnnotationOptions pointOptions = PointAnnotationOptions(
          geometry: Point(coordinates: Position(point[0], point[1])).toJson(),
          image: list,
        );
        pointAnnotations.add(await pointAnnotationManager!.create(pointOptions));
      }

      // Add click listener to update polygon when a point is clicked
      pointAnnotationManager!.addOnPointAnnotationClickListener(
        _CustomPointAnnotationClickListener(this),
      );
    }
  }

  Future<void> _updatePolygon() async {
    if (polygonAnnotationManager != null && polygon != null) {
      List<List> updatedPoints = pointAnnotations.map((pointAnnotation) {
        var point = pointAnnotation.geometry as Map<String, dynamic>;
        var coordinates = point['coordinates'];
        return [coordinates[1], coordinates[0]];
      }).toList();

      await polygonAnnotationManager!.delete(polygon!);

      Map<String?, Object?> geometry = {
        'type': 'Polygon',
        'coordinates': [updatedPoints]
      };

      PolygonAnnotationOptions polygonOptions = PolygonAnnotationOptions(
        geometry: geometry,
        fillColor: _colorFromHex("#FF0000"),
        fillOutlineColor: _colorFromHex("#ffffff"),
        fillOpacity: 0.8,
      );

      polygon = await polygonAnnotationManager!.create(polygonOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: _onLongPressStart,
        onLongPressMoveUpdate: _onLongPressMoveUpdate,
        onLongPressEnd: _onLongPressEnd,
        child: IgnorePointer(
          ignoring: activePointIndex != null,
          child: MapWidget(
            key: ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(25.2048, 55.2708)).toJson(),
              zoom: 12.0,
            ),
            styleUri: "mapbox://styles/mapbox/streets-v9/",
          ),
        ),
      ),
    );
  }

  void _onLongPressStart(LongPressStartDetails details) {
    print("started");
    // Find the nearest point annotation to the press start position
    double minDistance = double.infinity;
    int? closestPointIndex;

    for (int i = 0; i < pointAnnotations.length; i++) {
      final point = pointAnnotations[i];
      final pointCoords = point.geometry?['coordinates'] as List;
      final pointPosition = Offset(pointCoords[0], pointCoords[1]);

      final distance = (details.localPosition - pointPosition).distance;
      if (distance < minDistance) {
        minDistance = distance;
        closestPointIndex = i;
      }
    }

    if (minDistance < 20.0) { // threshold distance to consider a point "selected"
      setState(() {
        activePointIndex = closestPointIndex;
      });
      print('Point selected: $activePointIndex');
    }
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (activePointIndex != null) {
      final pointAnnotation = pointAnnotations[activePointIndex!];
      final newCoordinates = [
        details.localPosition.dx,
        details.localPosition.dy,
      ];

      // Update the geometry of the active point annotation
      pointAnnotation.geometry?['coordinates'] = newCoordinates;

      // Update the point annotation in the manager
      pointAnnotationManager?.update(pointAnnotation);

      print('Point moved: $newCoordinates');
    }
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (activePointIndex != null) {
      final pointAnnotation = pointAnnotations[activePointIndex!];
      final newCoordinates = [
        details.localPosition.dx,
        details.localPosition.dy,
      ];

      // Update the geometry of the active point annotation
      pointAnnotation.geometry?['coordinates'] = newCoordinates;

      // Redraw the polygon with updated points
      _updatePolygon();

      // Reset the active point index
      setState(() {
        activePointIndex = null;
      });
      print('Point position finalized: $newCoordinates');
    }
  }
}

class _CustomPointAnnotationClickListener extends OnPointAnnotationClickListener {
  final FullMapState parent;

  _CustomPointAnnotationClickListener(this.parent);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    // Implement logic for handling point annotation click event
    print('Point annotation clicked: ${annotation.id}');
  }
}

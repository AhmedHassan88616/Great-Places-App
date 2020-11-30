import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticGoogleMap extends StatefulWidget {
  final Position _currentPosition;

  StaticGoogleMap(this._currentPosition);

  @override
  _StaticGoogleMapState createState() => _StaticGoogleMapState();
}

class _StaticGoogleMapState extends State<StaticGoogleMap> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          (widget._currentPosition).latitude,
          (widget._currentPosition).longitude,
        ),
        zoom: 16.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId('m1'),
          position: LatLng(
            (widget._currentPosition).latitude,
            (widget._currentPosition).longitude,
          ),
        ),
      },
    );
  }
}

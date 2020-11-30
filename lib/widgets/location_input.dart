import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:great_places_app/widgets/static_google_map.dart';

class LocationInput extends StatefulWidget {
  Function _selectPlace;

  LocationInput(this._selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _getLocation = false;
  Position _currentPosition;

  Future<void> _getCurrentUserLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _getLocation = true;
      });
      widget._selectPlace(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _currentPosition = Position(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    setState(() {
      _getLocation = true;
    });
    widget._selectPlace(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: !_getLocation
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : StaticGoogleMap(_currentPosition),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.location_on,
              ),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.map,
              ),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}

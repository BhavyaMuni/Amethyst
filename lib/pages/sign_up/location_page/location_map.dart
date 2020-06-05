import 'package:amethyst_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMap extends StatefulWidget {
  LocationMap({Key key}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  Placemark _place;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${_place.locality}, ${_place.country}",
          style: TextStyles().headerTextStyle().copyWith(fontSize: 36),
        ),
        // Text(
        //   "Enter location manually",
        //   style: TextStyles().subheaderTextStyle().copyWith(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w300,
        //       color: Colors.blueAccent),
        // ),
        SizedBox(height: 50),
        Container(
          height: 300,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, gradient: TextStyles().baseGrad()),
          child: CircleAvatar(
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(_place.position.latitude,
                          _place.position.longitude)))),
        )
      ],
    );
  }

  Future<void> _getLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    GeolocationStatus status =
        await geolocator.checkGeolocationPermissionStatus();
    Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    List<Placemark> placemark =
        await geolocator.placemarkFromPosition(position);
    setState(() {
      _place = placemark[0];
    });
  }
}

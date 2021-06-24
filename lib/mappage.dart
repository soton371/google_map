import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  double lat, lon;

  getLatLan() async{
    var getposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = getposition.latitude;
      lon = getposition.longitude;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("map"),
      ),
      body: Center(
        child: Container(
          //height: 300,
          //width: double.infinity,
          child: GoogleMap(
              initialCameraPosition:
              CameraPosition(target: LatLng(lat, lon), zoom: 15)),
        ),
      ),
    );
  }
}

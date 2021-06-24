import 'dart:async';
import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Geolocatorapp extends StatefulWidget {
  @override
  _GeolocatorappState createState() => _GeolocatorappState();
}

class _GeolocatorappState extends State<Geolocatorapp> {

  String latitudedata = '';
  String longgitudedata = '';
  Position _position;
  StreamSubscription<Position> streamSubscription;
  Address _address;

  Future convertCoordinateToAddress(Coordinates coordinates) async {
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return address.first;
  }

  getLocation() async{
    final geoposition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    streamSubscription = Geolocator().getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _position = position;

        final coordinates = new Coordinates(
            position.latitude, position.longitude);
        convertCoordinateToAddress(coordinates).then((value) =>
        _address = value);
      });

    });

    setState(() {
      latitudedata = '${geoposition.latitude}';
      longgitudedata = '${geoposition.longitude}';
    });

  }

  var _tem, _hum, _win;
  Future getweatherinfo() async{
    //http.Response _respone = await http.get("https://api.openweathermap.org/data/2.5/weather?q=Dhaka&appid=32511dee4a22469574a36f13f8be3c55");
    http.Response _respone = await http.get("api.openweathermap.org/data/2.5/weather?lat=${latitudedata.toString()}&lon=${longgitudedata.toString()}&appid=32511dee4a22469574a36f13f8be3c55");

    var js = jsonDecode(_respone.body);
    setState(() {
      this._tem = js ["main"] ["temp"];
      this._hum = js ["main"] ["humidity"];
      this._win = js ["wind"] ["speed"];
    });
  }

  @override
  void initState(){
    super.initState();
    getLocation();
    getweatherinfo();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("adafdf"),
      ),

      body: Center(
        child: Column(
          children: [
          Row(
            children: [
              Text('latitude :'),
              Text(latitudedata),
            ],
          ),
          Row(
            children: [
              Text('longgitudedata :'),
              Text(longgitudedata),
            ],
          ),
          Row(
            children: [
              Text('address :'),
              Text(_address?.addressLine ?? "a s d q f"),
            ],
          ),
            Row(
              children: [
                Text('Temperature: '),
                Text(_tem != null ? _tem.toString()+"\u00B0" : "not send")
              ],
            ),
            Row(
              children: [
                Text('Humidity: '),
                Text(_hum != null ? _hum.toString()+"%" : "not send")
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('Wind: '),
                Text(_win != null ? _win.toString()+"km/h" : "not send")
              ],
            )
        ]
    )


    )
    );
  }
}

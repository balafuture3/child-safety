import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:childsafety/home_screen.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'Model/DataModel.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(
    ));
  }
}



class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}


class MapSampleState extends State<MapSample> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  double lat=0;
  double lon=0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

late Position position;

  var marker= [Marker(markerId: MarkerId("1"),position: LatLng(0, 0))];

  late DataModelList liRes1;
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    await Geolocator.getCurrentPosition().then((value){
      lat=value.latitude;
      lon=value.longitude;
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          // tilt: 59.440717697143555,
          zoom: 19.151926040649414);
      _goToTheLake();

    });
  }
  String value1 = "36";
  String value2 = "14";

  late Timer t;
  late Timer t1;

  bool loading = false;

  late DataModel liRes;
  Future<Response> getData() async {
    var url;

    url = Uri.parse("http://www.balasblog.co.in/test.php");

    print(url);
    // print(headers);

    setState(() {
      loading = true;
    });

    var response = await http.get(
      url,
    );
    print(response.body);
    if (response.statusCode == 200)
    {
      liRes = DataModel.fromJson(jsonDecode(response.body));
      setState(() {
        marker.clear();
        marker.add(Marker(markerId: MarkerId("1"),position: LatLng(double.parse(liRes.location!.split(',')[0]), double.parse(liRes.location!.split(',')[1]))));
        _kLake = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(double.parse(liRes.location!.split(',')[0]), double.parse(liRes.location!.split(',')[1])),
            // tilt: 59.440717697143555,
            zoom: 19.151926040649414);
        _goToTheLake();
      });
    }

    setState(() {
      loading = false;
    });
    return response;
  }
  Future<void> onSelectNotification(String payload) async {
    debugPrint("payload : $payload");
    showDialog(
      context: this.context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }
  showNotification() async {
    var android = const AndroidNotificationDetails(
        'channel id', 'channel NAME',
        priority: Priority.high,importance: Importance.max
    );
    var platform = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
        0, 'Your Child is unsafe', 'Location=${liRes.location}\nTemperature=${liRes.temp!.split(",")[0]},Humidity=${liRes.temp!.split(",")[1]}', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetttings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    getData();
    t1 = Timer.periodic(const Duration(seconds: 10), (timer) {
      getData();

    });
   // _determinePosition();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    t1.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  Future<void> generateExcel() async {
    var url;

    url = Uri.parse("http://www.balasblog.co.in/test1.php");

    print(url);
    // print(headers);

    setState(() {
      loading = true;
    });

    var response = await http.get(
      url,
    );
    print(response.body);
    if (response.statusCode == 200) {
      liRes1 = DataModelList.fromJson(jsonDecode(response.body));
      var excel = Excel.createExcel();


      var sheet = excel['Sheet1'];

      var colIterables = ['A', 'B', 'C', 'D', 'E'];
      int colIndex = 0;
      sheet.cell(CellIndex.indexByColumnRow(
        rowIndex: 0,
        columnIndex: colIndex,
      ))
          .value = "Temperature";

      for (var colValue in liRes1.details) {
        sheet.cell(CellIndex.indexByColumnRow(
          rowIndex: liRes1.details.indexOf(colValue)+1,
          columnIndex: colIndex,
        ))
            .value = colValue.temp?.split(",")[0].toString();
      }
       colIndex = 1;
      sheet.cell(CellIndex.indexByColumnRow(
        rowIndex: 0,
        columnIndex: colIndex,
      ))
          .value = "Humidity";
      for (var colValue in liRes1.details) {
        sheet.cell(CellIndex.indexByColumnRow(
          rowIndex: liRes1.details.indexOf(colValue)+1,
          columnIndex: colIndex,
        ))
            .value = colValue.temp?.split(",")[1].toString();
      }


      colIndex = 2;
      sheet.cell(CellIndex.indexByColumnRow(
        rowIndex: 0,
        columnIndex: colIndex,
      ))
          .value = "Location";
      for (var colValue in liRes1.details) {
        sheet.cell(CellIndex.indexByColumnRow(
          rowIndex: liRes1.details.indexOf(colValue)+1,
          columnIndex: colIndex,
        ))
            .value = colValue.location;
      }
      // colIndex = 1;
      //
      // liRes1.details.forEach((colValue) {
      //   sheet.cell(CellIndex.indexByColumnRow(
      //     rowIndex: colIterables.indexOf(colValue.location.toString()),
      //     columnIndex: colIndex,
      //   ))
      //     ..value = colValue.location.toString();
      // });

      // Saving the file
      final directory = await getExternalStorageDirectory();
      String outputFile = "${directory?.path}/r.xlsx";
      print(outputFile);

      //stopwatch.reset();
      List<int>? fileBytes = excel.save();
      //print('saving executed in ${stopwatch.elapsed}');
      if (fileBytes != null) {
        File(join(outputFile))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Maps"),
      actions: [
        InkWell(onTap:(){

          generateExcel();
        },child: Icon(Icons.download))
      ],) ,
      body: SafeArea(
        child: GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          markers: Set<Marker>.of(marker),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton:  Opacity(
    opacity: 0, // Set it to 0
    child:FloatingActionButton.extended(

        onPressed: showNotification,
        label: const Text('Notify'),
        icon: const Icon(Icons.directions_boat),
      ),
    ));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
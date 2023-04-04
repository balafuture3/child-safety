import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:childsafety/Model/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
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
        value1 = liRes.temp!.split(',')[0].toString();
        value2 = liRes.temp!.split(',')[1].toString();
      });
    }

    setState(() {
      loading = false;
    });
    return response;
  }

  @override
  void initState() {
    getData();
    t1 = Timer.periodic(const Duration(seconds: 10), (timer) {
      getData();

    });
    // t = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     Random rnd;
    //     int min = 35;
    //     int max = 38;
    //     rnd = new Random();
    //     value1 = min + rnd.nextInt(max - min);
    //   });
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    // t1.cancel();?    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Temperature and Humidity"),
          ),
          body: loading?CircularProgressIndicator():Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          " Temperature  :  $value1 'C",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(" Humidity : $value2",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800)),
                      )
                    ]),
              ))),
    );
  }
}

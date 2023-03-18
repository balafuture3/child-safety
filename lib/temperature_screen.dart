import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  int value1 = 36;
  int value2 = 14;

  late Timer t;
  late Timer t1;

  @override
  void initState() {
    t1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        Random rnd;
        int min = 14;
        int max = 20;
        rnd = new Random();
        value2 = min + rnd.nextInt(max - min);
      });
    });
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        Random rnd;
        int min = 35;
        int max = 38;
        rnd = new Random();
        value1 = min + rnd.nextInt(max - min);
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    t1.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Temperature and Humidity"),
          ),
          body: Container(
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

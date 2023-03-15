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

  int value1=36;

  late Timer t;
  @override
  void initState() {
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
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Temperature"),),
          body: Center(
              child: Container(
                  child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(minimum: 0, maximum: 50,
                            ranges: <GaugeRange>[
                              GaugeRange(startValue: 0, endValue: 20, color:Colors.green),
                              GaugeRange(startValue: 20,endValue: 35,color: Colors.orange),
                              GaugeRange(startValue: 35,endValue: 50,color: Colors.red)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: value1.toDouble())],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(widget: Container(child:
                              Text(value1.toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                                  angle: 90, positionFactor: 0.5
                              )]
                        )])
              ))),
    );
  }
}

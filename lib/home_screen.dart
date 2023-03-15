import 'package:childsafety/main.dart';
import 'package:childsafety/mic_screen.dart';
import 'package:childsafety/temperature_screen.dart';
import 'package:childsafety/video_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Child Safety"),),
      body: Center(
        child: GridView.count(
          children:[
            InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>MapSample()));
            },
            child: Container(
              margin: EdgeInsets.all(20),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),


                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map),
                    Text("Live Track")
                  ],
                )
            ),
          ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>VideoScreen()));
              },
              child: Container(
                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),


                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.ondemand_video_outlined),
                      Text("Video")
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>PlayFromMic()));
              },
              child: Container(
                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),


                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic),
                      Text("Mic")
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>TempScreen()));
              },
              child: Container(
                  margin: EdgeInsets.all(20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),


                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart),
                      Text("Temperature")
                    ],
                  )
              ),
            ),
          ], crossAxisCount: 3,

        ),
      ),
    );
  }
}

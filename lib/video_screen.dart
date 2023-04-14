
import 'package:native_screenshot/native_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late WebViewController controller;

  @override
  void initState() {

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          // onPageStarted: (String url) {},
          // onPageFinished: (String url) {},
          // onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('http://192.168.43.9/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ;
    controller.setUserAgent("Chrome");
    controller.clearCache();
    controller.clearLocalStorage();
    controller.loadRequest(Uri.parse('http://172.20.10.3'))
      // ..loadRequest(Uri.parse('http://www.youtube.com/'))
    ;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        String? path = await NativeScreenshot.takeScreenshot();
        print(path);
        var request = http.MultipartRequest('POST', Uri.parse('http://www.balasblog.co.in/upload.php'));
        request.fields.addAll({
          'btn': 'upload'
        });
        request.files.add(await http.MultipartFile.fromPath('image', path!));

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
          showDialog(context: context, builder: (BuildContext context) { return AlertDialog(
            title: Text("Uploaded to server"),
            content: TextField(
              controller: TextEditingController(text: "http://www.balasblog.co.in/uploads/${path.split("/")[5]}"),
            ),
          );});
        }
        else {
          showDialog(context: context, builder: (BuildContext context) { return AlertDialog(
            title: Text("Error"),
            content: Text("Please take screenshot again")
          );});
          print(response.reasonPhrase);
        }

        // await launchUrl(Uri.parse("http://192.168.43.9/"));
      },child: Icon(Icons.screenshot),),
    );
  }
}

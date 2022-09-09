import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'image_sticking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// When using flutter 3.0, WebView encounters residual image problems. Flutter 2.10.3 is good。
/// flutter 3.0 ios is good。android is has problems,android os 9.0
/// This is an example of loading a 3D file using WebView modelviewer，
/// This is using the modelviewer address ：https://modelviewer.dev/
///
class _MyHomePageState extends State<MyHomePage> {
  /// The link to the 3d file must be a web address
  // var gltf =
  //     'http://51xingkong.oss-cn-qingdao.aliyuncs.com/6904a922e6b60ab8ee20a14e9ff97c80%20_1_.gltf';
  var gltf =
      'https://raw.githubusercontent.com/lisen87/image_sticking/master/6904a922e6b60ab8ee20a14e9ff97c80%20_1.gltf';
  late var html = '''
          <html>
              <script type='module' src='https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js'></script>
              <script>
                          function sendProgress (message){
                            progress.postMessage(message)
                          }
              </script>
              <style>
                   #lazy-load-poster {
                }
                #button-load {
                }
                  model-viewer {
                    width: 100%;
                    height: 100%;
                    margin: -10;
                    padding: -10;
                    background-color: transparent;
                  }
                   model-viewer#reveal {
                    --poster-color: transparent;
                   }
              </style>
              <!-- Use it like any other HTML element -->
              <body style='margin:0;padding:0'>
              <div class="demo" style="background: transparent; overflow-x: hidden;">
                  <model-viewer id='dimension-demo'
                                src='$gltf'
                                shadow-intensity="1" camera-controls auto-rotate interaction-prompt="none"
                                camera-orbit="0deg 90deg 105%"
                                scale="1.2 1.2 1.2"
                                exposure="1.0"
                                rotation-per-second="20deg" auto-rotate-delay=1000
                                style="background-color: transparent;">
                      <div slot="poster" style="background: transparent;"></div>
                      <div slot="poster"></div>
                      <div slot="progress-bar"></div>
                  </model-viewer>
              </div>
              <script type="module">
                    const modelViewer = document.querySelector('#dimension-demo');
                    modelViewer.addEventListener('progress', (e) => {
                      sendProgress(e.detail.totalProgress)
                    });
              </script>
              </body>
       </html>''';

  var progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Text(
            'progress : $progress',
            style: const TextStyle(fontSize: 20),
          ),
          WebView(
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                  name: 'progress',
                  onMessageReceived: (JavascriptMessage message) async {
                    setState(() {
                      print('progress---> : ${message.message}');
                      progress = double.parse(message.message) * 100;
                    });
                  })
            },
            backgroundColor: Colors.transparent,
            initialUrl: Uri.dataFromString(html,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString(),
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const MyApp());
}

const step = 10.0;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;
  double _x = 100;
  double _y = 100;

  /*@override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }*/

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        /*appBar: AppBar(
          title: const Text('Unity Flutter Demo'),
        ),*/
        body: Card(
          margin: const EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                fullscreen: false,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                // <You need a PointerInterceptor here on web>

                child: Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0, 0.8),
                      child: Joystick(
                        listener: (details) {
                          setState(() {
                            _x = _x + step * details.x;
                            _y = _y + step * details.y;
                          });
                          setLocation1((details.x).toString());
                          setLocation((details.y).toString());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Communcation from Flutter to Unity
  void setLocation(String location) {
    _unityWidgetController?.postMessage(
      'Walking',
      'setLocation',
      location,
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      print('Received scene loaded from unity: ${sceneInfo.name}');
      print(
          'Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }

  void setLocation1(String location1) {
    _unityWidgetController?.postMessage(
      'Walking',
      'setLocation1',
      location1,
    );
  }
}

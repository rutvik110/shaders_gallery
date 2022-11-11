import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shaders_gallery/character_outline/character_outline.dart';
import 'package:shaders_gallery/image_transition_view/image_transition_view.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

late final ui.Image image;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dashImage = await rootBundle.load('assets/images/dash.png');
  final bytes = dashImage.buffer.asUint8List();
  image = await decodeImageFromList(bytes);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageTransitionView(),
    );
  }
}

class StripesShaderView extends StatefulWidget {
  const StripesShaderView({Key? key}) : super(key: key);

  @override
  State<StripesShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderView> {
  late Future<CharacterOutline> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = CharacterOutline.compile();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<CharacterOutline>(
        future: helloWorld,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ShaderMask(
              child: const SizedBox.expand(
                child: ColoredBox(
                  color: Colors.white,
                ),
              ),
              shaderCallback: (rect) {
                return snapshot.data!.shader(
                  resolution: rect.size,
                  image: image,
                  lineColor: Vector4(0.086, 0.193, 1.000, 1.0),
                  lineThickness: 10,
                  imageResolution: Vector2(
                    rect.size.width,
                    rect.size.height,
                  ),

                  uTime: delta,
                  // tiles: 8,
                  // speed: delta / 30,
                  // direction: 0.75, // -1 to 1
                  // warpScale: 0.1,
                  // warpTiling: 0.8,
                  // color1: Vector3(0.086, 0.193, 1.000),
                  // color2: Vector3(0.044, 0.895, 1.000),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

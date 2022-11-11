import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shaders_gallery/music_shader/music_shader_view.dart';

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
      debugShowCheckedModeBanner: false,
      home: const MusicShaderView(),
    );
  }
}

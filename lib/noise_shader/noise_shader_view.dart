import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shaders_gallery/main.dart';
import 'package:shaders_gallery/noise_shader/noise_shader.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class NoiseShaderView extends StatefulWidget {
  const NoiseShaderView({Key? key}) : super(key: key);

  @override
  State<NoiseShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<NoiseShaderView>
    with SingleTickerProviderStateMixin {
  late Future<NoiseShader> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      if (mounted) {
        setState(() {
          delta += 1 / 60;
        });
      }
    })
      ..start();
    helloWorld = NoiseShader.compile();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<NoiseShader>(
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
                  frequency: Vector2(5, 5),
                  amplifier: 10,
                  scale: Vector2(
                    10,
                    10,
                  ),
                  time: delta,

                  // uTime: delta,
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

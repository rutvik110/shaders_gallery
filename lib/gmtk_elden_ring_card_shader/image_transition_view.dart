import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shaders_gallery/gmtk_elden_ring_card_shader/gmtk_elden_ring_cards_inspired_shader.dart';
import 'package:shaders_gallery/main.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class GMTKELDENRIGNCARD extends StatefulWidget {
  const GMTKELDENRIGNCARD({Key? key}) : super(key: key);

  @override
  State<GMTKELDENRIGNCARD> createState() => _MyShaderState();
}

class _MyShaderState extends State<GMTKELDENRIGNCARD>
    with SingleTickerProviderStateMixin {
  late Future<GmtkEldenRingCardsInspiredShader> helloWorld;

  late Ticker ticker;

  late double delta;
  late final AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    helloWorld = GmtkEldenRingCardsInspiredShader.compile();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      if (mounted) {
        setState(() {
          delta += 1 / 60;
        });
      }
    })
      ..start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ticker.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<GmtkEldenRingCardsInspiredShader>(
        future: helloWorld,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ShaderMask(
                child: const SizedBox(
                  width: 500,
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: ColoredBox(
                      color: Colors.white,
                    ),
                  ),
                ),
                shaderCallback: (rect) {
                  return snapshot.data!.shader(
                    resolution: rect.size,
                    image: image,

                    uResolution: Vector2(
                      rect.size.width,
                      rect.size.height,
                    ),

                    // tiles: 8,
                    // speed: delta / 30,
                    // direction: 0.75, // -1 to 1
                    // warpScale: 0.1,
                    // warpTiling: 0.8,
                    // color1: Vector3(0.086, 0.193, 1.000),
                    // color2: Vector3(0.044, 0.895, 1.000),
                  );
                },
              ),
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

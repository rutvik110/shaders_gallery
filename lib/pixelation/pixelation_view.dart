import 'package:flutter/material.dart';
import 'package:shaders_gallery/main.dart';
import 'package:shaders_gallery/pixelation/pixelation.dart';

class PixelatedImageView extends StatefulWidget {
  const PixelatedImageView({Key? key}) : super(key: key);

  @override
  State<PixelatedImageView> createState() => _MyShaderState();
}

class _MyShaderState extends State<PixelatedImageView>
    with SingleTickerProviderStateMixin {
  late Future<Pixelation> helloWorld;

  late final AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    helloWorld = Pixelation.compile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Pixelation>(
        future: helloWorld,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
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
                        pixelSize: 25 * animationController.value,
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
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

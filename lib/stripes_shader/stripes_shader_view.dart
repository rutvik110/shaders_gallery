import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shaders_gallery/stripes_shader/stripes.dart';
import 'package:shaders_gallery/util/colot_to_vector.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class StripesShaderView extends StatefulWidget {
  const StripesShaderView({Key? key}) : super(key: key);

  @override
  State<StripesShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<StripesShaderView> {
  late Future<Stripes> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = Stripes.compile();
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
      body: FutureBuilder<Stripes>(
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
                  uTime: delta,
                  tiles: 4.0,
                  speed: -delta / 25,
                  direction: (pi / 180) * 180, // -1 to 1
                  warpScale: 0.5,
                  warpTiling: -0.5,
                  color1: Vector3(0, 225 / 256, 250 / 256),
                  color2: Vector3(5 / 256, 37 / 256, 249 / 256),
                );
              },
            );

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ShaderMask(
                          child: Container(
                            height: 300,
                            color: Colors.white,
                          ),
                          shaderCallback: (rect) {
                            return snapshot.data!.shader(
                              resolution: rect.size,
                              uTime: delta,
                              tiles: 4.0,
                              speed: delta / 10,
                              direction: -.8, // -1 to 1
                              warpScale: 0.5,
                              warpTiling: 0.8,
                              color1: Colors.red.toColorVector(),
                              color2: Colors.blue.toColorVector(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ShaderMask(
                          child: Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          shaderCallback: (rect) {
                            return snapshot.data!.shader(
                              resolution: rect.size,
                              uTime: delta,
                              tiles: 6.0,
                              speed: delta / 10,
                              direction: .5, // -1 to 1
                              warpScale: 0.5,
                              warpTiling: 0.8,
                              color1: Colors.red.toColorVector(),
                              color2: Colors.blue.toColorVector(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ShaderMask(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          shaderCallback: (rect) {
                            return snapshot.data!.shader(
                              resolution: rect.size,
                              uTime: delta,
                              tiles: 5,
                              speed: delta / 10,
                              direction: (pi / 180), // -1 to 1
                              warpScale: 0.0,
                              warpTiling: 0, color1: Colors.red.toColorVector(),
                              color2: Colors.blue.toColorVector(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: ShaderMask(
                            child: const Text(
                              "Shaders",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 60,
                              ),
                            ),
                            shaderCallback: (rect) {
                              return snapshot.data!.shader(
                                resolution: rect.size,
                                uTime: delta,
                                tiles: 4.0,
                                speed: delta / 10,
                                direction: -.8, // -1 to 1
                                warpScale: 0.5,
                                warpTiling: 0.3,
                                color1: Colors.red.toColorVector(),
                                color2: Colors.blue.toColorVector(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomPaint(
                    painter: MyPainter(
                      snapshot.data!.shader(
                        resolution: MediaQuery.of(context).size,
                        uTime: delta,
                        tiles: 5.0,
                        speed: delta / 20,
                        direction: 0.7, // -1 to 1
                        warpScale: 0.5,
                        warpTiling: 0.5, color1: Colors.red.toColorVector(),
                        color2: Colors.blue.toColorVector(),
                      ),
                    ),
                    size: const Size(
                      250,
                      250,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
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

class MyPainter extends CustomPainter {
  MyPainter(this.shader) : _paint = Paint()..shader = shader;

  final Shader shader;

  final Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    // draw heart

    canvas.translate(size.width / 2, size.height / 2);

    const double heartRadius = 10;

    final angle = calculateAngleBasedOnPoints(360);

    final path = Path();

    for (var i = 0; i < 360; i++) {
      //calculate the angle of point
      double pointAngleValue = angle * i;

      //calculate the x and y coordinates of the point
      final offset =
          calculatePointOffset(angle: pointAngleValue, radius: heartRadius);
      path.lineTo(offset.dx, offset.dy);
    }

    canvas.drawPath(
      path,
      _paint,
    );
  }

  double calculateAngleBasedOnPoints(int points) {
    return pi * 2 / points;
  }

  Offset calculatePointOffset({required double angle, required double radius}) {
    return Offset(
      16 * pow(sin(angle), 3) * radius,
      -radius *
          (13 * cos(angle) -
              5 * cos(angle * 2) -
              2 * cos(angle * 3) -
              cos(angle * 4)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

import 'animating_gradient.dart';

class AnimatingGradientShaderBuilder extends StatefulWidget {
  const AnimatingGradientShaderBuilder({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  State<AnimatingGradientShaderBuilder> createState() => _MyShaderState();
}

class _MyShaderState extends State<AnimatingGradientShaderBuilder> {
  late Future<AnimatingGradient> helloWorld;

  late Ticker ticker;

  late double delta;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helloWorld = AnimatingGradient.compile();
    delta = 0;
    ticker = Ticker((Duration elapsedTime) {
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
    return FutureBuilder<AnimatingGradient>(
      future: helloWorld,
      builder:
          (BuildContext context, AsyncSnapshot<AnimatingGradient> snapshot) {
        if (snapshot.hasData) {
          return ShaderMask(
            child: widget.child,
            shaderCallback: (Rect rect) {
              return snapshot.data!.shader(
                resolution: rect.size,
                uTime: delta,
                uResolution: Vector2(rect.size.width, rect.size.height),
              );
            },
          );
        } else if (snapshot.hasError) {
          return widget.child!;
        }

        return widget.child!;
      },
    );
  }
}

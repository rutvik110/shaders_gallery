import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shaders_gallery/music_shader/music_shader.dart';
import 'package:shaders_gallery/util/load_audio_data.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class MusicShaderView extends StatefulWidget {
  const MusicShaderView({Key? key}) : super(key: key);

  @override
  State<MusicShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<MusicShaderView>
    with SingleTickerProviderStateMixin {
  late Future<MusicShader> helloWorld;

  late Ticker ticker;

  late double delta;
  late final AnimationController animationController;
  late double volume = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Change this value to number of audio samples you want.
    // Values between 256 and 1024 are good for showing [RectangleWaveform] and [SquigglyWaveform]
    // While the values above them are good for showing [PolygonWaveform]
    totalSamples = 1000;
    audioData = audioDataList[0];
    audioPlayer = AudioCache(
      fixedPlayer: AudioPlayer(),
    );

    samples = [];
    maxDuration = const Duration(milliseconds: 1000);
    elapsedDuration = const Duration();
    parseData();
    audioPlayer.fixedPlayer!.onPlayerCompletion.listen((_) {
      setState(() {
        elapsedDuration = maxDuration;
      });
    });
    audioPlayer.fixedPlayer!.onAudioPositionChanged
        .listen((Duration timeElapsed) {
      setState(() {
        elapsedDuration = timeElapsed;
        // find index of the current sample point
        final elapsedTimeRatio =
            elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

        final activeIndex = (samples.length * elapsedTimeRatio).round();
        volume = samples[activeIndex];
      });
    });
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    helloWorld = MusicShader.compile();
    delta = 0;
    ticker = Ticker((elapsedTime) {
      setState(() {
        delta += 1 / 60;
      });
    })
      ..start();
  }

  late Duration maxDuration;
  late Duration elapsedDuration;
  late AudioCache audioPlayer;
  late List<double> samples;
  late int totalSamples;

  late List<String> audioData;

  List<List<String>> audioDataList = [
    [
      'assets/images/sp.json',
      'images/surface_pressure.mp3',
    ],
  ];

  Future<void> parseData() async {
    final json = await rootBundle.loadString(audioData[0]);
    Map<String, dynamic> audioDataMap = {
      "json": json,
      "totalSamples": totalSamples,
    };
    final samplesData = await compute(loadparseJson, audioDataMap);
    await audioPlayer.load(audioData[1]);
    await audioPlayer.play(audioData[1]);
    // maxDuration in milliseconds
    await Future.delayed(const Duration(milliseconds: 200));

    int maxDurationInmilliseconds =
        await audioPlayer.fixedPlayer!.getDuration();

    maxDuration = Duration(milliseconds: maxDurationInmilliseconds);
    setState(() {
      samples = samplesData["samples"];
    });
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
      body: Stack(
        children: [
          FutureBuilder<MusicShader>(
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
                    log(volume.toString());
                    return snapshot.data!.shader(
                      resolution: rect.size,

                      uResolution: Vector2(
                        rect.size.width,
                        rect.size.height,
                      ),
                      uTime: animationController.value,
                      uVol: volume.toDouble() * 5,
                      uMouse: Vector2(0, 0),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.play(audioData[1]);
                    },
                    child: const Text("Play"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.fixedPlayer!.pause();
                    },
                    child: const Text("Pause"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.fixedPlayer!.stop();
                    },
                    child: const Text("Stop"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

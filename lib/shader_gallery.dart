import 'package:flutter/material.dart';
import 'package:shaders_gallery/character_outline/character_outline_view.dart';
import 'package:shaders_gallery/floyd_steinberg_dithering/floyd_steinberg_dithering_view.dart';
import 'package:shaders_gallery/gmtk_elden_ring_card_shader/image_transition_view.dart';
import 'package:shaders_gallery/image_transition_view/image_transition_view.dart';
import 'package:shaders_gallery/music_shader/music_shader_view.dart';
import 'package:shaders_gallery/noise_shader/noise_shader_view.dart';
import 'package:shaders_gallery/pixelation/pixelation_view.dart';
import 'package:shaders_gallery/sci_fi_noise/sci_fi_noise.dart';
import 'package:shaders_gallery/stripes_shader/stripes_shader_view.dart';

class ShadersGallery extends StatefulWidget {
  const ShadersGallery({Key? key}) : super(key: key);

  @override
  State<ShadersGallery> createState() => _ShadersGalleryState();
}

class _ShadersGalleryState extends State<ShadersGallery> {
  final pageController = PageController();
  final pageItems = [
    const FloydSteinbergDitheringView(),
    const GMTKELDENRIGNCARD(),
    const NoiseShaderView(),
    const PixelatedImageView(),
    const CharacterOutlineView(),
    const ImageTransitionView(),
    const SciFiNoise(),
    const MusicShaderView(),
    const StripesShaderView(),
  ];
  final shaderNames = [
    'Floyd-Steinberg-Dithering-View',
    'GMTK ELDEN RIGN CARD',
    'Noise Shader',
    'Pixelation Shader',
    'Character Outline Shader',
    'Image Transition Shader',
    'Sci-Fi Noise Shader',
    'Music Shader',
    'Stripes Shader',
  ];
  @override
  Widget build(BuildContext context) {
    // use pageviews to display all shaders

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Shaders Gallery'),
        ),
        body: Row(
          children: [
            SizedBox(
              width: 200,
              child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Text(
                            shaderNames[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  return pageItems[index];
                },
              ),
            )
          ],
        ));
  }
}

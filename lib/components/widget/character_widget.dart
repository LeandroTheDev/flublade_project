import 'package:flutter/material.dart';

class CharacterWidget extends StatelessWidget {
  //Character Declaration
  final String body;
  final String skin;
  final Color skinColor;
  final String hair;
  final Color hairColor;
  final String eyes;
  final Color eyesColor;
  final String mouth;
  final Color mouthColor;
  //Customization
  final double scale;
  const CharacterWidget({
    super.key,
    required this.body,
    required this.skin,
    required this.skinColor,
    required this.hair,
    required this.hairColor,
    required this.eyes,
    required this.eyesColor,
    required this.mouth,
    required this.mouthColor,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Body
        SizedBox(
          height: 124 * scale,
          width: 76 * scale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(skinColor.withOpacity(0.7), BlendMode.srcATop),
            child: Image.asset(
              body,
              fit: BoxFit.fill,
            ),
          ),
        ),
        //Skin
        SizedBox(
          height: 124 * scale,
          width: 76 * scale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(skinColor.withOpacity(0.7), BlendMode.srcATop),
            child: Image.asset(
              skin,
              fit: BoxFit.fill,
            ),
          ),
        ),
        //Eyes
        SizedBox(
          height: 124 * scale,
          width: 76 * scale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(eyesColor.withOpacity(0.7), BlendMode.srcATop),
            child: Image.asset(
              eyes,
              fit: BoxFit.fill,
            ),
          ),
        ),
        //Mouth
        SizedBox(
          height: 124 * scale,
          width: 76 * scale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(mouthColor.withOpacity(0.7), BlendMode.srcATop),
            child: Image.asset(
              mouth,
              fit: BoxFit.fill,
            ),
          ),
        ),
        //Hair
        SizedBox(
          height: 124 * scale,
          width: 76 * scale,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(hairColor.withOpacity(0.7), BlendMode.srcATop),
            child: Image.asset(
              hair,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

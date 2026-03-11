import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class NoDriversDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.white),
                AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      "Sorry",
                      duration: Duration(milliseconds: 1000),
                      textStyle: TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    FadeAnimatedText(
                      "We found",
                      duration: Duration(milliseconds: 1000),
                      textStyle: TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    FadeAnimatedText(
                      "no drivers available",
                      duration: Duration(milliseconds: 1000),
                      textStyle: TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ],
                  repeatForever: true,
                  isRepeatingAnimation: true,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: 150,
                        child: Text(
                          "Close",
                          style: TextStyle(
                              fontSize: 32.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

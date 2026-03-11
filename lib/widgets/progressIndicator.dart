import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: if
// ignore: must_be_immutable
class ProgressIndi extends StatelessWidget {
  String message;
  ProgressIndi({this.message});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade500,
      child: Container(
        height: 110,
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SpinKitThreeBounce(color: Colors.black),
              Text(
                message,
                style: GoogleFonts.oswald(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

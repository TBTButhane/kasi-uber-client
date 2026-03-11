import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(color: Colors.yellow),
        
      ),
    );
  }
}

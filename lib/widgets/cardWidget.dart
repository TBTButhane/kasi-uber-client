import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jabber/Screens/payment.dart';

class CardWidget extends StatelessWidget {
  String cHolder, cNumber, cExp;
  CardWidget({this.cHolder, this.cNumber, this.cExp});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 3,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                  height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.ac_unit,
                          color: Colors.grey[100],
                          size: 50,
                        ),
                        title: Text("HostTree",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                        subtitle: Text("Bank",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 14))),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(cNumber,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 18))),
                          SizedBox(
                            width: 25,
                          ),
                          Container(
                            width: 80,
                            child: Stack(
                              fit: StackFit.loose,
                              children: [
                                Positioned(
                                    child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Text(" "),
                                )),
                                Positioned(
                                    left: 18,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.yellow,
                                      child: Text(" "),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cExp,
                            style: GoogleFonts.oswald(
                                textStyle: TextStyle(color: Colors.white)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cHolder,
                            style: GoogleFonts.oswald(
                                textStyle: TextStyle(color: Colors.white)),
                          ))
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

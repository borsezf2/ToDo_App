import 'package:flutter/material.dart';

Widget BackCurve()
{
  return ClipPath(
    child: Container(
      child: Align(
        alignment: Alignment(-0.46, -0.1),
        child: Text("TO-DOs",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
      ),
      height: 200,
      decoration: BoxDecoration(

        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red])
      ),
    ),
    clipper: CurveDetails(),
  );
}

class CurveDetails extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {

    var path = new Path();

    path.lineTo(0.0, 100);

    path.quadraticBezierTo(100, 170, size.width, 80);
//    path.quadraticBezierTo(100, 100, 200, 100);
    path.lineTo(size.width, 100);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper)=>false ;


}
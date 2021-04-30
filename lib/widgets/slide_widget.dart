import 'package:MobileMoney4/constants.dart';
import 'package:flutter/material.dart';

import 'package:MobileMoney4/models/slide.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(slideList[index].imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            slideList[index].title,
            style: GoogleFonts.nunito(
              fontSize: 22,
              color: primaryYellow,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            slideList[index].description,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

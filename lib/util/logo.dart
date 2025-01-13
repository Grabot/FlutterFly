import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget logo(double maxWidth) {
  double logoWidthBrocast = 800;
  double logoWidth = 300;
  double logoHeight = 75;
  double sizeOfFont = 15;
  if (maxWidth < 800) {
    logoWidth = (maxWidth/10)*4;
    logoHeight = maxWidth/12;
    sizeOfFont = 5;
    logoWidthBrocast = maxWidth;
  }
  return Column(
      children: [
        SizedBox(
          height: 250,
          width: logoWidthBrocast,
          child: const Image(
            image: AssetImage("assets/images/flutterfly_banner_rework_4.png"),
          ),
        ),
        const Text(
            "Flutter Fly",
            style: TextStyle(color: Color(0xff949494), fontSize: 35)
        ),
        const SizedBox(height: 30),
        const Text(
            "From",
            style: TextStyle(color: Color(0xff949494), fontSize: 10, fontWeight: FontWeight.bold)
        ),
        InkWell(
          onTap: () {
            final Uri url = Uri.parse('https://zwaar.dev');
            _launchUrl(url);
          },
          child: Column(
            children: [
              SizedBox(
                height: logoHeight,
                width: logoWidth-50,
                child: const Image(
                  image: AssetImage("assets/images/Zwaar.png"),
                ),
              ),
              Text(
                  "  Developers",
                  style: TextStyle(color: const Color(0xff949494), fontSize: sizeOfFont, fontWeight: FontWeight.bold)
              )
            ],
          ),
        )
      ]
  );
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

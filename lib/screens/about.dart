import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About"),
      ),
      backgroundColor: Color.fromARGB(255, 204, 255, 255),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/pramo.jpg"),
                radius: 100,
              ),
              Text(
                "My name is Prashant Mohania and I make this app MockPedia. This is the initial version of the app and hope I add some more features in future.",
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ),
              Text(
                "If you like this app please send me your feedback on my socials.",
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[500], // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await launch("https://www.instagram.com/_iampramo_/");
                    },
                    icon: Icon(FontAwesomeIcons.instagram),
                    label: Text("Instagram"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      await launch("https://twitter.com/PrashantMohania");
                    },
                    icon: Icon(FontAwesomeIcons.twitter),
                    label: Text("Twitter"),
                  ),
                ],
              ),
              Text(
                "Thank You......",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient),
                textScaleFactor: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

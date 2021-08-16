import 'package:flutter/material.dart';
// import 'package:seenzone/widget/background_painter.dart';
import 'package:seenzone/widget/google_signup_button_widget.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          // CustomPaint(painter: BackgroundPainter()),
          backgroundColorFiller(context),
          buildSignUp(context),
        ],
      );

  Widget backgroundColorFiller(BuildContext context) => Column(
        children: [
          //draw a gradient paint acroos the background
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                  0.1,
                  0.3,
                  0.7,
                  1
                ],
                    colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.pink
                ])),
                // limit height and width based on device
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            
          )
        ],
      );
      //widget that is returned to show login in process 
  Widget buildSignUp(BuildContext context) => Column(
        children: [
          Spacer(),
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              color: Colors.blue[300],
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              child: Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Spacer(),
          // login button designed seperately as a widget
          GoogleSignupButtonWidget(),
          SizedBox(height: 12),
          Text(
            'LOGIN TO PROCEED',
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
        ],
      );
}

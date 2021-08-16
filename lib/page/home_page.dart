import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seenzone/provider/google_sign_in.dart';
import 'package:seenzone/widget/background_painter.dart';
import 'package:seenzone/page/logged_in_home.dart';
import 'package:seenzone/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    //CHANGE THE CONTEXT TO LOGIN PAGE / LOGGED IN PAGE BASED ON NOTIFICATION FROM FIREBASE
        body: ChangeNotifierProvider(
          //Get logged in status from google and show context accordingly.
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                // if user is logged in show the logged_in home page.
                return LoggedInWidget();
              } else {
                // if user not signed in re-direct to signup page.
                return SignUpWidget();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}

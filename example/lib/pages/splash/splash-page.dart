import 'package:flutter/material.dart';
import 'package:floater/floater.dart';
import 'splash-page-state.dart';

class SplashPage extends StatefulWidgetBase<SplashPageState> {
  SplashPage() : super(() => SplashPageState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Image.network(
                  "https://image.similarpng.com/very-thumbnail/2020/04/WhatsApp-logo-modern-paint-splash-social-media-png.png",
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "WhatsApp",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

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
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  "https://i.pinimg.com/originals/f3/53/5d/f3535dc3f95e71506f7c80755610176c.png",
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "from",
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.facebook,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "Meta",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

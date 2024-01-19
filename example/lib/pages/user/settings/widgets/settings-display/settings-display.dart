import 'package:example/pages/user/settings/widgets/settings-display/settings-display-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsDisplay extends StatefulWidgetBase<SettingsDisplayState> {
  SettingsDisplay() : super(() => SettingsDisplayState());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Display",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Theme",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: this.state.themeNotifier,
              builder: (context, isDarkMode, _) {
                return Switch(
                  value: this.state.isDarkMode,
                  activeColor: this.state.isDarkMode ? Colors.white : Colors.black12,
                  onChanged: (bool value) => this.state.toggleTheme(value),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            this.state.isDarkMode ? "Dark" : "Light",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:example/pages/settings/settings-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidgetBase<SettingsPageState> {
  SettingsPage() : super(() => SettingsPageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _settingsAppBar(
        goBack: this.state.goBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _displayInfo(),
              _themeInfo(
                themeNotifier: this.state.themeNotifier,
                isDarkMode: this.state.isDarkMode,
                toggleTheme: this.state.toggleTheme,
              ),
              _aboutInfo(
                userName: this.state.userName,
              ),
              _statusInfo(),
              _privacyPolicy(),
              _logout(
                logout: this.state.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _displayInfo extends StatelessWidget {
  const _displayInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Text(
              "Display",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class _themeInfo extends StatelessWidget {
  final ValueListenable<bool> themeNotifier;
  final bool isDarkMode;
  final void Function(bool) toggleTheme;
  const _themeInfo({
    required this.themeNotifier,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Theme",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: this.themeNotifier,
              builder: (context, isDarkMode, _) {
                return Switch(
                  value: this.isDarkMode,
                  activeColor: this.isDarkMode ? Colors.white : Colors.black12,
                  onChanged: (bool value) => this.toggleTheme(value),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Text(
                this.isDarkMode ? "Dark" : "Light",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _aboutInfo extends StatelessWidget {
  final String userName;
  const _aboutInfo({
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Text("About", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          children: [
            Expanded(child: Text("User", style: TextStyle(fontSize: 20))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(this.userName, style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class _statusInfo extends StatelessWidget {
  const _statusInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Status",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Online",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _privacyPolicy extends StatelessWidget {
  const _privacyPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Text("Privacy Policy", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Our Privacy Policy has been crafted to provide clarity on how we gather, utilize, and protect your data when you engage with our messaging services. Your trust is of utmost importance to us, and we are committed to ensuring that your information is handled with the utmost care and in accordance with the highest standards of privacy and security.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _logout extends StatelessWidget {
  final VoidCallback logout;
  const _logout({
    required this.logout,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            TextButton(
              onPressed: this.logout,
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _settingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _settingsAppBar({
    required this.goBack,
  }) : super();

  final VoidCallback goBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Settings",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => this.goBack(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

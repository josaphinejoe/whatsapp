import 'package:example/pages/user/settings/settings-page-state.dart';
import 'package:example/pages/user/settings/widgets/display/display.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidgetBase<SettingsPageState> {
  SettingsPage() : super(() => SettingsPageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SettingsAppBar(
        goBack: this.state.goBack,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Display(),
              _AboutInfo(
                userName: this.state.userName,
              ),
              const _StatusInfo(),
              const _PrivacyPolicy(),
              _Logout(
                logout: this.state.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutInfo extends StatelessWidget {
  final String userName;

  const _AboutInfo({
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        const Text(
          "About",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "User",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                this.userName,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

class _StatusInfo extends StatelessWidget {
  const _StatusInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Status",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Online",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Our Privacy Policy has been crafted to provide clarity on how we gather, utilize, and protect your data when you engage with our messaging services. Your trust is of utmost importance to us, and we are committed to ensuring that your information is handled with the utmost care and in accordance with the highest standards of privacy and security.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _Logout extends StatelessWidget {
  final VoidCallback logout;

  const _Logout({
    required this.logout,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        TextButton(
          onPressed: this.logout,
          child: const Text(
            "Log out",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SettingsAppBar({
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

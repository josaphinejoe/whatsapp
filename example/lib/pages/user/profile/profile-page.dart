import 'package:example/pages/user/profile/profile-page-state.dart';
import 'package:example/widgets/input-text-field/input-text-field.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidgetBase<ProfilePageState> {
  ProfilePage() : super(() => ProfilePageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ProfileAppBar(
        goBack: this.state.goBack,
        goToSettings: this.state.goToSettings,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _ProfilePicture(
              getImage: this.state.getImage,
              editProfilePicture: this.state.editProfilePicture,
            ),
            const SizedBox(
              height: 20.0,
            ),
            InputTextfield(
              initialValue: this.state.firstName,
              label: "FirstName",
              onChange: (v) => this.state.firstName = v,
              onSave: this.state.saveFirstName,
            ),
            InputTextfield(
              initialValue: this.state.lastName ?? "",
              label: "LastName",
              onChange: (v) => this.state.lastName = v,
              onSave: this.state.saveLastName,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 30.0,
              ),
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: Text(
                  this.state.phone,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  final ImageProvider<Object>? Function() getImage;
  final VoidCallback editProfilePicture;

  const _ProfilePicture({
    required this.getImage,
    required this.editProfilePicture,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      alignment: Alignment.topCenter,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CircleAvatar(
            radius: 100,
            foregroundImage: this.getImage(),
            backgroundImage: const NetworkImage(
              "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPp7AelDxUJQ_t928VVlyIqM4sAMLIOsHyWkVgVRPzvFaUuJkNZG6U7DV8oYjIwpwzVKWwEGOFqQ_8jBTwiz8iDrR0GlQUVom65RMzoaLrYvNhVbwcFdgo2glP2lgp076Dvl6oNjrOuQp5oQstI1SCbVXITSPofI12AdM-KaB0rQBPAyRR5qpE-z8hDg/s16000-rw/blank-profile-picture-hd-images-photo-5.JPG",
            ),
            backgroundColor: const Color(0xFF387463),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.camera_alt_rounded),
              onPressed: () => this.editProfilePicture(),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback goBack;
  final VoidCallback goToSettings;

  const _ProfileAppBar({
    required this.goBack,
    required this.goToSettings,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Profile",
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
      actions: [
        IconButton(
          onPressed: this.goToSettings,
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

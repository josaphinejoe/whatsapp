import 'package:example/pages/home/home-page-state.dart';
import 'package:example/pages/routes.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class HomePage extends StatefulWidgetBase<HomePageState> {
  HomePage() : super(() => HomePageState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _HomeAppBar(
        titles: this.state.appBarTitles,
        activeNavItem: this.state.activeNavItem,
        displayPicture: this.state.getImage(),
        onTapUser: this.state.onTapUser,
      ),
      body: this._buildBody(),
      bottomNavigationBar: _HomeBottomNavigationBar(
        currentIndex: this.state.activeNavItem,
        onActiveNavItemChanged: this.state.onActiveNavItemChanged,
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: this.state.activeNavItem,
      children: [
        ScopedNavigator(
          "/home",
          initialRoute: Routes.chatSummary,
          key: this.state.nav0Key,
        ),
        ScopedNavigator(
          "/home",
          key: this.state.nav1Key,
          initialRoute: Routes.contacts,
        ),
        ScopedNavigator(
          "/home",
          key: this.state.nav2Key,
          initialRoute: Routes.addContact,
        ),
      ],
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidgetBase {
  final int currentIndex;
  final void Function(int)? onActiveNavItemChanged;

  const _HomeBottomNavigationBar({
    required this.currentIndex,
    required this.onActiveNavItemChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this.currentIndex,
      selectedItemColor: const Color(0xFF387463),
      onTap: this.onActiveNavItemChanged,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Contacts"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Contact"),
      ],
    );
  }
}

class _HomeAppBar extends StatelessWidgetBase implements PreferredSizeWidget {
  final ImageProvider<Object>? displayPicture;
  final List<String> titles;
  final int activeNavItem;
  final VoidCallback onTapUser;

  const _HomeAppBar({
    required this.titles,
    required this.activeNavItem,
    required this.onTapUser,
    this.displayPicture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        this.titles[this.activeNavItem],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: this.onTapUser,
              borderRadius: BorderRadius.circular(50.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF387463),
                foregroundImage: this.displayPicture,
                backgroundImage: const NetworkImage(
                  "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPp7AelDxUJQ_t928VVlyIqM4sAMLIOsHyWkVgVRPzvFaUuJkNZG6U7DV8oYjIwpwzVKWwEGOFqQ_8jBTwiz8iDrR0GlQUVom65RMzoaLrYvNhVbwcFdgo2glP2lgp076Dvl6oNjrOuQp5oQstI1SCbVXITSPofI12AdM-KaB0rQBPAyRR5qpE-z8hDg/s16000-rw/blank-profile-picture-hd-images-photo-5.JPG",
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

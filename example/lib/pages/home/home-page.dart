import 'package:example/pages/home/home-page-state.dart';
import 'package:example/pages/routes.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:floater/floater.dart';

class HomePage extends StatefulWidgetBase<HomePageState> {
  HomePage() : super(() => HomePageState());
  @override
  Widget build(BuildContext context) {
    return this.state.isReady? Scaffold(
      appBar: AppBar(
        title: Text(this.state.appBarTitles[this.state.activeNavItem], style: const TextStyle(color: Colors.white, fontSize: 30),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: InkWell(
                onTap: this.state.onTapUser,
                borderRadius: BorderRadius.circular(50.0),
                child:  CircleAvatar(
                  backgroundColor: const Color(0xFF387463),
                  foregroundImage: this.state.getImage(),
                  backgroundImage: const NetworkImage("https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPp7AelDxUJQ_t928VVlyIqM4sAMLIOsHyWkVgVRPzvFaUuJkNZG6U7DV8oYjIwpwzVKWwEGOFqQ_8jBTwiz8iDrR0GlQUVom65RMzoaLrYvNhVbwcFdgo2glP2lgp076Dvl6oNjrOuQp5oQstI1SCbVXITSPofI12AdM-KaB0rQBPAyRR5qpE-z8hDg/s16000-rw/blank-profile-picture-hd-images-photo-5.JPG"),
                ),
              ),
            ),
          )
        ],
      ),
      body: this._buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.state.activeNavItem,
        selectedItemColor:const Color(0xFF387463),
        onTap: this.state.onActiveNavItemChanged,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(Icons.home),
            label: "Home"),
            BottomNavigationBarItem(
            icon:Icon(Icons.person),
            label: "Contacts"),
            BottomNavigationBarItem(
            icon:Icon(Icons.add),
            label: "Add Contact")
        ],
      ),
    ): this._buildLoadingScreen();
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


  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        child: SizedBox.expand(
          child: Container(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          ),
        ),
      ),
    );
  }
}
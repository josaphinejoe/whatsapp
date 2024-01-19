import 'package:example/pages/add-contact/add-contact-page.dart';
import 'package:example/pages/chat-summary/chat-summary-page.dart';
import 'package:example/pages/chats/chats-page.dart';
import 'package:example/pages/contacts/contacts-page.dart';
import 'package:example/pages/home/home-page.dart';
import 'package:example/pages/login/login-page.dart';
import 'package:example/pages/user/settings/settings-page.dart';
import 'package:example/pages/sign-up/sign-up-page.dart';
import 'package:example/pages/user/profile/profile-page.dart';
import 'package:example/pages/user/user-page.dart';

import 'package:floater/floater.dart';
import 'package:example/pages/splash/splash-page.dart';

abstract class Routes {
  static const splash = "/splash";
  static const home = "/home";
  static const chatSummary = "$home/chatSummary";
  static const contacts = "$home/contacts";
  static const addContact = "$home/addContact";
  static const chats = "/chats?{phone: string}";
  static const user = "/user";
  static const profile = "$user/profile";
  static const settings = "$user/settings";
  static const signUp = "/signUp";
  static const login = "/login";

  static void initializeNavigation() {
    NavigationManager.instance
      ..registerPage(Routes.splash, (routeArgs) => SplashPage())
      ..registerPage(Routes.home, (routeArgs) => HomePage())
      ..registerPage(Routes.chatSummary, (routeArgs) => ChatSummaryPage())
      ..registerPage(Routes.contacts, (routeArgs) => ContactsPage())
      ..registerPage(Routes.addContact, (routeArgs) => AddContactPage())
      ..registerPage(Routes.chats, (routeArgs) => ChatsPage(routeArgs["phone"]))
      ..registerPage(Routes.user, (routeArgs) => UserPage())
      ..registerPage(Routes.profile, (routeArgs) => ProfilePage())
      ..registerPage(Routes.settings, (routeArgs) => SettingsPage())
      ..registerPage(Routes.signUp, (routeArgs) => SignUpPage())
      ..registerPage(Routes.login, (routeArgs) => LoginPage());

    NavigationManager.instance.bootstrap();
  }
}

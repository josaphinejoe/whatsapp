import 'package:example/events/contact-added-event.dart';
import 'package:example/pages/contacts/contacts-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';

class ContactsPageState extends WidgetStateBase<ContactsPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();

  late List<Contact> _contacts = [];

  List<Contact> get contacts => this._contacts;

  ContactsPageState() : super() {
    this.onInitState(() {
      this._loadContacts();
    });

    this.watch<ContactAddedEvent>(this._eventAggregator.subscribe<ContactAddedEvent>(), (event) {
      this._loadContacts();
    });
  }

  Future<void> onTapChat(Contact contact) async {
    await this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.chats),
      arguments: {
        "phone": contact.phone,
      },
    );
  }

  void _loadContacts() {
    final user = this._userService.authenticatedUser;
    this._contacts = user.contactList;
    this._contacts.sort((a, b) => a.firstName.compareTo(b.firstName));
  }
}

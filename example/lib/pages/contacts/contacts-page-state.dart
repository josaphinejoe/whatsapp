import 'package:example/events/contact-added-event.dart';
import 'package:example/pages/contacts/contacts-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/models/contact.dart';
import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:floater/floater.dart';

class ContactsPageState extends WidgetStateBase<ContactsPage>
{
  final _contactService = ServiceLocator.instance.resolve<ContactService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();


  late List<Contact> _contacts =[];


  List<Contact> get contacts => this._contacts;


  ContactsPageState() :super(){
    this.onInitState(() async {
      await this._loadContacts();
    });

    this.watch<ContactAddedEvent>(this._eventAggregator.subscribe<ContactAddedEvent>(),(event) async{
      await this._loadContacts();
    });
  }


  Future<void> onTapChat(Contact contact) async {
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.chats),arguments:{
        "phone":contact.phone
      },
    );
  }


  Future<void> _loadContacts() async {
    this.showLoading();
      try 
      {
        final contacts = await this._contactService.getContactList();
         contacts.sort((a, b) => a.firstName.compareTo(b.firstName)); 
         this._contacts=contacts; 
      } catch (e) 
      {
        return;
      } 
      finally 
      {
        this.hideLoading();
      }
    }
}
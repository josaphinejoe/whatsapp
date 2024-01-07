import 'package:example/pages/contacts/contacts-page-state.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidgetBase<ContactsPageState> {
  ContactsPage() : super(() => ContactsPageState());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: ListView.builder(
          itemCount: this.state.contacts.length,
          itemBuilder: (ctx, index) {
            final contact = this.state.contacts[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: _contactTile(
                  contact: contact,
                  onTapChat: this.state.onTapChat,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _contactTile extends StatelessWidget {
  const _contactTile({
    required this.contact,
    required this.onTapChat,
    Key? key,
  }) : super(key: key);

  final Contact contact;
  final void Function(Contact) onTapChat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => this.onTapChat(contact),
      title: Text(
        "${contact.firstName} ${contact.lastName ?? ""}",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(
          contact.profilePicture ??
              "https://cdn4.iconfinder.com/data/icons/business-and-office-29/512/396-_profile__avatar__image__dp_-512.png",
        ),
        radius: 30,
      ),
    );
  }
}

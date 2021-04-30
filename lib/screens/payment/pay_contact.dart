import 'package:MobileMoney4/constants.dart';
import 'package:MobileMoney4/screens/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

//TODO - Permissions

class PaymentContact extends StatefulWidget {
  @override
  _PaymentContactState createState() => _PaymentContactState();
}

class _PaymentContactState extends State<PaymentContact> {
  List<Contact> _contacts = [];
  List<Contact> _contactsfiltered = [];
  String phoneNumber = '';
  var txt = TextEditingController();
  bool recipientValid = false;

  @override
  void initState() {
    _getPermission().then((value) {
      value.isGranted ? getContacts() : null;
    });
    super.initState();
    txt.addListener(() {
      filterContacts();
    });
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    print(permission.toString());
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    if (this.mounted) {
      setState(() {
        for (Contact x in contacts.toList()) {
          if (x.phones.isNotEmpty) {
            _contacts.add(x);
          }
        }
      });
    }
  }

  filterContacts() {
    List<Contact> contacts = [];
    contacts.addAll(_contacts);
    if (txt.text.isNotEmpty) {
      contacts.retainWhere((contact) {
        String searchTerm = txt.text.toLowerCase();
        String searchTermFlatten = returnNumbers(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = returnNumbers(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });

      setState(() {
        _contactsfiltered = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = txt.text.isNotEmpty;
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: recipientValid
                  ? () {
                      Navigator.of(context).push(
                          createRoute(PaymentScreen(phoneNumber: txt.text)));
                    }
                  : null,
            )
          ],
          centerTitle: true,
          title: (Text(
            'Pay',
            style: GoogleFonts.nunito(),
          )),
        ),
        body: Column(children: <Widget>[
          TextFormField(
            controller: txt,
            onChanged: (value) {
              setState(() {
                if (value.length == 10 && double.tryParse(value) != null) {
                  phoneNumber = value;
                  recipientValid = true;
                } else {
                  phoneNumber = '';
                  recipientValid = false;
                }
              });
            },
            decoration: InputDecoration(
                hintStyle: GoogleFonts.nunito(fontSize: 13),
                hintText:
                    'Type phone number (with country code) or search contact',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 20)),
          ),
          _contacts.isNotEmpty
              //Build a list view of all contacts, displaying their avatar and
              // display name
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearching == true
                        ? _contactsfiltered.length
                        : _contacts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Contact contact = isSearching
                          ? _contactsfiltered[index]
                          : _contacts?.elementAt(index);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 18),
                        leading: (contact.avatar != null &&
                                contact.avatar.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                        title: Text(contact.displayName ?? ''),
                        subtitle: contact.phones.isNotEmpty
                            ? Text(contact.phones.first.value.toString())
                            : null,
                        onTap: () {
                          setState(() {
                            String pn = contact.phones.first.value.toString();
                            String onlyNumbers = returnNumbers(pn);
                            if (onlyNumbers.length > 10) {
                              onlyNumbers = onlyNumbers
                                  .substring(onlyNumbers.length - 10);
                            }
                            Navigator.of(context)
                                .push(createRoute(PaymentScreen(
                              contact: contact,
                            )));
                          });
                        },
                        //This can be further expanded to showing contacts detail
                        // onPressed().
                      );
                    },
                  ),
                )
              : Expanded(
                  child: Container(child: const CircularProgressIndicator()),
                ),
        ]));
  }
}

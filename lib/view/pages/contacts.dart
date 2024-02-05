import 'package:contact_with_object_box/controller/contact_provider.dart';
import 'package:contact_with_object_box/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactPage extends ConsumerWidget {
  ContactPage({super.key});
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ContactEntity> contactList =
        ref.watch(contactProvider) as List<ContactEntity>;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Contacts'),
        ),
      ),
      body: contactList.isEmpty
          ? Center(
              child: Text('No Contacts'),
            )
          : Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(contactList[index].name),
                    subtitle: Text(contactList[index].phone),
                    leading: CircleAvatar(
                      child: Text(contactList[index].name[0]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  name.text = contactList[index].name;
                                  phone.text = contactList[index].phone;
                                  return ModelBottomSheet(
                                      formKey: formKey,
                                      name: name,
                                      phone: phone,
                                      ref: ref,
                                      onPressed: () {
                                        final ContactEntity contact =
                                            ContactEntity(
                                                id: contactList[index].id,
                                                name: name.text,
                                                phone: phone.text);
                                        ref
                                            .watch(contactProvider.notifier)
                                            .putContact(contact);
                                        Navigator.pop(context);
                                        name.clear();
                                        phone.clear();
                                      });
                                });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                            onPressed: () {
                              ref
                                  .watch(contactProvider.notifier)
                                  .removeContact(contactList[index].id);
                            },
                            icon: const Icon(Icons.delete_forever_sharp))
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModelBottomSheet(
                  onPressed: () {
                    final ContactEntity contact =
                        ContactEntity(name: name.text, phone: phone.text);
                    ref.watch(contactProvider.notifier).putContact(contact);
                    name.clear();
                    phone.clear();
                    Navigator.pop(context);
                  },
                  ref: ref,
                  formKey: formKey,
                  name: name,
                  phone: phone,
                );
              },
            );
          },
          label: Text('Add contact')),
    );
  }
}

class ModelBottomSheet extends StatelessWidget {
  const ModelBottomSheet({
    super.key,
    required this.formKey,
    required this.name,
    required this.phone,
    required this.ref,
    required this.onPressed,
  });
  final WidgetRef ref;
  final TextEditingController name;
  final TextEditingController phone;
  final GlobalKey<FormState> formKey;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              controller: name,
            ),
            TextFormField(
              controller: phone,
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    name.clear();
                    phone.clear();
                  },
                  child: Text('cancel'),
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text('add'),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            )
          ],
        ));
  }
}
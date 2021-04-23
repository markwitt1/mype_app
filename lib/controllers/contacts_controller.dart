import 'package:contacts_service/contacts_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

final contactsControllerProvider =
    // ignore: top_level_function_literal_block
    StateNotifierProvider((ProviderReference ref) {
  return ContactsController(ref.read)..getUsersFromContacts();
});

class ContactsController extends StateNotifier<AsyncValue<Map<Contact, User>>> {
  final Reader _read;
  ContactsController(this._read) : super(AsyncValue.loading());

  getUsersFromContacts() async {
    state = AsyncValue.loading();
    Map<Contact, User> value = {};
    PermissionStatus permission = await Permission.contacts.status;
    if (permission.isGranted || await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      if (contacts != Null) {
        for (final contact in contacts) {
          if (contact.phones != null) {
            for (final phone in contact.phones!) {
              if (phone.value != null) {
                final user = await _read(userRepositoryProvider)
                    .getUserByPhoneNumber(phone.value!);
                if (user != null &&
                    !value.containsKey(contact) &&
                    !value.containsValue(user)) {
                  value[contact] = user;
                }
              }
            }
          }
        }
      }
    }
    state = AsyncValue.data(value);
  }
}

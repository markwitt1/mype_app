import 'package:contacts_service/contacts_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mype_app/controllers/user_controller.dart';
import 'package:mype_app/models/user_model/user_model.dart';
import 'package:mype_app/repositories/user_repository.dart';
import 'package:mype_app/utils/formatPhoneNumber.dart';
import 'package:permission_handler/permission_handler.dart';

final contactsControllerProvider =
    // ignore: top_level_function_literal_block
    StateNotifierProvider((ProviderReference ref) {
  final _user = ref.watch(userControllerProvider.state);
  return ContactsController(ref.read, _user)..getUsersFromContacts();
});

class ContactsController extends StateNotifier<AsyncValue<Map<Contact, User>>> {
  final Reader _read;
  final User? _user;
  ContactsController(this._read, this._user) : super(AsyncValue.loading());

  Future<void> getUsersFromContacts() async {
    state = AsyncValue.loading();
    Map<Contact, User> value = {};
    PermissionStatus permission = await Permission.contacts.status;
    if (permission.isGranted || await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts(withThumbnails: false);
      for (final contact in contacts) {
        if (contact.phones != null) {
          for (final phone in contact.phones!) {
            if (phone.value != null) {
              final user = await _read(userRepositoryProvider)
                  .getUserByPhoneNumber(formatPhoneNumber(phone.value!));
              if (user != null &&
                  _user != null &&
                  _user!.phoneNumber != phone.value &&
                  _user!.id != user.id &&
                  !_user!.friendIds.contains(user.id!) &&
                  !value.containsKey(contact) &&
                  !value.containsValue(user)) {
                value[contact] = user;
                state = AsyncValue.data(value);
              }
            }
          }
        }
      }
    }
  }
}

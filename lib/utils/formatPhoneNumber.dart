String formatPhoneNumber(String phoneNumber) =>
    phoneNumber.replaceAll(RegExp(r'-| '), '');

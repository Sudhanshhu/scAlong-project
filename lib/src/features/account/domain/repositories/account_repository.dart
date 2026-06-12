import '../../data/models/account_models.dart';

abstract class AccountRepository {
  /// Loads the full account/profile in a single aggregate call.
  Future<AccountDetails> getAccountDetails();

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

import '../../data/models/account_models.dart';

abstract class AccountRepository {
  Future<PersonalInfoResponse> getPersonalInfo();

  Future<KycStatusResponse> getKycStatus();

  Future<List<DocumentResponse>> getDocuments();

  Future<WalletResponse> getWalletInfo();

  Future<FatcaResponse> getFatcaInfo();

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

import 'package:dio/dio.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_models.dart';
import 'package:midchains_customer_portal/src/core/network/dio_client.dart';
import 'package:midchains_customer_portal/src/core/storage/secure_storage_service.dart';

class AccountRepositoryImpl implements AccountRepository {
  final DioClient _client;
  final SecureStorageService _storage;

  AccountRepositoryImpl({
    required DioClient client,
    required SecureStorageService storage,
  })  : _client = client,
        _storage = storage;

  @override
  Future<AccountDetails> getAccountDetails() async {
    try {
      // One aggregate call returns personal, occupation, FATCA and document
      // sections. The gateway wraps the payload as { success, message, data }.
      final response =
          await _client.dio.get('/api/kyc/client-profiles/all');
      final body = response.data as Map<String, dynamic>;
      final data = (body['data'] ?? body) as Map<String, dynamic>;

      // The aggregate endpoint does not include the account email; pull it
      // from the session we stored at login.
      final email = await _storage.getUserName();

      // Linked bank account lives on a separate endpoint that returns 404
      // when no bank is linked — treat that as "no bank" rather than an error.
      final bank = await _fetchBank();

      return AccountDetails.fromAll(data, email: email, bank: bank);
    } catch (e) {
      throw Exception('Failed to load account details: $e');
    }
  }

  Future<BankResponse?> _fetchBank() async {
    try {
      final res =
          await _client.dio.get('/api/clientBasicinfo/client/details');
      final body = res.data;
      if (body is Map<String, dynamic>) {
        return BankResponse.fromJson(body);
      }
      return null;
    } on DioException catch (e) {
      // 404 = no bank linked; any other error → no bank rather than failing
      // the whole account screen.
      if (e.response?.statusCode == 404) return null;
      return null;
    }
  }

  @override
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    // In real app we post to update profiles
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // In real app we post to change password
    await Future.delayed(const Duration(milliseconds: 600));
  }
}

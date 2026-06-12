import 'package:dio/dio.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_models.dart';
import 'package:midchains_customer_portal/src/core/network/dio_client.dart';

class AccountRepositoryImpl implements AccountRepository {
  final DioClient _client;

  AccountRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<PersonalInfoResponse> getPersonalInfo() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/personal-info');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return PersonalInfoResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load personal info: $e');
    }
  }

  @override
  Future<KycStatusResponse> getKycStatus() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/status');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return KycStatusResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load KYC status: $e');
    }
  }

  @override
  Future<List<DocumentResponse>> getDocuments() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/documents');
      final List<dynamic> list = response.data['data'] ?? response.data['Data'] ?? response.data;
      return list.map((item) => DocumentResponse.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load documents: $e');
    }
  }

  @override
  Future<WalletResponse> getWalletInfo() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/wallet');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return WalletResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load wallet info: $e');
    }
  }

  @override
  Future<FatcaResponse> getFatcaInfo() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/fatca');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return FatcaResponse.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load FATCA info: $e');
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

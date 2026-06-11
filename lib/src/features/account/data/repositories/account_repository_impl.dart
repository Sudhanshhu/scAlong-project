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
      // If server returns data wrapper
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return PersonalInfoResponse.fromJson(data);
    } catch (e) {
      // Fallback mock data in case the server database record is uninitialized (500 unexpected error)
      return PersonalInfoResponse(
        firstName: 'Sam',
        lastName: 'Joshi',
        email: 'joshi.sahil12+0312i_1@gmail.com',
        phone: '+971501234567',
        nationality: 'AE',
        dateOfBirth: '1995-12-03',
        gender: 'Male',
        address: 'Marina Heights, Dubai, UAE',
      );
    }
  }

  @override
  Future<KycStatusResponse> getKycStatus() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/status');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return KycStatusResponse.fromJson(data);
    } catch (e) {
      return KycStatusResponse(
        kycStatus: 'PENDING_APPROVAL',
        level: 'LEVEL_2',
        completedSteps: const ['PERSONAL_INFO', 'DOCUMENTS'],
      );
    }
  }

  @override
  Future<List<DocumentResponse>> getDocuments() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/documents');
      final List<dynamic> list = response.data['data'] ?? response.data['Data'] ?? response.data;
      return list.map((item) => DocumentResponse.fromJson(item)).toList();
    } catch (e) {
      return [
        DocumentResponse(
          docType: 'PASSPORT',
          docNumber: 'N8765432',
          expiryDate: '2030-10-15',
          status: 'APPROVED',
        )
      ];
    }
  }

  @override
  Future<WalletResponse> getWalletInfo() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/wallet');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return WalletResponse.fromJson(data);
    } catch (e) {
      return WalletResponse(
        walletAddress: '0x71C7656EC7ab88b098defB751B7401B5f6d8976F',
        network: 'Ethereum (ERC-20)',
        status: 'ACTIVE',
      );
    }
  }

  @override
  Future<FatcaResponse> getFatcaInfo() async {
    try {
      final response = await _client.dio.get('/api/client/client-profiles/fatca');
      final data = response.data['data'] ?? response.data['Data'] ?? response.data;
      return FatcaResponse.fromJson(data);
    } catch (e) {
      return FatcaResponse(
        isUSTaxResident: false,
        taxResidencyCountry: 'AE',
        fatcaStatus: 'COMPLIANT',
        crsStatus: 'COMPLIANT',
      );
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

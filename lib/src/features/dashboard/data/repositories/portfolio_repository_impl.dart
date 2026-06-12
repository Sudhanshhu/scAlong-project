import '../../domain/repositories/portfolio_repository.dart';
import '../models/portfolio_model.dart';
import 'package:midchains_customer_portal/src/core/network/dio_client.dart';
import 'package:midchains_customer_portal/src/core/storage/secure_storage_service.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final DioClient _client;
  final SecureStorageService _storage;

  PortfolioRepositoryImpl({
    required DioClient client,
    required SecureStorageService storage,
  })  : _client = client,
        _storage = storage;

  @override
  Future<DashboardData> getDashboard() async {
    try {
      // Real first name from the aggregate profile endpoint.
      String userName = '';
      final profileRes = await _client.dio.get('/api/kyc/client-profiles/all');
      final profileBody = profileRes.data as Map<String, dynamic>;
      final data = (profileBody['data'] ?? profileBody) as Map<String, dynamic>;
      final personal =
          (data['personalAndResidential'] as Map?)?.cast<String, dynamic>() ?? {};
      userName = (personal['firstname'] ?? '').toString().trim();
      if (userName.isEmpty) {
        userName = (await _storage.getUserName()) ?? '';
      }

      // Real wallet holdings (empty for accounts with no linked wallet).
      final walletRes =
          await _client.dio.get('/api/kyc/client-profiles/wallet');
      final walletBody = walletRes.data as Map<String, dynamic>;
      final walletData = walletBody['data'];
      final holdings = walletData is List
          ? walletData
              .whereType<Map>()
              .map((e) => WalletHolding.fromJson(e.cast<String, dynamic>()))
              .toList()
          : <WalletHolding>[];

      return DashboardData(userName: userName, holdings: holdings);
    } catch (e) {
      throw Exception('Failed to load dashboard: $e');
    }
  }
}

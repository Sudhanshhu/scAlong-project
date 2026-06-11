import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/account_repository.dart';
import '../../data/models/account_models.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadAccountDetails() async {
    emit(AccountLoading());
    try {
      // Fetch all details in parallel using Future.wait
      final results = await Future.wait([
        _repository.getPersonalInfo(),
        _repository.getKycStatus(),
        _repository.getDocuments(),
        _repository.getWalletInfo(),
        _repository.getFatcaInfo(),
      ]);

      emit(AccountLoaded(
        personalInfo: results[0] as PersonalInfoResponse,
        kycStatus: results[1] as KycStatusResponse,
        documents: results[2] as List<DocumentResponse>,
        wallet: results[3] as WalletResponse,
        fatca: results[4] as FatcaResponse,
      ));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    // If successfully loaded, we can trigger update and reload
    if (state is AccountLoaded) {
      emit(AccountLoading());
      try {
        await _repository.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
        await loadAccountDetails();
      } catch (e) {
        emit(AccountError(e.toString()));
      }
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

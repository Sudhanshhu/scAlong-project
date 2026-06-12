import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/account_repository.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadAccountDetails() async {
    emit(AccountLoading());
    try {
      final details = await _repository.getAccountDetails();

      emit(AccountLoaded(
        personalInfo: details.personalInfo,
        kycStatus: details.kycStatus,
        documents: details.documents,
        wallet: details.wallet,
        fatca: details.fatca,
        bank: details.bank,
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

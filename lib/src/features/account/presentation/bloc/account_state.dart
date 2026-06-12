import 'package:equatable/equatable.dart';
import '../../data/models/account_models.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final PersonalInfoResponse personalInfo;
  final KycStatusResponse kycStatus;
  final List<DocumentResponse> documents;
  final WalletResponse wallet;
  final FatcaResponse fatca;
  final BankResponse? bank;

  const AccountLoaded({
    required this.personalInfo,
    required this.kycStatus,
    required this.documents,
    required this.wallet,
    required this.fatca,
    this.bank,
  });

  @override
  List<Object?> get props =>
      [personalInfo, kycStatus, documents, wallet, fatca, bank];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object?> get props => [message];
}

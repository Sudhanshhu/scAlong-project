import 'package:json_annotation/json_annotation.dart';

part 'account_models.g.dart';

@JsonSerializable()
class PersonalInfoResponse {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nationality;
  final String dateOfBirth;
  final String gender;
  final String address;

  PersonalInfoResponse({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  factory PersonalInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoResponseToJson(this);
}

@JsonSerializable()
class DocumentResponse {
  final String docType;
  final String docNumber;
  final String expiryDate;
  final String status;

  DocumentResponse({
    required this.docType,
    required this.docNumber,
    required this.expiryDate,
    required this.status,
  });

  factory DocumentResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentResponseToJson(this);
}

@JsonSerializable()
class KycStatusResponse {
  final String kycStatus;
  final String level;
  final List<String> completedSteps;

  KycStatusResponse({
    required this.kycStatus,
    required this.level,
    required this.completedSteps,
  });

  factory KycStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$KycStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KycStatusResponseToJson(this);
}

@JsonSerializable()
class WalletResponse {
  final String walletAddress;
  final String network;
  final String status;

  WalletResponse({
    required this.walletAddress,
    required this.network,
    required this.status,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletResponseToJson(this);
}

@JsonSerializable()
class FatcaResponse {
  final bool isUSTaxResident;
  final String taxResidencyCountry;
  final String? tinNumber;
  final String fatcaStatus;
  final String crsStatus;

  FatcaResponse({
    required this.isUSTaxResident,
    required this.taxResidencyCountry,
    this.tinNumber,
    required this.fatcaStatus,
    required this.crsStatus,
  });

  factory FatcaResponse.fromJson(Map<String, dynamic> json) =>
      _$FatcaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FatcaResponseToJson(this);
}

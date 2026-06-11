// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoResponse _$PersonalInfoResponseFromJson(
  Map<String, dynamic> json,
) => PersonalInfoResponse(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  nationality: json['nationality'] as String,
  dateOfBirth: json['dateOfBirth'] as String,
  gender: json['gender'] as String,
  address: json['address'] as String,
);

Map<String, dynamic> _$PersonalInfoResponseToJson(
  PersonalInfoResponse instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'nationality': instance.nationality,
  'dateOfBirth': instance.dateOfBirth,
  'gender': instance.gender,
  'address': instance.address,
};

DocumentResponse _$DocumentResponseFromJson(Map<String, dynamic> json) =>
    DocumentResponse(
      docType: json['docType'] as String,
      docNumber: json['docNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$DocumentResponseToJson(DocumentResponse instance) =>
    <String, dynamic>{
      'docType': instance.docType,
      'docNumber': instance.docNumber,
      'expiryDate': instance.expiryDate,
      'status': instance.status,
    };

KycStatusResponse _$KycStatusResponseFromJson(Map<String, dynamic> json) =>
    KycStatusResponse(
      kycStatus: json['kycStatus'] as String,
      level: json['level'] as String,
      completedSteps: (json['completedSteps'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$KycStatusResponseToJson(KycStatusResponse instance) =>
    <String, dynamic>{
      'kycStatus': instance.kycStatus,
      'level': instance.level,
      'completedSteps': instance.completedSteps,
    };

WalletResponse _$WalletResponseFromJson(Map<String, dynamic> json) =>
    WalletResponse(
      walletAddress: json['walletAddress'] as String,
      network: json['network'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$WalletResponseToJson(WalletResponse instance) =>
    <String, dynamic>{
      'walletAddress': instance.walletAddress,
      'network': instance.network,
      'status': instance.status,
    };

FatcaResponse _$FatcaResponseFromJson(Map<String, dynamic> json) =>
    FatcaResponse(
      isUSTaxResident: json['isUSTaxResident'] as bool,
      taxResidencyCountry: json['taxResidencyCountry'] as String,
      tinNumber: json['tinNumber'] as String?,
      fatcaStatus: json['fatcaStatus'] as String,
      crsStatus: json['crsStatus'] as String,
    );

Map<String, dynamic> _$FatcaResponseToJson(FatcaResponse instance) =>
    <String, dynamic>{
      'isUSTaxResident': instance.isUSTaxResident,
      'taxResidencyCountry': instance.taxResidencyCountry,
      'tinNumber': instance.tinNumber,
      'fatcaStatus': instance.fatcaStatus,
      'crsStatus': instance.crsStatus,
    };

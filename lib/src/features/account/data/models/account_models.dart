// Models for the Account/Profile feature.
//
// These are parsed from the gateway's single aggregate endpoint
// `GET /api/kyc/client-profiles/all`, whose `data` object is shaped like:
//
// {
//   "accountType": { "type", "nationality", "countryOfResidence" },
//   "personalAndResidential": { "firstname", "lastname", "dob", "gender",
//       "city", "addressline1", "addressline2", "isUsPerson", ... },
//   "occupationalAndBanking": { "occupation", "annualIncome", ... },
//   "fatcaAndCrs": { "isUaeTaxResidency", "isOtherJurisdiction",
//       "jurisdictionCountryName", "isLiableToOtherCountryTax", ... },
//   "documents": { "documents": null, "levelName", "isFaceRecognitionDone" }
// }
//
// Fields are intentionally tolerant of nulls/missing keys, because the dev
// backend returns null for several of them.

String _str(dynamic v, [String fallback = 'N/A']) {
  if (v == null) return fallback;
  final s = v.toString().trim();
  return s.isEmpty ? fallback : s;
}

bool _bool(dynamic v) => v == true;

/// Aggregate returned by the repository in a single call.
class AccountDetails {
  final PersonalInfoResponse personalInfo;
  final KycStatusResponse kycStatus;
  final List<DocumentResponse> documents;
  final WalletResponse wallet;
  final FatcaResponse fatca;

  /// Linked bank account, or null when none is linked (real endpoint 404s).
  final BankResponse? bank;

  const AccountDetails({
    required this.personalInfo,
    required this.kycStatus,
    required this.documents,
    required this.wallet,
    required this.fatca,
    this.bank,
  });

  /// Builds the aggregate from the `data` object of `/api/kyc/client-profiles/all`.
  /// [email] is supplied separately (the endpoint does not return it), and
  /// [bank] comes from a separate endpoint (null when no bank is linked).
  factory AccountDetails.fromAll(
    Map<String, dynamic> data, {
    String? email,
    BankResponse? bank,
  }) {
    final account = (data['accountType'] as Map?)?.cast<String, dynamic>() ?? {};
    final personal =
        (data['personalAndResidential'] as Map?)?.cast<String, dynamic>() ?? {};
    final fatca = (data['fatcaAndCrs'] as Map?)?.cast<String, dynamic>() ?? {};
    final docs = (data['documents'] as Map?)?.cast<String, dynamic>() ?? {};

    return AccountDetails(
      personalInfo: PersonalInfoResponse.fromProfile(personal, account, email),
      kycStatus: KycStatusResponse.fromDocuments(docs),
      documents: DocumentResponse.listFrom(docs['documents']),
      wallet: WalletResponse.fromJson(data['wallet']),
      fatca: FatcaResponse.fromFatcaCrs(fatca, personal),
      bank: bank,
    );
  }
}

/// Linked bank account from `/api/clientBasicinfo/client/details`.
class BankResponse {
  final String bankName;
  final String accountNumber;
  final String iban;
  final String currency;
  final String status;

  const BankResponse({
    required this.bankName,
    required this.accountNumber,
    required this.iban,
    required this.currency,
    required this.status,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map?)?.cast<String, dynamic>() ?? json;
    return BankResponse(
      bankName: _str(data['bankName']),
      accountNumber: _str(data['accountNumber']),
      iban: _str(data['iban']),
      currency: _str(data['currency']),
      status: _str(data['status'], 'VERIFIED'),
    );
  }
}

class PersonalInfoResponse {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nationality;
  final String dateOfBirth;
  final String gender;
  final String address;

  const PersonalInfoResponse({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  factory PersonalInfoResponse.fromProfile(
    Map<String, dynamic> personal,
    Map<String, dynamic> account,
    String? email,
  ) {
    final addressParts = [
      personal['addressline1'],
      personal['addressline2'],
      personal['city'],
    ].where((p) => p != null && p.toString().trim().isNotEmpty).join(', ');

    return PersonalInfoResponse(
      firstName: _str(personal['firstname']),
      lastName: _str(personal['lastname']),
      email: _str(email),
      phone: _str(personal['phone'], 'Not provided'),
      nationality: _str(account['nationality']),
      dateOfBirth: _str(personal['dob']),
      gender: _str(personal['gender']),
      address: addressParts.isEmpty ? 'N/A' : addressParts,
    );
  }
}

class DocumentResponse {
  final String docType;
  final String docNumber;
  final String expiryDate;
  final String status;

  const DocumentResponse({
    required this.docType,
    required this.docNumber,
    required this.expiryDate,
    required this.status,
  });

  factory DocumentResponse.fromJson(Map<String, dynamic> json) =>
      DocumentResponse(
        docType: _str(json['docType']),
        docNumber: _str(json['docNumber']),
        expiryDate: _str(json['expiryDate']),
        status: _str(json['status']),
      );

  /// The aggregate endpoint returns `documents: null` for accounts with no
  /// uploaded docs; tolerate null / non-list shapes.
  static List<DocumentResponse> listFrom(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => DocumentResponse.fromJson(e.cast<String, dynamic>()))
          .toList();
    }
    return const [];
  }
}

class KycStatusResponse {
  final String kycStatus;
  final String level;
  final List<String> completedSteps;

  const KycStatusResponse({
    required this.kycStatus,
    required this.level,
    required this.completedSteps,
  });

  factory KycStatusResponse.fromDocuments(Map<String, dynamic> docs) {
    final level = _str(docs['levelName']);
    final faceDone = _bool(docs['isFaceRecognitionDone']);
    return KycStatusResponse(
      kycStatus: faceDone ? 'APPROVED' : 'PENDING',
      level: level,
      completedSteps: level == 'N/A' ? const [] : [level],
    );
  }
}

class WalletResponse {
  final String walletAddress;
  final String network;
  final String status;
  final bool linked;

  const WalletResponse({
    required this.walletAddress,
    required this.network,
    required this.status,
    this.linked = false,
  });

  /// Wallet may be absent or an empty list on the dev backend.
  factory WalletResponse.fromJson(dynamic json) {
    if (json is Map && json.isNotEmpty) {
      final m = json.cast<String, dynamic>();
      return WalletResponse(
        walletAddress: _str(m['walletAddress'], 'No wallet linked'),
        network: _str(m['network']),
        status: _str(m['status'], 'INACTIVE'),
        linked: true,
      );
    }
    return const WalletResponse(
      walletAddress: 'No wallet linked',
      network: 'N/A',
      status: 'INACTIVE',
      linked: false,
    );
  }
}

class FatcaResponse {
  final bool isUSTaxResident;
  final String taxResidencyCountry;
  final String? tinNumber;
  final String fatcaStatus;
  final String crsStatus;

  const FatcaResponse({
    required this.isUSTaxResident,
    required this.taxResidencyCountry,
    this.tinNumber,
    required this.fatcaStatus,
    required this.crsStatus,
  });

  factory FatcaResponse.fromFatcaCrs(
    Map<String, dynamic> fatca,
    Map<String, dynamic> personal,
  ) {
    return FatcaResponse(
      isUSTaxResident: _bool(personal['isUsPerson']),
      taxResidencyCountry: _str(fatca['jurisdictionCountryName']),
      tinNumber: fatca['w8formId']?.toString(),
      fatcaStatus: _bool(fatca['isUaeTaxResidency']) ? 'UAE_RESIDENT' : 'NON_RESIDENT',
      crsStatus: _bool(fatca['isOtherJurisdiction']) ? 'DECLARED' : 'COMPLIANT',
    );
  }
}

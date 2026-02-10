/// Asset Metadata Classes
/// Type-specific metadata stored in the JSONB metadata column

/// Stock/ETF Metadata
class StockMetadata {
  const StockMetadata({
    this.exchange,
    this.sector,
    this.industry,
    this.country,
  });

  final String? exchange; // e.g., "NASDAQ", "NYSE"
  final String? sector; // e.g., "Technology", "Healthcare"
  final String? industry; // e.g., "Consumer Electronics"
  final String? country; // e.g., "USA"

  Map<String, dynamic> toJson() {
    return {
      if (exchange != null) 'exchange': exchange,
      if (sector != null) 'sector': sector,
      if (industry != null) 'industry': industry,
      if (country != null) 'country': country,
    };
  }

  factory StockMetadata.fromJson(Map<String, dynamic> json) {
    return StockMetadata(
      exchange: json['exchange'] as String?,
      sector: json['sector'] as String?,
      industry: json['industry'] as String?,
      country: json['country'] as String?,
    );
  }
}

/// Bond Metadata
class BondMetadata {
  const BondMetadata({
    this.issuer,
    this.couponRate,
    this.maturityDate,
    this.bondType,
    this.rating,
  });

  final String? issuer;
  final double? couponRate;
  final DateTime? maturityDate;
  final String? bondType; // government, corporate, municipal
  final String? rating; // AAA, AA+, etc.

  Map<String, dynamic> toJson() {
    return {
      if (issuer != null) 'issuer': issuer,
      if (couponRate != null) 'coupon_rate': couponRate,
      if (maturityDate != null) 'maturity_date': maturityDate!.toIso8601String(),
      if (bondType != null) 'bond_type': bondType,
      if (rating != null) 'rating': rating,
    };
  }

  factory BondMetadata.fromJson(Map<String, dynamic> json) {
    return BondMetadata(
      issuer: json['issuer'] as String?,
      couponRate: (json['coupon_rate'] as num?)?.toDouble(),
      maturityDate: json['maturity_date'] != null
          ? DateTime.parse(json['maturity_date'] as String)
          : null,
      bondType: json['bond_type'] as String?,
      rating: json['rating'] as String?,
    );
  }
}

/// Real Estate Metadata
class RealEstateMetadata {
  const RealEstateMetadata({
    this.propertyType,
    this.address,
    this.city,
    this.country,
    this.areaSqm,
    this.yearBuilt,
    this.rentalIncome,
  });

  final String? propertyType; // residential, commercial, land
  final String? address;
  final String? city;
  final String? country;
  final double? areaSqm;
  final int? yearBuilt;
  final double? rentalIncome;

  Map<String, dynamic> toJson() {
    return {
      if (propertyType != null) 'property_type': propertyType,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (areaSqm != null) 'area_sqm': areaSqm,
      if (yearBuilt != null) 'year_built': yearBuilt,
      if (rentalIncome != null) 'rental_income': rentalIncome,
    };
  }

  factory RealEstateMetadata.fromJson(Map<String, dynamic> json) {
    return RealEstateMetadata(
      propertyType: json['property_type'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      areaSqm: (json['area_sqm'] as num?)?.toDouble(),
      yearBuilt: json['year_built'] as int?,
      rentalIncome: (json['rental_income'] as num?)?.toDouble(),
    );
  }
}

/// Gold Metadata
class GoldMetadata {
  const GoldMetadata({
    this.form,
    this.purity,
    this.weightOz,
    this.storageLocation,
  });

  final String? form; // bar, coin, jewelry
  final double? purity; // 0.999
  final double? weightOz;
  final String? storageLocation;

  Map<String, dynamic> toJson() {
    return {
      if (form != null) 'form': form,
      if (purity != null) 'purity': purity,
      if (weightOz != null) 'weight_oz': weightOz,
      if (storageLocation != null) 'storage_location': storageLocation,
    };
  }

  factory GoldMetadata.fromJson(Map<String, dynamic> json) {
    return GoldMetadata(
      form: json['form'] as String?,
      purity: (json['purity'] as num?)?.toDouble(),
      weightOz: (json['weight_oz'] as num?)?.toDouble(),
      storageLocation: json['storage_location'] as String?,
    );
  }
}

/// Crypto Metadata
class CryptoMetadata {
  const CryptoMetadata({
    this.network,
    this.walletAddress,
    this.staking,
  });

  final String? network; // ethereum, bitcoin, solana
  final String? walletAddress;
  final bool? staking;

  Map<String, dynamic> toJson() {
    return {
      if (network != null) 'network': network,
      if (walletAddress != null) 'wallet_address': walletAddress,
      if (staking != null) 'staking': staking,
    };
  }

  factory CryptoMetadata.fromJson(Map<String, dynamic> json) {
    return CryptoMetadata(
      network: json['network'] as String?,
      walletAddress: json['wallet_address'] as String?,
      staking: json['staking'] as bool?,
    );
  }
}

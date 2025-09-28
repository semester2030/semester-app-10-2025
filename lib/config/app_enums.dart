enum GenderEnum {
  male(1),
  female(2),
  notSay(3);

  final int id;

  const GenderEnum(this.id);

  // You can add a method to get an enum value by its ID if needed
  static GenderEnum? fromId(int id) {
    return GenderEnum.values
        .firstWhere((gender) => gender.id == id, orElse: () => GenderEnum.male);
  }
}

enum IsKoshkarEnum { yes, no }

enum BusinessLocationType { mal, street }

enum StatisticsPageEnum { statistics, allBusinesses, notifications }

enum CompanyDashboardEnum { locations, managers, businesses }

enum AdvertisementType {
  productOfMonth,
  mostRequestedProduct,
  upTo50Shekel,
}

extension AdvertisementTypeExtension on AdvertisementType {
  static AdvertisementType fromString(String value) {
    switch (value) {
      case "המוצרים של החודש":
        return AdvertisementType.productOfMonth;
      case "מוצרים עד50 ש”ח":
        return AdvertisementType.upTo50Shekel;
      default:
        return AdvertisementType.mostRequestedProduct;
    }
  }

  String get displayName {
    switch (this) {
      case AdvertisementType.productOfMonth:
        return "המוצרים של החודש";
      case AdvertisementType.upTo50Shekel:
        return "מוצרים עד50 ש”ח";
      case AdvertisementType.mostRequestedProduct:
        return "המוצרים המבוקשים ביותר";
    }
  }

  String get apiValue {
    switch (this) {
      case AdvertisementType.productOfMonth:
        return "PRODUCT_OF_MONTH";
      case AdvertisementType.upTo50Shekel:
        return "UPTO_99_SHEKEL";
      case AdvertisementType.mostRequestedProduct:
        return "MOST_REQUESTED_PRODUCT";
    }
  }
}

enum ImageType { logo, businessImage, certificate }

enum PageContentType {
  privacyPolicy,
  termsAndCondition,
  about;

  String get title {
    switch (this) {
      case PageContentType.privacyPolicy:
        return 'Privacy Policy';
      case PageContentType.termsAndCondition:
        return 'Terms and Conditions';
      case PageContentType.about:
        return 'About Us';
    }
  }
}

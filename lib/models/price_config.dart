import 'service_type.dart';

class ServicePrice {
  final double regular;
  final double seasonal;
  final double? extraPetRegular;
  final double? extraPetSeasonal;

  ServicePrice({
    required this.regular,
    required this.seasonal,
    this.extraPetRegular,
    this.extraPetSeasonal,
  });

  double getPrice(bool isSeasonal, {bool extraPet = false}) {
    if (extraPet && extraPetRegular != null && extraPetSeasonal != null) {
      return isSeasonal ? extraPetSeasonal! : extraPetRegular!;
    }
    return isSeasonal ? seasonal : regular;
  }
}

class PriceConfig {
  final Map<ServiceType, ServicePrice> prices;

  PriceConfig({required this.prices});
}
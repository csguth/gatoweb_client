import '../models/service_type.dart';
import '../models/price_config.dart';

final priceConfig = PriceConfig(prices: {
  ServiceType.hondenUitlaatservice: ServicePrice(
    regular: 18,
    seasonal: 22,
    extraPetRegular: 10,
    extraPetSeasonal: 12,
  ),
  ServiceType.eenHuisbezoekPerDag: ServicePrice(
    regular: 18,
    seasonal: 22,
  ),
  ServiceType.tweeHuisbezoekenPerDag: ServicePrice(
    regular: 28,
    seasonal: 34,
  ),
});
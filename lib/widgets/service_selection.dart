import 'package:flutter/material.dart';
import '../models/service_type.dart';
import '../models/price_config.dart';
import '../utils/season_utils.dart';
import '../localization/app_localizations.dart';

class ServiceSelection extends StatelessWidget {
  final ServiceType? selectedService;
  final ValueChanged<ServiceType?> onChanged;
  final PriceConfig priceConfig;
  final DateTime? startDate;

  const ServiceSelection({
    super.key,
    required this.selectedService,
    required this.onChanged,
    required this.priceConfig,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    const services = ServiceType.values;
    final isSeasonal = startDate != null && isSummer(startDate!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context, 'choose_service'), style: const TextStyle(fontWeight: FontWeight.bold)),
        ...services.map((service) {
          final price = priceConfig.prices[service]!;
          String priceText;
          if (service == ServiceType.hondenUitlaatservice) {
            priceText = '${AppLocalizations.of(context, 'starting_from')} € ${price.getPrice(isSeasonal).toStringAsFixed(0)} '
              '/${AppLocalizations.of(context, 'walk')}, '
              '€ ${price.getPrice(isSeasonal, extraPet: true).toStringAsFixed(0)} '
              '/${AppLocalizations.of(context, 'extra_pet')}';
          } else {
            priceText = '${AppLocalizations.of(context, 'starting_from')} € ${price.getPrice(isSeasonal).toStringAsFixed(0)} '
              '/${AppLocalizations.of(context, 'day')}';
          }
          return Card(
            child: RadioListTile<ServiceType>(
              value: service,
              groupValue: selectedService,
              onChanged: onChanged,
              title: Text(service.localizedName(context)),
              subtitle: Text(priceText, style: const TextStyle(color: Colors.green)),
            ),
          );
        }),
      ],
    );
  }
}
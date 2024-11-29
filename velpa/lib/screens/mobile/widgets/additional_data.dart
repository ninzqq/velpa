import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:intl/intl.dart';
import 'package:velpa/utils/snackbar.dart';

class AdditionalDataContainer extends ConsumerWidget {
  final MapMarker? marker;
  const AdditionalDataContainer({super.key, this.marker});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    MapMarker? tempMarker;
    if (marker == null) {
      tempMarker = ref.read(mapMarkersProvider).tempMarker;
    } else {
      tempMarker = marker;
    }

    // Define the date format
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');

    if (tempMarker == null) {
      showSnackBar('Ei tilapäistä veneenlaskupaikkaa', const Icon(Icons.error));
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> detailItems = [
      {
        "leading": "Sijainti: ",
        "icon": const Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        "value":
            '\nLat: ${tempMarker.point.latitude.toString()}\nLon: ${tempMarker.point.longitude.toString()}',
      },
      {
        "leading": "Luonut: ",
        "icon": const Icon(
          Icons.person,
          color: Colors.orange,
        ),
        "value": tempMarker.createdBy,
      },
      {
        "leading": "Luotu: ",
        "icon": const Icon(
          Icons.calendar_today,
          color: Colors.red,
        ),
        "value": dateFormat.format(tempMarker.createdAt),
      },
      {
        "leading": "Päivitetty: ",
        "icon": const Icon(
          Icons.update,
          color: Colors.red,
        ),
        "value": dateFormat.format(tempMarker.updatedAt),
      }
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
      ),
      child: Column(
        children: List.generate(
          detailItems.length,
          (index) {
            return ListTile(
              leading: detailItems[index]['icon'],
              title: Text.rich(
                TextSpan(
                  text: detailItems[index]['leading'],
                  style: theme.textTheme.labelMedium,
                  children: [
                    TextSpan(
                      text: detailItems[index]['value'],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            );
          },
        ),
      ),
    );
  }
}

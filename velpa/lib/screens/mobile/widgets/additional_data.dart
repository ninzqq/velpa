import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:intl/intl.dart';

class AdditionalDataContainer extends ConsumerWidget {
  const AdditionalDataContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var tempMarker = ref.read(mapMarkersProvider).tempMarker;

    // Define the date format
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: tempMarker != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdditionalDataItem(
                      title: 'Location: ',
                      data:
                          '\n\t\t\t\tLat: ${tempMarker.point.latitude}, \n\t\t\t\tLon: ${tempMarker.point.longitude}',
                    ),
                    AdditionalDataItem(
                      title: 'Created by: ',
                      data: tempMarker.createdBy,
                    ),
                    AdditionalDataItem(
                      title: 'Created at: ',
                      data: dateFormat.format(tempMarker.createdAt),
                    ),
                    AdditionalDataItem(
                      title: 'Last updated: ',
                      data: dateFormat.format(tempMarker.updatedAt),
                    ),
                  ],
                )
              : const Text('No voee rähmä, vituiks män'),
        ),
      ),
    );
  }
}

class AdditionalDataItem extends ConsumerWidget {
  final String title;
  final String data;
  const AdditionalDataItem({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Text(
        title + data,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

class MarkerDetailsBottomSheet extends ConsumerWidget {
  final String id;
  const MarkerDetailsBottomSheet({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final markerProvider = ref.watch(mapMarkersProvider);
    final marker = markerProvider.getMarkerById(id);

    if (marker == null) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: BottomSheet(
            enableDrag: false,
            backgroundColor: theme.colorScheme.primary,
            onClosing: () {},
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        DetailItem(
                          data: marker.title,
                        ),
                        DetailItem(
                          data: marker.water,
                        ),
                        DetailItem(
                          data:
                              'Location: \n\t\tLat:${marker.point.latitude.toString()}\n\t\tLon:${marker.point.longitude.toString()}',
                        ),
                        DetailItem(
                          data: marker.description,
                        ),
                        DetailItem(
                          data: marker.createdBy,
                        ),
                        DetailItem(
                          data: marker.createdAt.toString(),
                        ),
                        DetailItem(
                          data: marker.updatedAt.toString(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DetailItem extends ConsumerWidget {
  final String data;
  const DetailItem({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return SizedBox(
      child: Text(
        data,
        style: theme.textTheme.labelSmall,
      ),
    );
  }
}

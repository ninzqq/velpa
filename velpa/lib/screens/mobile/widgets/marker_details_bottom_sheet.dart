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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: BottomSheet(
        enableDrag: false,
        backgroundColor: theme.colorScheme.primary,
        onClosing: () {},
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Marker ${marker.id}',
                      style: theme.textTheme.labelMedium,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velpa/models/local_models.dart';
import 'package:velpa/screens/mobile/widgets/marker_details_bottom_sheet.dart';

class MarkerMapIcon extends ConsumerWidget {
  final String id;

  const MarkerMapIcon(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFlags = ref.read(appFlagsProvider);
    var logger = Logger();

    return GestureDetector(
      child: const Icon(
        Icons.location_on,
        color: Colors.blue,
      ),
      onTap: () => {
        appFlags.debug ? logger.d('Marker $id tapped!}') : null,
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return MarkerDetailsBottomSheet(id: id);
          },
        ),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/utils/snackbar.dart';

class DeleteMarkerConfirmDialog extends ConsumerWidget {
  final String markerId;

  const DeleteMarkerConfirmDialog({
    required this.markerId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return AlertDialog(
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Haluatko varmasti poistaa tämän veneenlaskupaikan?'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final nav = Navigator.of(context);
            try {
              await ref.read(mapMarkersProvider).deleteMarker(markerId, ref);
              showSnackBar('Veneenlaskupaikka poistettu',
                  const Icon(Icons.check_circle_rounded, color: Colors.green));
              nav.popUntil((route) => route.isFirst);
            } catch (e) {
              showSnackBar('Poistaminen epäonnistui',
                  const Icon(Icons.error, color: Colors.red));
            }
          },
          child: const Text(
            'Poista',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Peruuta', style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

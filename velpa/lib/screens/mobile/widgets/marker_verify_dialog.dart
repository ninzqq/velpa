import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/services/firestore.dart';
import 'package:velpa/utils/snackbar.dart';

class VerifyMarkerDialog extends ConsumerWidget {
  final String markerId;

  const VerifyMarkerDialog({
    required this.markerId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Verify marker?'),
      actions: [
        TextButton(
          onPressed: () {
            final nav = Navigator.of(context);
            FirestoreService().verifyMapMarker(markerId).then((_) {
              ref.read(mapMarkersProvider).loadMarkersFromFirestore(ref);
              showSnackBar('Marker verified',
                  const Icon(Icons.check_circle_rounded, color: Colors.green));
              nav.popUntil((route) => route.isFirst);
            });
          },
          child: const Text(
            'Verify',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

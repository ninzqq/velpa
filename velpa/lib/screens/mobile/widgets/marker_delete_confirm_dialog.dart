import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/services/firestore.dart';
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
      title: const Text('Delete Marker'),
      content: const Text('Are you sure you want to delete this marker?'),
      actions: [
        TextButton(
          onPressed: () {
            final nav = Navigator.of(context);
            FirestoreService().deleteMapMarker(markerId).then((_) {
              ref.read(mapMarkersProvider).loadMarkersFromFirestore(ref);
              showSnackBar('Marker deleted');
              nav.popUntil((route) => route.isFirst);
            });
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
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

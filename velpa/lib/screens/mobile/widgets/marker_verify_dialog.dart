import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
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
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Vahvista veneenlaskupaikka?'),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final nav = Navigator.of(context);
            await ref.read(mapMarkersProvider).verifyMarker(markerId);
            showSnackBar('Veneenlaskupaikka vahvistettu',
                const Icon(Icons.check_circle_rounded, color: Colors.green));
            nav.popUntil((route) => route.isFirst);
          },
          child: const Text(
            'Vahvista',
            style: TextStyle(color: Colors.green),
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

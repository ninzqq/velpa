import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntroDialog extends ConsumerWidget {
  const IntroDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Tervetuloa Velpaan!',
        style: theme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Velpa on sovellus veneenlaskupaikkojen löytämiseen.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Käyttöohjeet:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• Selaa kartalta veneenlaskupaikkoja',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '• Klikkaa merkkiä nähdäksesi tarkemmat tiedot',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '• Kirjautuneena voit lisätä uusia paikkoja',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '• Voit myös muokata lisäämiäsi paikkoja',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Huomioitavaa:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• Tarkista aina paikan soveltuvuus veneellesi',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '• Noudata paikallisia ohjeita ja rajoituksia',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiaryContainer,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            child: Text(
              'Selvä!',
              style: theme.textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }
}

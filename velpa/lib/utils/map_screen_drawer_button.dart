import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class MapScreenDrawerButton extends ConsumerWidget {
  const MapScreenDrawerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: FloatingActionButton(
        onPressed: Scaffold.of(context).openDrawer,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.menu),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/providers/text_controller_provider.dart';
import 'package:velpa/screens/mobile/widgets/marker_list_tile.dart';

class MarkersScreen extends ConsumerWidget {
  const MarkersScreen({super.key});

  static const routeName = '/markers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var markers = ref.watch(mapMarkersProvider);
    var theme = Theme.of(context);
    var searchController = ref.watch(searchTextControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.primaryFixed,
          scrolledUnderElevation: 0,
          title: Text(
            'Markers',
            style: theme.textTheme.titleLarge,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: searchController.searchController,
                    onChanged: (String text) {
                      ref.read(mapMarkersProvider).filterMarkers(text);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.secondaryFixedDim,
                      ),
                      icon: const Icon(Icons.search,
                          color: Colors.white70, size: 24),
                      border: InputBorder.none,
                    ),
                    cursorColor: theme.colorScheme.primaryFixed,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: markers.filteredMarkers.length,
                itemBuilder: (context, index) {
                  return MarkerListTile(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

class AddNewMarkerBottomSheet extends ConsumerWidget {
  final LatLng point;
  const AddNewMarkerBottomSheet({super.key, required this.point});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: BottomSheet(
        enableDrag: false,
        backgroundColor: theme.colorScheme.primary,
        onClosing: () {},
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      'Add New Marker',
                      style: theme.textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView(
                        children: const [
                          InputField(
                            icon: Icons.title,
                            hintText: 'Title',
                          ),
                          InputField(
                            icon: Icons.water,
                            hintText: 'Name of the lake, bond, river, etc.',
                          ),
                          InputField(
                            icon: Icons.description,
                            hintText: 'Description',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const ConstantData(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref.read(mapMarkersProvider).addMarker(ref);
                        Navigator.pop(context);
                      },
                      child: const Text('Add Marker'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
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

class InputField extends ConsumerWidget {
  final IconData icon;
  final String hintText;
  const InputField({
    super.key,
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController textController = TextEditingController();
    var theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon),
      title: TextField(
        controller: textController,
        maxLines: 1,
        showCursor: true,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class ConstantData extends ConsumerWidget {
  const ConstantData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var tempMarker = ref.read(mapMarkersProvider).temporaryMarkers.first;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location: \n    Lat: ${tempMarker!.point.latitude}, \n    Lon: ${tempMarker.point.longitude}',
            style: theme.textTheme.bodyMedium,
          ),
          Text('Created by: ${tempMarker!.createdBy}',
              style: theme.textTheme.bodyMedium),
          Text('Created at: ${tempMarker.createdAt.toString()}',
              style: theme.textTheme.bodyMedium),
          Text('Last updated: ${tempMarker.updatedAt.toString()}',
              style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

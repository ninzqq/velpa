import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:intl/intl.dart';

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 0, left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Center(
                    child: Text(
                      'Add new marker',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    shrinkWrap: true,
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
                      AdditionalDataContainer(),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  color: theme.colorScheme.primary,
                  child: Row(
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          1,
        ),
        tileColor: theme.colorScheme.secondary,
        selected: false,
        leading: Icon(icon),
        title: TextField(
          controller: textController,
          maxLines: 1,
          cursorColor: theme.colorScheme.primaryFixed,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.secondaryFixedDim,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AdditionalDataContainer extends ConsumerWidget {
  const AdditionalDataContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var tempMarker = ref.read(mapMarkersProvider).temporaryMarkers.first;

    // Define the date format
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdditionalDataItem(
                title: 'Location: ',
                data:
                    '\n\t\t\t\tLat: ${tempMarker.point.latitude}, \n\t\t\t\tLon: ${tempMarker.point.longitude}',
              ),
              AdditionalDataItem(
                title: 'Created by: ',
                data: tempMarker.createdBy,
              ),
              AdditionalDataItem(
                title: 'Created at: ',
                data: dateFormat.format(tempMarker.createdAt),
              ),
              AdditionalDataItem(
                title: 'Last updated: ',
                data: dateFormat.format(tempMarker.updatedAt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalDataItem extends ConsumerWidget {
  final String title;
  final String data;
  const AdditionalDataItem({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Text(
        title + data,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

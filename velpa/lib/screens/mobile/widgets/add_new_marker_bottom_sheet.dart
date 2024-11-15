import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:intl/intl.dart';

class AddNewMarkerBottomSheet extends ConsumerWidget {
  final LatLng point;
  final TextEditingController titleController;
  final TextEditingController waterController;
  final TextEditingController descriptionController;

  const AddNewMarkerBottomSheet(
      {super.key,
      required this.point,
      required this.titleController,
      required this.waterController,
      required this.descriptionController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
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
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        shrinkWrap: true,
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
                          InputField(
                            icon: Icons.title,
                            hintText: 'Title',
                            textController: titleController,
                          ),
                          InputField(
                            icon: Icons.water,
                            hintText: 'Name of the lake, bond, river, etc.',
                            textController: waterController,
                          ),
                          InputField(
                            icon: Icons.description,
                            hintText: 'Description',
                            textController: descriptionController,
                          ),
                          const AdditionalDataContainer(),
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
        ),
      ),
    );
  }
}

class InputField extends ConsumerWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController textController;
  const InputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.textController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);

    switch (icon) {
      case Icons.title:
        textController.text =
            ref.read(mapMarkersProvider).tempMarker?.title ?? '';
        break;
      case Icons.water:
        textController.text =
            ref.read(mapMarkersProvider).tempMarker?.water ?? '';
        break;
      case Icons.description:
        textController.text =
            ref.read(mapMarkersProvider).tempMarker?.description ?? '';
        break;
      default:
        textController.text = '';
    }

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          hasFocus ? () => {} : {};
        },
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
            controller: textController..text,
            onChanged: (a) =>
                {ref.read(mapMarkersProvider).tempMarker!.setTitle = a},
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
            keyboardType: TextInputType.text,
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
    var tempMarker = ref.read(mapMarkersProvider).tempMarker;

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
          child: tempMarker != null
              ? Column(
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
                )
              : const Text('No voee rähmä, vituiks män'),
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

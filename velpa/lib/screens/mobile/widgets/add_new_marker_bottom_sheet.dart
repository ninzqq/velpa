import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/screens/mobile/widgets/input_data_field.dart';
import 'package:velpa/services/firestore.dart';
import 'package:velpa/screens/mobile/widgets/additional_data.dart';
import 'package:velpa/utils/snackbar.dart';

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
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BottomSheet(
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
                                if (titleController.text.isEmpty ||
                                    waterController.text.isEmpty ||
                                    descriptionController.text.isEmpty) {
                                  showSnackBar(
                                      'Please fill in all fields',
                                      const Icon(Icons.priority_high_rounded,
                                          color: Colors.red));
                                  return;
                                } else {
                                  final nav = Navigator.of(context);
                                  //ref.read(mapMarkersProvider).addMarker(ref);
                                  FirestoreService()
                                      .addMapMarkerToFirestore(ref
                                          .read(mapMarkersProvider)
                                          .tempMarker!)
                                      .then((_) {
                                    ref
                                        .read(mapMarkersProvider)
                                        .loadMarkersFromFirestore(ref);
                                    nav.pop();
                                  });
                                }
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
      ),
    );
  }
}

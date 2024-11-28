import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/input_data_field.dart';
import 'package:velpa/services/auth.dart';
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
                return Column(
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
                                'Lisää veneenlaskupaikka',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          ),
                          InputField(
                            icon: Icons.title,
                            hintText: 'Otsikko',
                            textController: titleController,
                          ),
                          InputField(
                            icon: Icons.water,
                            hintText: 'Vesistö',
                            textController: waterController,
                          ),
                          InputField(
                            icon: Icons.description,
                            hintText: 'Kuvaus',
                            textController: descriptionController,
                          ),
                          const AdditionalDataContainer(),
                        ],
                      ),
                    ),
                    Container(
                      color: theme.colorScheme.primary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                if (titleController.text.isEmpty ||
                                    waterController.text.isEmpty ||
                                    descriptionController.text.isEmpty) {
                                  showSnackBar(
                                      'Täytä kaikki kentät',
                                      const Icon(Icons.priority_high_rounded,
                                          color: Colors.red));
                                  return;
                                } else if (AuthService().user == null) {
                                  showSnackBar(
                                      'Kirjaudu sisään lisätäksesi veneenlaskupaikka',
                                      const Icon(Icons.priority_high_rounded,
                                          color: Colors.red));
                                  return;
                                } else {
                                  final nav = Navigator.of(context);
                                  try {
                                    await ref
                                        .read(mapMarkersProvider)
                                        .addMarker(ref);
                                    nav.pop();
                                  } catch (e) {
                                    showSnackBar(
                                        'Lisääminen epäonnistui',
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }
                                }
                              },
                              child: Tooltip(
                                message: 'Lisää merkki',
                                child: Container(
                                  color: theme.colorScheme.tertiary,
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.done,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Tooltip(
                                message: 'Sulje',
                                child: Container(
                                  color: theme.colorScheme.tertiary,
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.expand_more,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

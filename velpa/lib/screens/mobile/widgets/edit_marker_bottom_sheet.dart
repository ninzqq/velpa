import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/screens/mobile/widgets/input_data_field.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/screens/mobile/widgets/additional_data.dart';
import 'package:velpa/utils/snackbar.dart';

class EditMarkerBottomSheet extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  EditMarkerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var tempMarker = ref.read(mapMarkersProvider).tempMarker;

    if (tempMarker == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
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
                                'Muokkaa veneenlaskupaikkaa',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          ),
                          InputField(
                            icon: Icons.title,
                            hintText: 'Otsikko',
                            textController: titleController
                              ..text = tempMarker.title,
                            marker: tempMarker,
                          ),
                          InputField(
                            icon: Icons.water,
                            hintText: 'Vesistö',
                            textController: waterController
                              ..text = tempMarker.water,
                            marker: tempMarker,
                          ),
                          InputField(
                            icon: Icons.description,
                            hintText: 'Kuvaus',
                            textController: descriptionController
                              ..text = tempMarker.description,
                            marker: tempMarker,
                          ),
                          AdditionalDataContainer(marker: tempMarker),
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
                                      'Kirjaudu sisään muokataksesi veneenlaskupaikkaa',
                                      const Icon(Icons.priority_high_rounded,
                                          color: Colors.red));
                                  return;
                                } else {
                                  var updatedTempMarker =
                                      ref.read(mapMarkersProvider).tempMarker;
                                  final nav = Navigator.of(context);
                                  try {
                                    await ref
                                        .read(mapMarkersProvider)
                                        .updateMarker(updatedTempMarker!, ref);
                                    nav.pop();
                                  } catch (e) {
                                    showSnackBar(
                                        'Muokkaus epäonnistui',
                                        const Icon(Icons.error,
                                            color: Colors.red));
                                  }
                                }
                              },
                              child: Tooltip(
                                message: 'Tallenna',
                                child: Container(
                                  color: theme.colorScheme.tertiary,
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.save,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velpa/models/map_marker_model.dart';
import 'package:velpa/providers/map_markers_provider.dart';
import 'package:velpa/providers/user_provider.dart';
import 'package:velpa/screens/mobile/widgets/edit_marker_bottom_sheet.dart';
import 'package:velpa/screens/mobile/widgets/marker_delete_confirm_dialog.dart';
import 'package:velpa/screens/mobile/widgets/marker_verify_dialog.dart';

class MarkerDetailsBottomSheet extends ConsumerWidget {
  final String id;

  const MarkerDetailsBottomSheet({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    final markerProvider = ref.watch(mapMarkersProvider);
    final marker = markerProvider.getMarkerById(id);
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    if (marker == null) {
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> detailItems = [
      {
        "leading": "Vesistö: ",
        "icon": const Icon(
          Icons.water,
          color: Colors.blue,
        ),
        "value": marker.water,
      },
      {
        "leading": "Kuvaus: ",
        "icon": const Icon(
          Icons.description,
          color: Colors.grey,
        ),
        "value": marker.description,
      },
      {
        "leading": "Sijainti: ",
        "icon": const Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        "value":
            '\nLat: ${marker.point.latitude.toString()}\nLon: ${marker.point.longitude.toString()}',
      },
      {
        "leading": "Luonut: ",
        "icon": const Icon(
          Icons.person,
          color: Colors.orange,
        ),
        "value": marker.createdBy,
      },
      {
        "leading": "Luotu: ",
        "icon": const Icon(
          Icons.calendar_today,
          color: Colors.red,
        ),
        "value": dateFormat.format(marker.createdAt),
      },
      {
        "leading": "Päivitetty: ",
        "icon": const Icon(
          Icons.update,
          color: Colors.red,
        ),
        "value": dateFormat.format(marker.updatedAt),
      }
    ];

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: BottomSheet(
            enableDrag: false,
            backgroundColor: theme.colorScheme.primary,
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: width * 0.9,
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              marker.title,
                              style: theme.textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: detailItems.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: detailItems[index]['icon'],
                                  title: Text.rich(
                                    TextSpan(
                                      text: detailItems[index]['leading'],
                                      style: theme.textTheme.labelMedium,
                                      children: [
                                        TextSpan(
                                          text: detailItems[index]['value'],
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonRow(marker: marker),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends ConsumerWidget {
  final MapMarker marker;
  const ButtonRow({required this.marker, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final canDelete =
        (user?.roles.isAdmin ?? false) || (user?.roles.isModerator ?? false);
    final canVerify = canDelete; // Same permissions for now
    final canEdit = (user?.roles.isAdmin ?? false) ||
        (user?.roles.isModerator ?? false) ||
        (marker.createdBy == user?.email);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (canVerify && !marker.isVerified)
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VerifyMarkerDialog(markerId: marker.id);
                    });
              },
              child: Tooltip(
                message: 'Vahvista',
                child: Container(
                  color: theme.colorScheme.tertiary,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (canEdit)
          Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(mapMarkersProvider).updateTempMarker(marker, ref);
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return EditMarkerBottomSheet();
                  },
                ).whenComplete(() {
                  ref.read(mapMarkersProvider).removeTempMarker(ref);
                });
              },
              child: Tooltip(
                message: 'Muokkaa',
                child: Container(
                  color: theme.colorScheme.tertiary,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.edit,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (canDelete)
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteMarkerConfirmDialog(markerId: marker.id);
                    });
              },
              child: Tooltip(
                message: 'Poista',
                child: Container(
                  color: theme.colorScheme.tertiary,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
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
    );
  }
}

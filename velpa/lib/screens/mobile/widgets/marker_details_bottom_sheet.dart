import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:velpa/models/models.dart';
import 'package:velpa/screens/mobile/widgets/marker_delete_confirm_dialog.dart';
import 'package:velpa/services/admin_service.dart';
import 'package:velpa/services/auth.dart';

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
    final adminService = AdminService();

    if (marker == null) {
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> detailItems = [
      {
        "leading": "Water: ",
        "icon": const Icon(
          Icons.water,
          color: Colors.blue,
        ),
        "value": marker.water,
      },
      {
        "leading": "Description: ",
        "icon": const Icon(
          Icons.description,
          color: Colors.grey,
        ),
        "value": marker.description,
      },
      {
        "leading": "Location: ",
        "icon": const Icon(
          Icons.location_on,
          color: Colors.green,
        ),
        "value":
            '\nLat: ${marker.point.latitude.toString()}\nLon: ${marker.point.longitude.toString()}',
      },
      {
        "leading": "Created by: ",
        "icon": const Icon(
          Icons.person,
          color: Colors.orange,
        ),
        "value": marker.createdBy,
      },
      {
        "leading": "Created on: ",
        "icon": const Icon(
          Icons.calendar_today,
          color: Colors.red,
        ),
        "value": dateFormat.format(marker.createdAt),
      },
      {
        "leading": "Last update: ",
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
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
                    ButtonRow(id: id),
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

class ButtonRow extends StatelessWidget {
  final String id;
  const ButtonRow({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();

    return FutureBuilder(
      future: adminService.checkUserPermissions('delete_marker'),
      builder: (context, snapshot) {
        final bool canDelete = snapshot.data ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (canDelete)
              ElevatedButton(
                onPressed: () {
                  final nav = Navigator.of(context);
                  nav.push(MaterialPageRoute(
                      builder: (context) =>
                          DeleteMarkerConfirmDialog(markerId: id)));
                },
                child: const Text('Delete marker'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

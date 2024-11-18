import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velpa/models/models.dart';

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
    MapMarker updatedTempMarker = ref.read(mapMarkersProvider).tempMarker!;

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
            onChanged: (String text) => {
              if (icon == Icons.title)
                {
                  updatedTempMarker = ref
                      .read(mapMarkersProvider)
                      .tempMarker!
                      .copyWith(title: text)
                }
              else if (icon == Icons.water)
                {
                  updatedTempMarker = ref
                      .read(mapMarkersProvider)
                      .tempMarker!
                      .copyWith(water: text)
                }
              else if (icon == Icons.description)
                {
                  updatedTempMarker = ref
                      .read(mapMarkersProvider)
                      .tempMarker!
                      .copyWith(description: text)
                },
              ref
                  .read(mapMarkersProvider)
                  .updateTempMarker(updatedTempMarker, ref),
            },
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

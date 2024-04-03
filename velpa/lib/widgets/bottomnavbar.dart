import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velpa/models/local_models.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.bottomnavbarindex,
  });

  final BottomNavBarIndex bottomnavbarindex;

  @override
  Widget build(BuildContext context) {
    var appflags = Provider.of<AppFlags>(context, listen: true);
    // Default navbar for navigating to different screens
    if (!appflags.markerSelected) {
      return BottomNavigationBar(
        currentIndex: bottomnavbarindex.idx,
        onTap: bottomnavbarindex.changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Markers',
          ),
          // Lisää tähän lisää kohteita tarvittaessa
        ],
      );
    } else {
      // Navbar when marker is selected
      return Container(
        height: 42,
        margin: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: null,
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: null,
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      );
    }
  }
}

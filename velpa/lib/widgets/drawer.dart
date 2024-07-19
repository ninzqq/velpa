import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItem = [
      {
        "title": const Text("Kartta"),
        "icon": const Icon(Icons.map),
        "function": () => {
              Navigator.pop(context),
              Navigator.popUntil(context, (route) => route.isFirst),
            },
        "selected": false,
      },
      {
        "title": const Text('Profiili'),
        'icon': const Icon(Icons.label_outlined),
        'function': () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, '/profile'),
            },
        'selected': false,
      },
      {
        "title": const Text("Asetukset"),
        "icon": const Icon(Icons.settings),
        "function": () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, "/settings"),
            },
        "selected": false,
      }
    ];

    return Drawer(
      backgroundColor: ThemeData().primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Mulla harrastus on...',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: menuItem.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14),
                    child: ListTile(
                      leading: menuItem[index]['icon'],
                      title: menuItem[index]['title'],
                      onTap: () => {
                        menuItem[index]['function'](),
                      },
                      selected: menuItem[index]['selected'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

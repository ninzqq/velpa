import 'package:flutter/material.dart';
import 'package:velpa/services/auth.dart';
import 'package:velpa/utils/intro_dialog.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final user = AuthService().user;
    final List<Map<String, dynamic>> menuItem = [
      {
        "title": Text("Kartta", style: theme.textTheme.bodyMedium),
        "icon": const Icon(
          Icons.map,
          color: Colors.green,
        ),
        "function": () => {
              Navigator.pop(context),
              Navigator.popUntil(context, (route) => route.isFirst),
            },
        "selected": false,
      },
      {
        "title": Text('Karttamerkit', style: theme.textTheme.bodyMedium),
        'icon': const Icon(
          Icons.location_on,
          color: Colors.lightBlue,
        ),
        'function': () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, '/markers'),
            },
        'selected': false,
      },
      {
        "title": Text('Profiili', style: theme.textTheme.bodyMedium),
        'icon': const Icon(
          Icons.label_outlined,
          color: Colors.deepPurple,
        ),
        'function': () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, '/profile'),
            },
        'selected': false,
      },
      {
        "title": Text("Asetukset", style: theme.textTheme.bodyMedium),
        "icon": const Icon(Icons.settings, color: Colors.blueGrey),
        "function": () => {
              Navigator.pop(context),
              Navigator.pushNamed(context, "/settings"),
            },
        "selected": false,
      },
      {
        "title": Text("Ohjeet", style: theme.textTheme.bodyMedium),
        "icon": const Icon(Icons.help, color: Colors.yellow),
        "function": () => {
              Navigator.pop(context),
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const IntroDialog();
                  }),
            },
        "selected": false,
      }
    ];

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Mulla harrastus on...',
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ),
            if (user == null)
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.purple),
                  title: Text('Kirjaudu', style: theme.textTheme.labelLarge),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.pushNamed(context, '/profile'),
                  },
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

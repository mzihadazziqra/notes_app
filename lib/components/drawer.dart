import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/components/drawer_tile.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Lottie.asset(
                'assets/lottie/note1.json',
                repeat: false,
                height: 20,
              ),
            ),
          ),

          // Dark Mode tile
          DrawerTile(
            title: isDarkMode ? 'Light Mode' : 'Dark Mode',

            leading: IconButton(
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
              icon: isDarkMode ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
            ),
          ),
          Text(
            isDarkMode ? 'Catpucchin Mocha active' : 'Catpuccin Latte active',
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntocell_flutter/providers/home_provider.dart';
import 'package:puntocell_flutter/util/global_keys.dart';
import 'package:puntocell_flutter/widgets/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    HomeProvider watch = context.watch<HomeProvider>();
    return LayoutBuilder(builder: (context, constraint) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        return Scaffold(
          body: Row(
            children: [
              DrawerWidget(
                context: context,
              ),
              Expanded(
                child: watch.body!,
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          key: scaffoldKey,
          body: watch.body!,
          drawer: Drawer(child: DrawerWidget(context: context),),
        );
      }
    });
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 136, 127, 127),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logopuntocell.png",
            height: kToolbarHeight / 1.2,
          ),
          Image.asset(
            "assets/letraslogo.png",
            height: kToolbarHeight / 1.5,
            width: 200,
          ),
        ],
      ),
    );
  }
}

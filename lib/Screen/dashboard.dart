import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Screen/home_screen.dart';
import '../../Screen/profile_screen.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/shared_preference.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  _getSharedPreference() async {
    SharedPreference pref = SharedPreference();
    await pref.getUserData();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _getSharedPreference();
    var isOpened = ref.watch(dashboardProvider);
    return Scaffold(
      // bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(CupertinoIcons.home,
                    size: 30,
                    color: isOpened == 0 ? Colors.white : Colors.white54),
                onPressed: () {
                  onChangeDashboardProvider(ref, 0);
                },
              ),
              IconButton(
                icon: Icon(Icons.category,
                    size: 30,
                    color: isOpened == 1 ? Colors.white : Colors.white54),
                onPressed: () {
                  onChangeDashboardProvider(ref, 1);
                },
              ),
              IconButton(
                icon: Icon(CupertinoIcons.person,
                    size: 30,
                    color: isOpened == 2 ? Colors.white : Colors.white54),
                onPressed: () {
                  onChangeDashboardProvider(ref, 2);
                },
              )
            ],
          ),
        ),
      ),
      body: getPage(isOpened),
    );
  }
}

Widget getPage(int isOpened) {
  switch (isOpened) {
    case 0:
      return HomeScreen();
    case 1:
      return Placeholder();
    case 2:
      return ProfileScreen();
    default:
      return HomeScreen();
  }
}

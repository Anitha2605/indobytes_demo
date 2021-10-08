import 'package:flutter/material.dart';
import 'package:indobytes_spacexfan/upcomingLaunches.dart';
import 'package:provider/provider.dart';

import 'allSpaceXrockets.dart';
import 'favRocketOperation.dart';
import 'favoriteRockets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavOp(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'SpaceX Fan';
  int _tabIndex = 0;
  List<Widget> listScreens = [
    AllRockets(),
    FavoriteRockets(),
    UpcomingLaunches()
  ];
  int _count = 0;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(index: _tabIndex, children: listScreens),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: Colors.blue,
                ),
                label: "all SpaceX rockets",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.green,
                ),
                label: "favorite rockets",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.launch,
                  color: Colors.red,
                ),
                label: "upcoming launches",
              ),
            ]));
  }
}

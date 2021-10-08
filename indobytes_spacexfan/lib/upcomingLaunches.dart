import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:indobytes_spacexfan/upcomingDetail.dart';

class UpcomingLaunches extends StatefulWidget {
  UpcomingLaunchesState createState() => UpcomingLaunchesState();
}

class UpcomingLaunchesState extends State<UpcomingLaunches> {
  Future<List<UpcomingLaunch>> _getData() async {
    List<UpcomingLaunch> upcomingLaunchList = [];
    var url = Uri.https(
        'api.spacexdata.com', '/v5/launches/upcoming', {'q': '{http}'});

    //https://api.spacexdata.com/v5/launches/upcoming
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var eachUpcomingLaunch in jsonResponse) {
        UpcomingLaunch upcomingLauncObj = UpcomingLaunch(
            id: eachUpcomingLaunch['id'],
            name: eachUpcomingLaunch['name'],
            launchDate: eachUpcomingLaunch['date_local']);

        upcomingLaunchList.add(upcomingLauncObj);
      }

      return upcomingLaunchList;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return upcomingLaunchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Upcoming Launches"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<UpcomingLaunch>>(
            future: _getData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UpcomingLaunch>> snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading...")));
              } else {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(height: 1, color: Colors.black);
                  },
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpcomingDetail(
                                      id: snapshot.data![index].id ?? '0',
                                    )));
                      },
                      child: ListTile(
                        title: Text(snapshot.data![index].name ?? ""),
                        subtitle: Text(snapshot.data![index].launchDate ?? ""),
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

class UpcomingLaunch {
  final String? id;
  // final String? launchId;
  final String? name;
  final String? launchDate;

  UpcomingLaunch({this.id, this.name, this.launchDate});
}

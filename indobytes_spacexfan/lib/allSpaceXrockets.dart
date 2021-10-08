import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:indobytes_spacexfan/favRocketOperation.dart';
import 'package:indobytes_spacexfan/rocketDetailPage.dart';
import 'package:provider/provider.dart';

class AllRockets extends StatefulWidget {
  AllRocketsState createState() => AllRocketsState();
}

class AllRocketsState extends State<AllRockets> {
  Future<List<Rocket>> _getData() async {
    List<Rocket> rocketsList = [];
    var url = Uri.https('api.spacexdata.com', '/v4/rockets', {'q': '{http}'});

    //https://api.spacexdata.com/v4/rockets
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      for (var eachRocketJson in jsonResponse) {
        Rocket rocketObj = Rocket(
            id: eachRocketJson['id'],
            name: eachRocketJson['name'],
            country: eachRocketJson['country'],
            rocketImage: eachRocketJson['flickr_images'][0]);

        rocketsList.add(rocketObj);
      }
      print(rocketsList.length);

      return rocketsList;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return rocketsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("All Rockets"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder<List<Rocket>>(
            future: _getData(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Rocket>> snapshot) {
              if (snapshot.data == null) {
                return Container(child: Center(child: Text("Loading...")));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(20),
                      child: Material(
                        elevation: 10,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)) //Border.all
                                ),
                            child:
                                Consumer<FavOp>(builder: (context, val, child) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RocketDetail(
                                                rocketId:
                                                    snapshot.data![index].id ??
                                                        '0',
                                              )));
                                },
                                child: Container(
                                  height: 150,
                                  child: ListTile(
                                    title:
                                        Text(snapshot.data![index].name ?? ""),
                                    subtitle: Text(
                                        snapshot.data![index].country ?? ""),
                                    trailing: IconButton(
                                        onPressed: () {
                                          if (Provider.of<FavOp>(context,
                                                  listen: false)
                                              .favItemsIndexes
                                              .contains(index)) {
                                            Provider.of<FavOp>(context,
                                                    listen: false)
                                                .removeFromFavList(
                                                    snapshot.data![index]);
                                            Provider.of<FavOp>(context,
                                                    listen: false)
                                                .favItemsIndexes
                                                .remove(index);
                                          } else {
                                            Provider.of<FavOp>(context,
                                                    listen: false)
                                                .insertToFavList(
                                                    snapshot.data![index]);
                                            Provider.of<FavOp>(context,
                                                    listen: false)
                                                .favItemsIndexes
                                                .add(index);
                                          }
                                        },
                                        icon: Provider.of<FavOp>(context,
                                                    listen: false)
                                                .favItemsIndexes
                                                .contains(index)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_border_outlined,
                                              )),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: new DecorationImage(
                                      image: NetworkImage(
                                          snapshot.data![index].rocketImage ??
                                              ""),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            })),
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

class Rocket {
  final String? id;
  final String? name;
  final String? country;
  final String? rocketImage;

  Rocket({this.id, this.name, this.country, this.rocketImage});
}

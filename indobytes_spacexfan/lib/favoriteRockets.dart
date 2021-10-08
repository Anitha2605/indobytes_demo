import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:indobytes_spacexfan/favRocketOperation.dart';
import 'package:provider/provider.dart';

class FavoriteRockets extends StatefulWidget {
  FavoriteRocketsState createState() => FavoriteRocketsState();
}

class FavoriteRocketsState extends State<FavoriteRockets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite List"),
        centerTitle: true,
      ),
      body: Consumer<FavOp>(builder: (context, val, child) {
        return ListView.builder(
          itemCount: val.listOfRockets.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Material(
                elevation: 10,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0)) //Border.all
                        ),
                    child: Container(
                      height: 150,
                      child: ListTile(
                        title: Text(val.listOfRockets[index].name ?? ""),
                        subtitle: Text(val.listOfRockets[index].country ?? ""),
                        trailing: IconButton(
                            onPressed: () {
                              Provider.of<FavOp>(context, listen: false)
                                  .removeFromFavList(val.listOfRockets[index]);
                              Provider.of<FavOp>(context, listen: false)
                                  .favItemsIndexes
                                  .remove(index);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: new DecorationImage(
                          image: NetworkImage(
                              val.listOfRockets[index].rocketImage ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
              ),
            );
          },
        );
      }),
    );
  }
}

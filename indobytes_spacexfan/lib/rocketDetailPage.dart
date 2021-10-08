import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RocketDetail extends StatefulWidget {
  final String? rocketId;
  const RocketDetail({Key? key, this.rocketId}) : super(key: key);

  @override
  _RocketDetailState createState() => _RocketDetailState();
}

class _RocketDetailState extends State<RocketDetail> {
  SwiperController _controller = SwiperController();

  Future<Rocket?> _getData() async {
    var url = Uri.https('api.spacexdata.com', '/v4/rockets/${widget.rocketId}',
        {'q': '{http}'});

    // https://api.spacexdata.com/v4/rockets/:id
    //  id : "5e9d0d96eda699382d09d1ee"

    Rocket? rocketObj;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      List<String> imgsList = [];

      for (var eachImageUrl in jsonResponse['flickr_images']) {
        imgsList.add(eachImageUrl);
      }

      rocketObj = Rocket(
          name: jsonResponse['name'],
          type: jsonResponse['type'],
          country: jsonResponse['country'],
          company: jsonResponse['company'],
          rocketImages: imgsList);

      return rocketObj;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return rocketObj;
    }
  }

  @override
  void initState() {
    _controller.autoplay = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Rocket_Detail"),
        ),
        body: Container(
            child: FutureBuilder<Rocket?>(
                future: _getData(),
                builder:
                    (BuildContext context, AsyncSnapshot<Rocket?> snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Container(
                          height: 200,
                          child: new Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  snapshot.data?.rocketImages![index] ?? "",
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                            itemCount: snapshot.data?.rocketImages?.length ?? 0,
                            pagination: SwiperPagination(),
                            controller: _controller,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                            title: Text(snapshot.data!.name ?? ""),
                            subtitle: Text(
                                'RoketType: ${snapshot.data!.type ?? ""} \n Country: ${snapshot.data!.country ?? ""} \n Company: ${snapshot.data!.company ?? " "}'))
                      ]),
                    );
                  }
                })));
  }
}

class Rocket {
  final String? name;
  final String? type;
  final String? country;
  final String? company;
  final List<String>? rocketImages;
  Rocket({this.name, this.type, this.country, this.company, this.rocketImages});
}

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UpcomingDetail extends StatefulWidget {
  final String? id;
  const UpcomingDetail({Key? key, this.id}) : super(key: key);

  @override
  _UpcomingDetailState createState() => _UpcomingDetailState();
}

class _UpcomingDetailState extends State<UpcomingDetail> {
  Future<Rocket?> _getData() async {
    var url = Uri.https(
        'api.spacexdata.com', '/v5/launches/${widget.id}', {'q': '{http}'});
//https://api.spacexdata.com/v5/launches/:id
//id:608d3d23ffcee803616cbde2
    // https://api.spacexdata.com/v4/rockets/:id
    //  id : "5e9d0d96eda699382d09d1ee"

    Rocket? rocketObj;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      rocketObj = Rocket(
          flight_number: jsonResponse['flight_number'],
          name: jsonResponse['name'],
          date_local: jsonResponse['date_local']);
      return rocketObj;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return rocketObj;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text("Upcoming_Detail"),
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
                        child: Center(
                            child: Text(
                                'Flight_number: ${snapshot.data!.flight_number ?? ""} \n Name: ${snapshot.data!.name ?? ""} \n Date_local: ${snapshot.data!.date_local ?? " "}')));
                  }
                })));
  }
}

class Rocket {
  final int? flight_number;
  final String? name;
  final String? date_local;
  Rocket({this.flight_number, this.name, this.date_local});
}

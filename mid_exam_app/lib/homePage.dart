import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mid_exam_app/launch_model.dart';
import 'package:readmore/readmore.dart';
import 'dart:math' as math;

class homePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

bool isReadMore = false;

class _homePageState extends State<homePage> {
  String text = "sameer is nice boy and he like playing footvballl";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 40, 141, 100),
          title: const Text(
            "Space Missions",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          )),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List products = snapshot.data!;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Launch item = products[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.green,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                // height: 50,
                                child: Text(
                                  "${item.missionName}",
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "${item.description}",
                                textAlign: TextAlign.center,
                                maxLines: isReadMore ? 10 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 250,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isReadMore = !isReadMore;
                                      });
                                    },
                                    child: Text(
                                        isReadMore ? "Read less" : "Read more"),
                                  ),
                                ],
                              ),

                              Wrap(children: [
                                for (String i in item.payloadIds!)
                                  Chip(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    avatar: CircleAvatar(
                                      backgroundColor: Colors.grey.shade800,
                                      child: null,
                                    ),
                                    label: Text(i),
                                    backgroundColor: Color.fromARGB(
                                      math.Random().nextInt(255),
                                      math.Random().nextInt(255),
                                      math.Random().nextInt(255),
                                      math.Random().nextInt(255),
                                    ),
                                  ),
                              ]),
                              // Chip(
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(20))),
                              //   avatar: CircleAvatar(
                              //     backgroundColor: Colors.grey.shade800,
                              //     child: null,
                              //   ),
                              //   label: Text("${item.payloadIds![1]}"),
                              // ),
                              // Chip(
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(20))),
                              //   avatar: CircleAvatar(
                              //     backgroundColor: Colors.grey.shade800,
                              //     child: null,
                              //   ),
                              //   label: Text("${item.payloadIds![1]}"),
                              // ),
                              // grid.builder(
                              //     itemCount: item.payloadIds!.length,
                              //     itemBuilder: (context, index) {
                              //       return Container(
                              //         child: Text("hello"),
                              //       );
                              //     })
                              // GridView.builder(
                              //     gridDelegate:
                              //         const SliverGridDelegateWithMaxCrossAxisExtent(
                              //             maxCrossAxisExtent: 200,
                              //             childAspectRatio: 3 / 2,
                              //             crossAxisSpacing: 20,
                              //             mainAxisSpacing: 20),
                              //     itemCount: item.payloadIds!.length,
                              //     itemBuilder: (BuildContext ctx, index) {
                              //       return Container(
                              //         alignment: Alignment.center,
                              //         decoration: BoxDecoration(
                              //             color: Colors.amber,
                              //             borderRadius:
                              //                 BorderRadius.circular(15)),
                              //         child: Text("hello"),
                              //       );
                              //     }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("no data availables");
            }
          }
        },
      ),
    );
  }

  Future<List<Launch>> getData() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v3/missions'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body.toString()) as List;
      List<Launch> products =
          jsonResponse.map((e) => Launch.fromJson(e)).toList();

      return products;
    } else {
      throw Exception("Failed to get data");
    }
  }
}

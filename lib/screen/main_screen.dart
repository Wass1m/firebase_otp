import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_otp/helper/helper.dart';
import 'package:firebase_otp/model/get_config_list.dart';

// import 'package:firebase_otp/screen/config_screen.dart';
// import 'package:firebase_otp/screen/drawer_screen.dart';
// import 'package:firebase_otp/screen/edit_button.dart';
import 'package:firebase_otp/screen/loader_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../helper/helper.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = true;
  List<bool> flagTap = [];
  GlobalKey<NavigatorState> _key = GlobalKey();

  getData() async {
    flagTap.clear();
    mainConfigList.clear();
    final prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        final jsonResponse = json.decode(prefs.getString('savedConfigData'));
        mainConfigList = jsonResponse
            .map<GetConfigList>((json) => GetConfigList.fromJson(json))
            .toList();
      });
    } catch (error) {}
    for (int i = 0; i < mainConfigList.length; i++) {
      flagTap.add(false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void alert(String alert) {
    // es el mensaje que aparece y se va
    Fluttertoast.showToast(
      msg: alert,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(mainConfigList.length);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          title: Text(
            "Lorem Ipsum",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                color: Colors.white,
                iconSize: 30,
                onPressed: () => {
                      setState(() {
                        pageNumber = 0;
                      }),
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ConfigScreen()),
                      // )
                    }),
          ],
        ),
        // drawer: Drawer(
        //   // child: DrawerScreen(),
        //   child: DrawerScreen(),
        // ),
        body: _isLoading
            ? LoaderScreen()
            : Container(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      mainConfigList.length == 0
                          ?
                          // Container(
                          //         padding: EdgeInsets.only(top: height * 0.4),
                          //         child: Text(
                          //           'There is no the selected data.',
                          //           style: TextStyle(fontSize: 20.0),
                          //         ),
                          //       )

                          // THIS CONTAINER IS THE DESIGNED SLIDER LIST
                          Container(
                              height: height,
                              child: ListView.builder(
                                itemCount: 4,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 6,
                                            )
                                          ]),
                                      height: 70,
                                      child: Row(
                                        children: [
                                          ConfirmationSlider(
                                            onConfirmation: () {},
                                            backgroundColor: Colors.green,
                                            text: 'G1',
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                            shadow:
                                                BoxShadow(color: Colors.green),
                                            foregroundShape:
                                                BorderRadius.circular(0),
                                            foregroundColor: Colors.white,
                                            iconColor: Colors.red,
                                            backgroundShape: BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                bottomLeft: Radius.circular(7)),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.business,
                                                size: 35,
                                                color: Colors.white,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(10),
                              width: width * 0.95,
                              height: height * 0.86,
                              child: ListView.builder(
                                  itemCount: mainConfigList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Card(
                                        color: Colors
                                            .white70, // color del fondo del boton
                                        elevation: 10, // sombra del boton
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              width: width * 0.26,
                                              height: width * 0.26,
                                              color: demoColors[
                                                  mainConfigList[index].color],
                                              child: mainConfigList[index]
                                                          .icon !=
                                                      null
                                                  ? Icon(
                                                      IconData(
                                                        int.parse(
                                                            mainConfigList[
                                                                    index]
                                                                .icon),
                                                        fontFamily: fontFamily,
                                                        fontPackage:
                                                            fontPackage,
                                                        matchTextDirection:
                                                            matchTextDirection,
                                                      ),
                                                      size: 60,
                                                      color: Colors
                                                          .white, // color del icono
                                                    )
                                                  : Container(),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: width * 0.35,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 10, 0, 0),
                                                    child: Text(
                                                      mainConfigList[index]
                                                          .name, // nombre del boton
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: width * 0.35,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 10, 0, 0),
                                                    child: Text(
                                                      mainConfigList[index]
                                                          .idf2, // referencia del boton
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // texto del boton se puede copiar para poner mas lineas
                                                  width: width * 0.35,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 10, 0, 0),
                                                    child: Text(
                                                      mainConfigList[index]
                                                          .idf2, // referencia del boton
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                flagTap[index]
                                                    ? Text(
                                                        "Response : OK!",
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.045,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        //
                                        var headers = {
                                          'Content-Type': 'application/json',
                                          'Accept': 'application/json',
                                        };
                                        var body = jsonEncode(<String, String>{
                                          // estos son los datos que envio en la peticion de abrir
                                          //'idk': index.toString(),
                                          'idk': mainConfigList[index]
                                              .idk
                                              .toString(),
                                          'idd':
                                              '6666', // cambiar por el id del dispositivo
                                        });
                                        final response = await http.post(
                                            Uri.encodeFull(
                                                baseUrl + 'clla.php'),
                                            headers: headers,
                                            body: body);
                                        if (response.statusCode == 200) {
                                          alert(
                                              "Peticion enviada!!!"); // mensaje de alerta
                                        } else {
                                          print('walou');
                                        }
                                        //if (response.statusCode == 200) { // cambiar para verificar que la respuesta es un true
                                        //  final jsonResponse = json.decode(response.body);

                                        //  resultModel = jsonResponse.map<ResultModel>((json) => ResultModel.fromJson(json)).toList();
                                        //  if(resultModel[0].result == true) {
                                        //    setState(() {
                                        //      alert("${widget.item.name} has been updated successfully!");
                                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigScreen()),);
                                        //    });
                                        //  } else {
                                        //    _editErrorDialog(context);
                                        //  }
                                        //} else {
                                        //  throw Exception('Failed to edit button.');
                                        //}
                                        //

                                        //final response = await http.get(Uri.encodeFull(baseUrl+'clla.php'),
                                        //  headers: {
                                        //  'Content-Type': 'application/json',
                                        // 'Accept': 'application/json',
                                        //});
                                        //if(response.statusCode == 200) {
                                        //alert("OK!!!"); // mensaje de alerta
                                        ////print(response.body);
                                        //setState(() {
                                        //flagTap[index] = true;
                                        //});
                                        //}
                                      },
                                    );
                                  }),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

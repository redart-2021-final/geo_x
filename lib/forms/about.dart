import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/data/static_variable.dart';
import 'package:package_info/package_info.dart';

//Класс инициализации
class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => new AboutPageState();
}

class AboutPageState extends State<AboutPage> {

  String app_name='';
  String version='';
  String build_number='';
  String developer='';
  String email='';

  @override
  void initState() {
    super.initState();
    _PackageInfo();
    app_name = AppName;
    developer = Developer;
    email = DeveloperEmail;
  }

  _PackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
      build_number = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("О ПРИЛОЖЕНИИ"),
        ),
        body: new ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          new Card(
            child: Column(
              children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("ИНФОРМАЦИЯ О ПРИЛОЖЕНИИ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      child: Text('Имя приложения',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 0, right: 15, left: 15),
                      child: Text(app_name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      child: Text('Версия приложения',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 0, right: 15, left: 15),
                      child: Text(version,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      child: Text('Версия сборки',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 0, right: 15, left: 15),
                      child: Text(build_number,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left),
                    )),
              ],
            ),
          ),
          new Card(
              child: Column(children: <Widget>[
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text("ИНФОРМАЦИЯ О РАЗРАБОТЧИКАХ",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      child: Text('Разработчик',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 0, right: 15, left: 15),
                      child: Text(developer,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 0, top: 10, right: 15, left: 15),
                      child: Text('Почта',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left),
                    )),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 10, top: 0, right: 15, left: 15),
                      child: Text(email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.left),
                    )),
              ])),
        ]));
  }
}

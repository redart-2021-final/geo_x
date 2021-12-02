import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/data/session_options.dart';

//Класс инициализации
class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() => new AccountPageState();
}

class AccountPageState extends State<AccountPage> {

  @override
  void initState() {
    super.initState();
    print(UserPhone);
    print(UserFullName);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("УЧЕТНАЯ ЗАПИСЬ"),
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
                                  child: Text("ИНФОРМАЦИЯ",
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
                                  child: Text('ФИО',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left),
                                )),
                            new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 0, right: 15, left: 15),
                                  child: Text(UserFullName,
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
                                  child: Text('Телефон',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left),
                                )),
                            new Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 10, top: 0, right: 15, left: 15),
                                  child: Text(UserPhone,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.left),
                                )),

                          ],
                        ),
                      ),
                    ])
        );
  }
}

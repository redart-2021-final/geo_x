import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/forms/account.dart';
import 'package:geo_x/forms/home.dart';
import 'forms/login.dart';


//общие классы
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}



//Общие процедуры и функции
//Всплывающие окна

CreateshowDialog(context, content) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
      return new CupertinoAlertDialog(
        content: content,
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text("OK"))
        ],
      );});
} //Сообщение

LoadingStart(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: null,
          child: new CupertinoAlertDialog(
            content: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Container(
                  child: new Text(
                    "Загрузка...",
                    textAlign: TextAlign.center,
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                ),
              ],
            ),
          ));
    },
  );
} //Загркзеп

LoadingStop(context) {
  Navigator.pop(context); //pop dialog
} //Конец загрузки


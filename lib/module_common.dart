import 'package:geo_x/data/session_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geo_x/forms/about.dart';
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

//Мастер формы
CreateDefaultMasterForm(int index_form, Widget body, context, callback) {
  return Scaffold(
    appBar: AppBar(
      title: Text(index_form == 0
          ? 'ДОМА'
          : 'НЕОПРЕДЕЛЕНО'),
    ),
    drawer: new Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                new DrawerHeader(
                  child: new Image.asset(
                    "assets/images/logo.png",
                    height: 100.0,
                  ),
                ),
                new ListTile(
                  selected: index_form == 0,
                  leading: new Icon(Icons.home),
                  title: new Text('ДОМА'),
                  onTap: () {
                    if (index_form != 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                          new NoAnimationMaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new HomePage()),
                          (Route<dynamic> route) => false);
                    }
                  },
                ),
                new Divider(),
                new ListTile(
                  leading: new Icon(Icons.account_circle),
                  title: new Text('УЧЕТНАЯ ЗАПИСЬ'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccountPage()));
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.live_help),
                  title: new Text('ПОМОЩЬ'),
                  onTap: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SDPage()));
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.info),
                  title: new Text('О ПРОГРАММЕ'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutPage()));
                  },
                ),
              ],
            ),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      new ListTile(
                        leading: new Icon(Icons.exit_to_app),
                        title: new Text('ВЫХОД'),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new LoginPage()),
                              (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  ))))
        ],
      ),
    ),
    body: body,
    floatingActionButton: index_form == 1
        ? FloatingActionButton(
            tooltip: 'Increment',
            child: Icon(Icons.add),
            onPressed: () {
              if (index_form == 1) {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => ManualInputPage(callback)));
              } else if (index_form == 2) {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) =>
//                            ManualInputWaybillsStep1(callback)));
              }
            },
          )
        : Container(),
  );
}

CreateListForm(data, GlobalKey<RefreshIndicatorState> _refreshIndicatorKey, BuildContext context, ScrollController _scrollController, bool list_lock, CustomListViewTile, refreshListFunction) {
  if (data == null) {
    return new Center(child: new CircularProgressIndicator());
  } else if (data.length == 0) {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshListFunction,
        child: new ListView(
            children: <Widget>[
              new Container(
                child: Text('Список пуст'),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                alignment: FractionalOffset.center,
              )
            ]
        )
    );
  } else {
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshListFunction,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: data.length+1,
            itemBuilder: (context, int currentIndex) {
              if (currentIndex == data.length) {
                return _buildProgressIndicator(list_lock);
              } else {
                return new Column(children: <Widget>[
                  new Divider(
                    height: 10.0,
                  ),
                  CustomListViewTile(data[currentIndex])
                ]);
              }
            }
        ));
  }
}
Widget _buildProgressIndicator(list_lock) {
  return new Padding(
    padding: const EdgeInsets.all(8.0),
    child: new Center(
      child: new Opacity(
        opacity: list_lock ? 1.0 : 00,
        child: new CircularProgressIndicator(),
      ),
    ),
  );
}
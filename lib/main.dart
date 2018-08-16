import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Internet Connectivity',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Internet Connectivity'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  Future getData() async{
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    if (response.statusCode == 200 ){
      var result = jsonDecode(response.body);
      return result;
    }
    }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new FutureBuilder(
          future: getData(),
        builder: (context,snapshot){
            if(snapshot.hasData){
              var mydata = snapshot.data;
              return new ListView.builder(
                itemBuilder: (context, i) => new ListTile(
                  title: Text(mydata[i]['title']),
                  // subtitle: Text(mydata[i]['body']),
                ),
                itemCount: mydata.length,
              );
            }
            else {
              return Center(
                child: new CircularProgressIndicator(),
              );
            }
        },

      ),

    );
  }
}

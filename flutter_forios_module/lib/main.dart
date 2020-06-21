import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pageIndex = 'one';
  final MethodChannel _oneChannel = MethodChannel('one_page');
  final MethodChannel _twoChannel = MethodChannel('two_page');
  final BasicMessageChannel _messageChannel = BasicMessageChannel('messageChannel',StandardMessageCodec());

  @override
  void initState() {
    super.initState();

    _messageChannel.setMessageHandler((message) {
      print('收到来自iOS的:${message}');
      return null;
    });

    _oneChannel.setMethodCallHandler((call) {
      print(call.arguments);
      setState(() {
        pageIndex = call.method;
      });
      return null;
    });

    _twoChannel.setMethodCallHandler((call) {
      print(call.arguments);
      setState(() {
        pageIndex = call.method;
      });
      return null;
    });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Module',
      theme: ThemeData(primaryColor: Colors.green),
      debugShowCheckedModeBanner: false,
      home: _rootPage(pageIndex),
    );
  }

  _rootPage(String pageIndex) {
    switch(pageIndex) {
      case 'one':
        return Scaffold(
          appBar: AppBar(title: Text('one'),),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  MethodChannel('one_page').invokeMapMethod('exit');
                },
                child: Text('返回'),
              ),
              SizedBox(height: 20,),
              Text('请输入，flutter 传递消息给 iOS Native'),
              TextField(
                onChanged: (String str){
                  _messageChannel.send(str);
                },
              ),
            ],
          ),
        );
      case 'two':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
            child: RaisedButton(
              onPressed: () {
                MethodChannel('two_page').invokeMapMethod('exit');
              },
              child: Text('返回'),
            ),
          ),
        );
    }
  }
}

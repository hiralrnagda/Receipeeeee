import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReceipeView extends StatefulWidget {

  final String postUrl;
  ReceipeView({this.postUrl});
  @override
  _ReceipeViewState createState() => _ReceipeViewState();
}

class _ReceipeViewState extends State<ReceipeView> {
  String finalUrl ;
  final Completer<WebViewController> _controller = new Completer<WebViewController>();

@override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }
    else{
      finalUrl = widget.postUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(    
        child: Column(
          children:[
            Container(
              padding: EdgeInsets.only(top :Platform.isIOS ? 60 : 30, right:24,left: 24,bottom: 16),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [
          const Color(0xff213A50),
          const Color(0xff071930),
        ],),),
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                  Text("Bakwaas",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
                  Text("Recipes",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.w500,),)],),
            ),
            Container(
              height: MediaQuery.of(context).size.height -100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            )
          ]
        ),
      ),
    );
  }
}
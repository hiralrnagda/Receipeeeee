import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:receipe_app/models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:receipe_app/views/receipe_view.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List <RecipeModel> recipes = new List<RecipeModel>();

  TextEditingController textEditingController = new TextEditingController();

  String applicationId = "287cd21a";
  String applicationKey = "c368b7b755439acc564c96b0a5264845";

  getRecipes(String query) async {
    String url = "https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey";
    var response = await http.get(url);
    
    setState(() {
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      jsonData["hits"].forEach((element){
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);
    });
    });

    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          const Color(0xff213A50),
          const Color(0xff071930),
        ],),),
        child: SingleChildScrollView(
                  child: Container(
            padding: EdgeInsets.symmetric(vertical:!kIsWeb ? Platform.isIOS ? 60 : 24 : 24,horizontal:30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
              SizedBox(height:20),
              Row(
                mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                SizedBox(height: 15,),
                Text("Bakwaas",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
                Text("Recipes",style: TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.w500,),)],),
              SizedBox(height: 30,),
              Text("What will you cook today?",style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: "Overpass"),),
              SizedBox(height:8),
              Text("Just enter ingredients you have and we will show you the best recipe for you",style: TextStyle(fontSize: 15,color: Colors.white,fontFamily: "Overpass"),),
              Container(
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,                  
                      style: TextStyle(fontSize: 18,color: Colors.white,),
                      decoration:InputDecoration(hintText: "Enter Ingredients",hintStyle: TextStyle(fontSize: 18,color: Colors.white.withOpacity(0.5),),enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),),
                    ),
                  ),
                  SizedBox(width:16),
                  InkWell(
                    onTap: (){
                      if(textEditingController.text.isNotEmpty){
                        getRecipes(textEditingController.text);
                        //textEditingController.clear();
                        //print("just do it");
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(colors: [
                         const Color(0xffA2834D),
                                    const Color(0xffBC9A5F)
                      ])),
                      child: Icon(Icons.search,color: Colors.white,size: 20,),),),
                ],),
              ),
              Container(
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(recipes.length, (index) {
                          return GridTile(
                              child: RecipieTile(
                            title: recipes[index].label,
                            imgUrl: recipes[index].image,
                            desc: recipes[index].source,
                            url: recipes[index].url,
                          ));
                        })),
                  ),
      ],),
          ),
        ),),
    );
  }
}

class RecipieTile extends StatefulWidget {

  final String title, desc, imgUrl, url;
  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceipeView(
                            postUrl: widget.url,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {this.topColor,
      this.bottomColor,
      this.topColorCode,
      this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
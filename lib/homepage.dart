import 'dart:convert';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = Uri.parse('https://yesno.wtf/api');
  var answer;
  late String image;
  GlobalKey <ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  TextEditingController _questionfeildController= TextEditingController();
  _handleGetAnswers()async{
    String questionText = _questionfeildController.text.trim();
    if(questionText == null || questionText.length ==0 || questionText[questionText.length - 1]!="?")
      {
        _globalKey.currentState!.showSnackBar(SnackBar(content: Text("Please ask a Valid question")));
     return;
      }
    try{
      http.Response response= await http.get( url);

   if(response.statusCode==200 && response.body != null){
  setState(() {
    answer= json.decode(response.body)[ "answer"];
    image= json.decode(response.body)[ "image"];

  });
   }
    }catch(err,StackTrace){
       print(err);
       print(StackTrace);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(child: Text("I Know Everything")),

      ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(

              width: 0.5*MediaQuery.of(context).size.width,
              child: TextField(
                controller: _questionfeildController,
                decoration: InputDecoration(
                  labelText: "Ask question",
                  border: OutlineInputBorder(

                  )
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (answer!=null) Stack(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  child: Image.network(image),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),

                  ),
                ),
                Positioned.fill(child: Align(
                  alignment: Alignment.center,
                  child: Text(answer,
                  style: TextStyle(color: Colors.white,
                  fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
                ))
              ],
            ) else Container(

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ignore: deprecated_member_use
                RaisedButton(onPressed:_handleGetAnswers,
                  child: Text("Get Answers",

                  style: TextStyle(
                    color: Colors.white,
                   // fontWeight: FontWeight.bold
                  ),),
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                
                ),
                SizedBox(
                  width: 20,
                ),
                // ignore: deprecated_member_use(
                RaisedButton(onPressed:(){

                } , child: Text("Reset",
                  style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold
                  ),),
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),)
                
              ],
            )

          ],
        )
    );
  }
}

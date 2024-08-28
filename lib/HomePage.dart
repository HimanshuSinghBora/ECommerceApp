import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DetailPage.dart';
Map? mapResponse;
List? listResponse;
class HomePage extends StatefulWidget{

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future getProductsApi () async {
    http.Response response;
    response = await http.get(Uri.parse('https://dummyjson.com/products'));
    // var
    if(response.statusCode==200){
      setState(() {
        mapResponse = json.decode(response.body);
        listResponse = mapResponse!["products"];
      });
    }
  }
  void initState(){
    getProductsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child:
            Column(
                children:[
                  Container(
                      alignment:Alignment.topLeft,
                      child: Text('Products',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 45),)),
                  Container(
                      alignment:Alignment.topLeft,
                      child: Text('Super summer sale',style: TextStyle(color: Colors.black26,fontSize: 15),)),
                  Container(
                    child: Expanded(
                      child: _buildListViewWidget(context),
                    ),
                  )
                ]
            ),
          ),
        )
    );
  }

  Widget _buildListViewWidget(BuildContext context){
    if (listResponse == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(
          ),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        return InkWell(onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(index:index)));},
          child: Container(
            child: Row(
              children: [
                Container(
                    child: Image.network(listResponse![index]['thumbnail'])),
                SizedBox(
                  width: 50,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: "+listResponse![index]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Prize: \$"+listResponse![index]["price"].toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                      Text("Description:"+listResponse![index]['description'].toString().substring(0,65)+"...........more"),
                    ],
                  ),
                )

              ],
            ),
          ),
        );
      },
      itemCount: listResponse==null? 0 :listResponse!.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 5,
        ) ;
      },
    );
  }

}
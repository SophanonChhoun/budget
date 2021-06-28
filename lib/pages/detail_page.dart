import 'package:flutter/cupertino.dart';
import '../models/article_model.dart';
import 'package:flutter/material.dart';
import 'add_transaction_page.dart';
import 'my_localapi_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final Article article;
  DetailPage({this.article});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  String _playlistUrl = "https://www.youtube.com/watch?v=bRhV1HN2Kp4&list=PLwsN38HPkFjdI6XPiIFSpn0Fh86LNydZn";

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
      bottomNavigationBar: _buildButtonNavigationBar,
    );
  }

  get _buildAppBar {
    return AppBar(
      title: Text("${widget.article.shopName}"),
      centerTitle: true,
      backgroundColor: Colors.blue[800],
    );
  }

  get _buildBody{
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Image(image: NetworkImage("${widget.article.img}"), fit: BoxFit.contain, height: 300,),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Discount: ${widget.article.discount} OFF", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), textAlign: TextAlign.left ,),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:Text('${widget.article.discription}'),
            ),
        ],
        ),

      ),
    );


  }

  get _buildButtonNavigationBar {
    return BottomAppBar(
      color: Colors.blue[800],
      child: SizedBox(
        height: 58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(CupertinoIcons.videocam_circle_fill),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  _launchURL();
                }),
            IconButton(
                icon: Icon(CupertinoIcons.plus_circle_fill),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AddTransactionPage()));
                }),
            IconButton(
                icon: Icon(CupertinoIcons.info_circle_fill),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyLocalAPIPage()));
                }),
            IconButton(
                icon: Icon(CupertinoIcons.settings),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  print("Account button clicked!");
                }),
          ],
        ),
      ),
    );
  }

  void _launchURL() async =>
      await canLaunch(_playlistUrl) ? await launch(_playlistUrl) : throw 'Could not launch $_playlistUrl';

}


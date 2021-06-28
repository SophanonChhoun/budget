import 'package:flutter/cupertino.dart';
import '../repos/my_localapi_repo.dart';
import '../models/article_model.dart';
import 'package:flutter/material.dart';
import 'add_transaction_page.dart';
import 'detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLocalAPIPage extends StatefulWidget {
  @override
  _MyLocalAPIPageState createState() => _MyLocalAPIPageState();

}

class _MyLocalAPIPageState extends State<MyLocalAPIPage> {
  Future _articleData;
  String _playlistUrl = "https://www.youtube.com/watch?v=bRhV1HN2Kp4&list=PLwsN38HPkFjdI6XPiIFSpn0Fh86LNydZn";


  List<Article> _articleList;

  @override
  void initState() {
    super.initState();
    _articleData = getData();

  }

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
      title: Text("Discount"),
      backgroundColor: Colors.blue[800],
    );
  }

  get _buildBody {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: _buildFutureReader,
    );
  }

  get _buildFutureReader {
    return FutureBuilder<ArticleData>(
        future: _articleData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Text("${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _articleList = snapshot.data.articles;
            return _buildListView;
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  get _buildListView {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _articleData = getData();
        });
      },
      child: ListView.builder(
          itemCount: _articleList.length,
          itemBuilder: (context, index) {
            return _buildItem(_articleList[index]);
          }),
    );
  }

  String _noImgs =
      "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png";

  _buildItem(Article article) {
    article.img = article.img == "" ? _noImgs : article.img;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        // color: Colors.white60,
        color: Colors.brown.shade200.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),

      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Container(
              color: Colors.white,
              margin: EdgeInsets.only(
                bottom: 10.0
              ),
              child: InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, 'detail_page');
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => DetailPage(article: article,),
                    ),
                  );
                },
                child: Image.network(
                  article.img,
                  fit: BoxFit.cover,
                  height: 350,
                ),
              )

            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${article.shopName}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      "${article.discount} Off",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),
                    ),
                  ],
                ),
              ),
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



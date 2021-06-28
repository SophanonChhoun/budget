import 'package:budget/pages/save_pin.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/saving_model.dart';
import '../pages/edit_transaction_page.dart';
import '../pages/expense_transaction_detail_page.dart';
import '../pages/saving_transaction_detail_page.dart';
import '../repos/saving_repo.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../pages/add_transaction_page.dart';
import '../repos/expense_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'add_saving_transaction_page.dart';
import 'edit_saving_transaction.dart';
import 'my_localapi_page.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Future<ExpenseModel> _expenseData;
  List<Expense> _expenses;

  Future<SavingModel> _savingData;
  List<Saving> _saving;

  double expenseTotal = 0;
  double savingTotal = 0;
  String _playlistUrl =
      "https://www.youtube.com/watch?v=bRhV1HN2Kp4&list=PLwsN38HPkFjdI6XPiIFSpn0Fh86LNydZn";

  @override
  void initState() {
    super.initState();
    _expenseData = readExpenseData();
    _savingData = readSavingData();
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMessage(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar,
        body: _buildBody,
        bottomNavigationBar: _buildButtonNavigationBar,
      ),
    );
  }

  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.blue[800],
      centerTitle: true,
      title: Text("Transaction Overview"),
      bottom: TabBar(
        tabs: [
          Tab(
            text: ("Expense"),
          ),
          Tab(
            text: ("Saving"),
          )
        ],
      ),
    );
  }

  get _buildBody {
    return TabBarView(
      children: [
        _buildExpenseViewTab,
        _buildSavingViewTab,
      ],
    );
  }

  //Expense tab view
  get _buildExpenseViewTab {
    return Container(
      color: Colors.grey[100],
      child: FutureBuilder<ExpenseModel>(
        future: _expenseData,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _expenses = snapshot.data.expenses;
            _calExpenseTotal;
            // return Text("ExpenseViewTab");
            return _buildExpenseParentListView;
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        },
      ),
    );
  }

  get _buildExpenseParentListView {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _expenseData = readExpenseData();
        });
      },
      child: ListView(
        children: [
          _buildTotalCard,
          _buildLastTransactionTitle,
          _buildLastTransaction,
        ],
      ),
    );
  }

  get _buildTotalCard {
    return Container(
      width: 500,
      height: 200,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: _buildTotalCardDetail,
    );
  }

  get _buildTotalCardDetail {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Total Expense",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "-$expenseTotal \$ ",
              style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  get _buildLastTransactionTitle {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Last Transaction",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800]),
          ),
          IconButton(
              icon: Icon(CupertinoIcons.plus),
              color: Colors.blue[800],
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AddTransactionPage()));
              }),
        ],
      ),
    );
  }

  get _buildLastTransaction {
    return FutureBuilder<ExpenseModel>(
      future: _expenseData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("snapshot.error: ${snapshot.error}");
          return Text(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _expenses = snapshot.data.expenses;
          print("Expense length: ${_expenses.length ?? "Hello"}");
          return _buildLastTransactionList;
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  get _buildLastTransactionList {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        return _buildItem(_expenses[index]);
      },
    );
  }

  get _calExpenseTotal {
    expenseTotal = 0;
    print("Expense total: ${_expenses.length}");
    _expenses.forEach((e) {
      expenseTotal += double.parse(e.amount);
    });
  }

  _buildItem(Expense item) {
    DateTime _dataDate = DateTime.parse(item.date);
    String _day = DateFormat.d().format(_dataDate);
    String _month = DateFormat.MMM().format(_dataDate);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageTransition(
            child: ExpenseTransactionDetailPage(expense: item),
            type: PageTransitionType.rightToLeft));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              icon: CupertinoIcons.pen,
              color: Colors.blue[800],
              caption: "Edit",
              onTap: () {
                Navigator.of(context)
                    .push(PageTransition(
                        child: EditExpenseDataPage(expense: item),
                        type: PageTransitionType.rightToLeft))
                    .then((value) {
                  setState(() {
                    _expenseData = readExpenseData();
                  });
                });
              },
            ),
            IconSlideAction(
              icon: CupertinoIcons.delete,
              color: Colors.red[800],
              caption: "Delete",
              onTap: () {
                deleteExpenseData(item).then((value) {
                  print("value: $value");
                  if (value == "deleted") {
                    _showMessage("Expense data deleted.");
                    setState(() {
                      _expenses.remove(item);
                    });
                  } else {
                    _showMessage(
                        "Something went wrong while deleting expense data! Please try again.");
                  }
                });
              },
            ),
          ],
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Column(
                children: [
                  Text(
                    "$_day",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$_month",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              trailing: Text(
                "${item.amount} \$",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800]),
              ),
              title: Text("${item.title}",
                  style: TextStyle(fontSize: 18, color: Colors.blue[800])),
              subtitle: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item.note}"),
                    // Text("${item.date}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Saving View tab
  get _buildSavingViewTab {
    return Container(
      color: Colors.grey[100],
      child: FutureBuilder<SavingModel>(
        future: _savingData,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _saving = snapshot.data.saving;
            _calSavingTotal;
            print("Saving: ${_saving.length ?? ""}");
            return _buildSavingParentListView;
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        },
      ),
    );
  }

  get _buildSavingParentListView {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _savingData = readSavingData();
        });
      },
      child: ListView(
        children: [
          _buildTotalSavingCard,
          _buildLastSavingTitle,
          _buildLastSavingTransaction,
        ],
      ),
    );
  }

  get _buildTotalSavingCard {
    return Container(
      width: 500,
      height: 200,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[400],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: _buildTotalSavingCardDetail,
    );
  }

  get _buildTotalSavingCardDetail {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Total Saving",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "+$savingTotal \$ ",
              style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  get _buildLastSavingTitle {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Last Saving Transaction",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800]),
          ),
          IconButton(
              icon: Icon(CupertinoIcons.plus),
              color: Colors.blue[800],
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AddSavingTransactionPage()));
              }),
        ],
      ),
    );
  }

  get _buildLastSavingTransaction {
    return FutureBuilder<SavingModel>(
      future: _savingData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("snapshot.error: ${snapshot.error}");
          return Text(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _saving = snapshot.data.saving;
          return _buildLastSavingTransactionList;
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  get _buildLastSavingTransactionList {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: _saving.length,
      itemBuilder: (context, index) {
        return _buildSaveItem(_saving[index]);
      },
    );
  }

  get _calSavingTotal {
    savingTotal = 0;
    print("Saving: ${_saving.length}");
    _saving.forEach((e) {
      savingTotal += double.parse(e.amount);
    });
  }

  _buildSaveItem(Saving saveItem) {
    DateTime _saveDataDate = DateTime.parse(saveItem.date);
    String _day = DateFormat.d().format(_saveDataDate);
    String _month = DateFormat.MMM().format(_saveDataDate);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageTransition(
            child: SavingTransactionDetailPage(saving: saveItem),
            type: PageTransitionType.rightToLeft));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              icon: CupertinoIcons.pen,
              color: Colors.blue[800],
              caption: "Edit",
              onTap: () {
                Navigator.of(context)
                    .push(PageTransition(
                        child: EditSavingDataPage(saving: saveItem),
                        type: PageTransitionType.rightToLeft))
                    .then((value) {
                  setState(() {
                    _savingData = readSavingData();
                  });
                });
              },
            ),
            IconSlideAction(
              icon: CupertinoIcons.delete,
              color: Colors.red[800],
              caption: "Delete",
              onTap: () {
                deleteSavingData(saveItem).then((value) {
                  print("value: $value");
                  if (value == "deleted") {
                    _showMessage("Expense data deleted.");
                    setState(() {
                      _saving.remove(saveItem);
                    });
                  } else {
                    _showMessage(
                        "Something went wrong while deleting expense data! Please try again.");
                  }
                });
              },
            ),
          ],
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Column(
                children: [
                  Text(
                    "$_day",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$_month",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              trailing: Text(
                "${saveItem.amount} \$",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800]),
              ),
              title: Text("${saveItem.title}",
                  style: TextStyle(fontSize: 18, color: Colors.blue[800])),
              subtitle: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${saveItem.note}"),
                    // Text("${item.date}"),
                  ],
                ),
              ),
            ),
          ),
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
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return SavePin();
                  }));
                }),
          ],
        ),
      ),
    );
  }

  void _launchURL() async => await canLaunch(_playlistUrl)
      ? await launch(_playlistUrl)
      : throw 'Could not launch $_playlistUrl';
}

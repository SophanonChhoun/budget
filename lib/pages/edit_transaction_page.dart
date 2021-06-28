import '../models/expense_model.dart';
import '../repos/expense_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExpenseDataPage extends StatefulWidget {

  final Expense expense;
  EditExpenseDataPage({this.expense});

  @override
  _EditExpenseDataPageState createState() => _EditExpenseDataPageState();
}

class _EditExpenseDataPageState extends State<EditExpenseDataPage> {
  var _amountCtrl = TextEditingController();
  var _transactionNameCtrl = TextEditingController();
  var _noteCtrl = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMessage(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();

    _amountCtrl.text = widget.expense.amount;
    _transactionNameCtrl.text = widget.expense.title;
    _noteCtrl.text = widget.expense.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildBody,
      ),
      // bottomNavigationBar: _buildButtonNavigationBar,
    );
  }

  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.blue[800],
      centerTitle: false,
      leading: IconButton(
        icon: Icon(CupertinoIcons.back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text("Edit Expense Transaction"),
    );
  }

  get _buildBody {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: _buildParentView,
    );
  }

  get _buildParentView {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, top: 40, right: 10, bottom: 20),
      margin: EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAmountField,
            _buildTransactionField,
            _buildNoteField,
            _buildDateField,
            _buildSaveButton,
          ],
        ),
      ),
    );
  }

  get _buildTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Amount",
        style: TextStyle(fontSize: 24, color: Colors.blue[800]),
      ),
    );
  }

  get _buildAmountField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle,
          _buildAmountInputField,
        ],
      ),
    );
  }

  get _buildAmountInputField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 80,
      child: TextField(
        controller: _amountCtrl,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          suffixIcon: Icon(
            CupertinoIcons.money_dollar,
            size: 40,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[800]),
      ),
    );
  }

  get _buildTransactionNameTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Title",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildTransactionField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionNameTitle,
          _buildTransactionNameField,
        ],
      ),
    );
  }

  get _buildTransactionNameField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 60,
      child: TextField(
        controller: _transactionNameCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        style: TextStyle(fontSize: 18),
        autocorrect: false,
      ),
    );
  }

  get _buildNoteTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Note",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildNoteField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNoteTitle,
          _buildNoteTextField,
        ],
      ),
    );
  }

  get _buildNoteTextField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 60,
      child: TextField(
        controller: _noteCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: Icon(CupertinoIcons.text_justifyleft),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        style: TextStyle(fontSize: 18),
        autocorrect: false,
      ),
    );
  }

  get _buildDateTitle {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        "Date",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildDateField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateTitle,
          _buildDateSelectField,
        ],
      ),
    );
  }

  DateTime _dateTime = DateTime.now();

  get _buildDateSelectField {
    String _dateFormatted = DateFormat.yMMMMd().format(_dateTime);
    return InkWell(
      onTap: () {
        _showDateSelectSheet(context);
      },
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: ListTile(
          leading: Text(
            "$_dateFormatted",
            style: TextStyle(fontSize: 18),
          ),
          trailing: Icon(CupertinoIcons.calendar),
        ),
      ),
    );
  }

  _showDateSelectSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            height: MediaQuery.of(context).size.height * .25,
            child: CupertinoDatePicker(
              initialDateTime: _dateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
            ),
          );
        });
  }

  get _buildSaveButton {
    return Container(
      margin: EdgeInsets.all(30),
      height: 50.0,
      width: 200,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
          side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1)),
        ),
        onPressed: () {
          Expense expense = Expense(
            id: widget.expense.id,
            title: _transactionNameCtrl.text.trim(),
            note: _noteCtrl.text.trim(),
            amount: _amountCtrl.text.trim(),
            date: _dateTime.toString(),
          );

          updateExpenseData(expense).then((value) {
            print("value: $value");
            if (value == "updated") {
              _showMessage("Expense data updated successfully.");
            } else {
              _showMessage("Something went wrong! Please try again.");
            }
            Navigator.of(context).pop();
          });
        },
        padding: EdgeInsets.all(10.0),
        color: Colors.blue[800],
        textColor: Colors.white,
        child: Text("Done", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

import '../models/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTransactionDetailPage extends StatefulWidget {

  final Expense expense;
  ExpenseTransactionDetailPage({this.expense});

  @override
  _ExpenseTransactionDetailPageState createState() => _ExpenseTransactionDetailPageState();
}

class _ExpenseTransactionDetailPageState extends State<ExpenseTransactionDetailPage> {

  Future<ExpenseModel> _expenseData;
  List<Expense> _expenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
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
      title: Text("Expense Detail"),
    );
  }

  get _buildBody {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpenseTitleRow,
          _buildPaymentDateRow,
          _buildNoteRow,
        ],
      ),
    );
  }

  get _buildExpenseTitleRow {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildExpenseTitle,
          _buildExpenseAmount,
        ],
      ),
    );
  }


  get _buildExpenseTitle {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transaction name", style: TextStyle(color: Colors.grey[800]),),
          Text("${widget.expense.title != null ? widget.expense.title : "Title"}", style: TextStyle(fontSize: 24),),
        ],
      ),
    );
  }

  get _buildExpenseAmount {
    return Container(
      child: Text("-${widget.expense.amount == null ? "Amount" : widget.expense.amount} \$", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.red[800]),),
    );
  }

  get _buildPaymentDateRow {
    DateTime _dataDate = DateTime.parse(widget.expense.date);
    String _day = DateFormat.d().format(_dataDate);
    String _month = DateFormat.MMMM().format(_dataDate);
    String _year = DateFormat.y().format(_dataDate);
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Date", style: TextStyle(color: Colors.grey[800]),),
          Text("$_day $_month $_year", style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }

  get _buildNoteRow {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Note", style: TextStyle(color: Colors.grey[800]),),
          Text("${widget.expense.note}", style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './Widget/new_transaction.dart';
import './Widget/transaction_list.dart';
import './models/transaction.dart';
import './Widget/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        fontFamily: 'Raleway',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [
    //Transaction(
    // id: 't1',
    //title: 'New Shoes',
    //amount: 79.99,
    // date: DateTime.now(),
    // ),
    //Transaction(
    //id: 't2',
    //title: 'Weekly Groceries',
    //amount: 29.99,
    // date: DateTime.now(),
    //),
  ];
  bool _showChart = false;
  List<Transaction> get _recentTransaction {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(
      () {
        transactions.add(newTx);
      },
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar =Platform.isIOS? CupertinoNavigationBar(
      middle:const Text('Shopping Transaction'),
      trailing: Row(
        mainAxisSize:MainAxisSize.min,
        children: [
        GestureDetector(
          child:const Icon(CupertinoIcons.add),
          onTap:()=>_startAddNewTransaction(context),
        ),
      ],
      ),
    )
    : AppBar(
      title:const Text('Shopping Transaction'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    final pageBody=SafeArea(child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const  Text('Show Chart'),
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    }),
              ],
            ),
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.3,
                    child: Chart(_recentTransaction),
                  )
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: TransactionList(transactions, _deleteTransaction),
                  ),
          ],
        ),
    ),
    );
    return Platform.isIOS
    ? CupertinoPageScaffold(
      navigationBar: appBar, 
      child: pageBody,
      ) 
    : Scaffold(
      appBar: appBar,
      body:pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:io";
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build() Homepage');
    return Platform.isIOS
        ? CupertinoApp()
        : MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.amber,
                errorColor: Colors.red,
                fontFamily: 'Lato',
                textTheme: ThemeData.light().textTheme.copyWith(
                    titleMedium: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                appBarTheme: AppBarTheme(
                    textTheme: ThemeData.dark().textTheme.copyWith(
                        titleMedium: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            fontWeight: FontWeight.bold)))),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  bool showChart = false;

// passess the transactions list to the chart widget
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLanscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Show chart",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            onChanged: (val) {
              setState(() {
                showChart = val;
              });
            },
            value: showChart,
          ),
        ],
      ),
      showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txList
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.4,
        child: Chart(_recentTransactions),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context),
              )
            ]))
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) ..._buildLanscapeContent(mediaQuery, appBar, txList),
          if (!isLandscape) ..._buildPotraitContent(mediaQuery, appBar, txList),
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

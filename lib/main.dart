import 'package:expenses/widgets/chart.dart';
import 'package:expenses/widgets/new_tranaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // PlatForm checkers
import 'models/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]); // use for Rotation of Screen
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
            button: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final List<Transaction> _userTransaction = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: choosenDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  void _starAddNewTransaction(BuildContext ctx) {
    showBottomSheet(
        context: ctx,
        builder: (bctx) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Container(
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                    0.4,
                child: NewTransaction(
                  addTransaction: _addNewTransaction,
                )),
          );
        });
  }

  List<Widget> _buildLandscapeContainer(MediaQueryData mediaQuery,AppBar appbar,Widget txListWeidget) {
    return[ Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Show Text:", style: Theme.of(context).textTheme.title),
      Switch.adaptive(
        activeColor: Colors.indigo,
        value: _showChart,
        onChanged: (val) {
          // Always through a boolean value on val
          setState(() {
            _showChart = val;
          });
        },
      )
    ]),
    _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appbar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWeidget
    
    ];
  }

  List<Widget> _buildPortrateContainer(MediaQueryData mediaQuery, AppBar appbar,Widget txListWeidget) {
    return [Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions)), txListWeidget];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text(
        "Personal Expense",
        style: TextStyle(fontFamily: 'Open Sans'),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () => _starAddNewTransaction(context),
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
    final txListWeidget = Container(
        height: (mediaQuery.size.height -
                appbar.preferredSize.height -
                mediaQuery.padding.top) *
            0.75,
        child: TransactionList(_userTransaction, _deleteTransaction));
    final pageBody = SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape) ..._buildLandscapeContainer(mediaQuery,appbar,txListWeidget),
          if (!isLandscape) ..._buildPortrateContainer(mediaQuery, appbar, txListWeidget),
          //... tell Dart that you want to pull all the elements out of that list and merge them as single elements
          //into that surrounding list which we have here,
          //the children list for our column.
          //So now instead of adding a list to a list, we're adding all the elements of this list as single items 
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : Builder(
                    builder: (context) => FloatingActionButton(
                      child: Icon(Icons.add),
                      elevation: 10,
                      onPressed: () => _starAddNewTransaction(context),
                    ),
                  ));
  }
}

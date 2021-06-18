
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: FittedBox(
              //Auto automatically adjust the size of the Widget by child
              child: Text(
                '\$${transactions.amount}',
              ),
            ),
          ),
        ),
        title: Text(
          transactions.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(transactions.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () =>
                    deleteTransaction(transactions.id),
                textColor: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                label: Text(
                  "Delete",
                ))
            : IconButton(
                onPressed: () =>
                    deleteTransaction(transactions.id),
                iconSize: 35,
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete_forever_sharp)),
      ),
    );
  }
}

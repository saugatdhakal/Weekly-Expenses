import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;
  NewTransaction({required this.addTransaction}) {
    print("Constructor NewTransaction");
  }

  @override
  _NewTransactionState createState() {
    print("CreateState _NewTransactionState");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  _NewTransactionState() {
    print(" constructor NewTransactionState");
  }
  @override
  void initState() {
    print("initState");
    super.initState();
  }

  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void summitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isNotEmpty && enteredAmount >= 0 ||
        _selectedDate == null) {
      widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);
    } else {
      print("Error on input");
      return;
    }
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_chart_sharp,
                    color: Colors.indigo,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "New Entry",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: titleController,
                onSubmitted: (input) => summitData(),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: amountController,
                onSubmitted: (input) => summitData(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No Date Choosen'
                        : 'Picked Date:${DateFormat.yMd().format(_selectedDate!)}',
                  ),
                  FlatButton(
                      onPressed: _showDatePicker,
                      child: Text(
                        "Choose Date",
                        style: Theme.of(context).textTheme.title,
                      ))
                ],
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                child: FlatButton(
                  onPressed: summitData,
                  color: Theme.of(context).primaryColor,
                  child: Text('ADD TRANSACTIONS',
                      style: Theme.of(context).textTheme.button),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

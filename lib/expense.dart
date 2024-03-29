import 'package:flutter/material.dart';
import 'package:prog3_expense_tracker/chart/chart.dart';
import 'package:prog3_expense_tracker/new_expense.dart';
import 'package:prog3_expense_tracker/widget/expenses_list/expense_list.dart';
import 'package:prog3_expense_tracker/models/expense_structure.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expense> {
  final List<ExpenseStructure> _registeredExpenses = [
    // ExpenseStructure(
    //     title: '\lutter Course',
    //     amount: 20.15,
    //     date: DateTime.now(),
    //     category: Category.work),
    // ExpenseStructure(
    //     title: 'Park',
    //     amount: 10.20,
    //     date: DateTime.now(),
    //     category: Category.leisure)
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(ExpenseStructure expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(ExpenseStructure expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 5),
            Text(
              "Warning!",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        content: const Text(
          "Do you really want to Delete that expense?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          // const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            },
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          // const SizedBox(width: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 5),
                  content: const Text("Expense is Deleted!"),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          _registeredExpenses.insert(expenseIndex, expense);
                        });
                      }),
                ),
              );
            },
            child: const Text(
              "Yes",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Widget emptyListMsg = const Center(
    //   child: Text("No Expense is found. Start Adding some!"),
    // );

    // if(_registeredExpenses.isEmpty)
    // {
    //   mainContent=
    // }
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Flutter Expense Tracker",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _openAddExpenseOverlay();
              },
              icon: const Icon(Icons.add),
            ),
          ]),
      body: width < 600
          ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Chart(expenses: _registeredExpenses),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Expense List",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: _registeredExpenses.isEmpty
                      ? const Center(
                          child:
                              Text("No Expense is found. Start Adding some!"),
                        )
                      : ExpenseList(
                          expenses: _registeredExpenses,
                          onRemovedExpense: _removeExpense),
                ),
                // const Text("hello world"),
              ],
            )
          : Row(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Expense List",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: _registeredExpenses.isEmpty
                            ? const Center(
                                child: Text(
                                    "No Expense is found. Start Adding some!"),
                              )
                            : ExpenseList(
                                expenses: _registeredExpenses,
                                onRemovedExpense: _removeExpense),
                      ),
                    ],
                  ),
                ),
                // const Text("hello world"),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../widgets/expense_list_item.dart';
import 'add_expense_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Lunch',
      amount: 180,
      category: 'Food',
      date: DateTime.now(),
    ),
    Expense(
      title: 'Bus ticket',
      amount: 40,
      category: 'Transport',
      date: DateTime.now(),
    ),
    Expense(
      title: 'Groceries',
      amount: 650,
      category: 'Shopping',
      date: DateTime.now(),
    ),
    Expense(
      title: 'Gift',
      amount: 434,
      category: 'Miscellaneous',
      date: DateTime.now(),
    ),
  ];

  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Miscellaneous',
  ];

  double get _totalExpenses {
    return _expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  List<Expense> get _filteredExpenses {
    if (_selectedCategory == 'All') {
      return _expenses;
    }

    return _expenses
        .where((expense) => expense.category == _selectedCategory)
        .toList();
  }

  Future<void> _addExpense() async {
    final newExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );

    if (!mounted) return;

    if (newExpense != null) {
      setState(() {
        _expenses.insert(0, newExpense);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedExpenses = _filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpendSense'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
              });
            },
            icon: const Icon(Icons.filter_alt_off),
            tooltip: 'Clear filter',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Expenses'),
                    const SizedBox(height: 8),
                    Text(
                      '₹${_totalExpenses.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_expenses.length} transactions',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Filter by category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          Expanded(
            child: displayedExpenses.isEmpty
                ? const Center(child: Text('No expenses in this category.'))
                : ListView.builder(
                    itemCount: displayedExpenses.length,
                    itemBuilder: (context, index) {
                      return ExpenseListItem(expense: displayedExpenses[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        tooltip: 'Add expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:budgetbuddy/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:budgetbuddy/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:budgetbuddy/dialog/category_creation.dart';
import 'package:budgetbuddy/expense_repository/expense_repository.dart';
import 'package:budgetbuddy/screens/entryPoint/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddPage extends StatefulWidget {
  final Function(Expense) onExpenseAdded;

  const AddPage({super.key, required this.onExpenseAdded});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isExpanded = false; // Track whether the category field is expanded
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    resetState();
  }

  void resetState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    expensesController.clear();
    categoryController.clear();
  }

  @override
  void dispose() {
    // Dispose your text controllers
    expensesController.dispose();
    categoryController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          widget.onExpenseAdded(expense);  // Call the callback function
          resetState();
          Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const EntryPoint()),
      (route) => false,
    );
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          const Text(
                            'Add Expenses',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: screenWidth * 0.7,
                            child: TextFormField(
                              controller: expensesController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.dollarSign,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            readOnly: true,
                            controller: categoryController,
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: expense.category == Category.empty
                                  ? Colors.white
                                  : Color(expense.category.color),
                              prefixIcon: expense.category == Category.empty
                                  ? const Icon(
                                      FontAwesomeIcons.list,
                                      size: 16,
                                      color: Colors.grey,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                                      child: Image.asset(
                                        'assets/categoryIcons/${expense.category.icon}.png',
                                        width: 16, // Adjust the width and height as needed
                                        height: 16,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  var newCategory = await getCategoryCreation(context);
                                  setState(() {
                                    state.categories.insert(0, newCategory);
                                  });
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.sortDown,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'Category',
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: isExpanded
                                    ? const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      )
                                    : BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: isExpanded
                                  ? const OutlineInputBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      borderSide: BorderSide.none,
                                    )
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                              focusedBorder: isExpanded
                                  ? const OutlineInputBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      borderSide: BorderSide.none,
                                    )
                                  : OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                            ),
                          ),
                          isExpanded
                              ? Container(
                                  height: 200,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      itemCount: state.categories.length,
                                      itemBuilder: (context, int i) {
                                        return Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                expense.category = state.categories[i];
                                                categoryController.text = expense.category.name;
                                              });
                                            },
                                            leading: Transform.scale(
                                              scale: 0.5, // Adjust the scaling factor as needed
                                              child: Image.asset(
                                                'assets/categoryIcons/${state.categories[i].icon}.png',
                                                fit: BoxFit.contain, // Ensure the image fits within the box after scaling
                                              ),
                                            ),
                                            title: Text(state.categories[i].name),
                                            tileColor: Color(state.categories[i].color),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: expense.date,
                                firstDate: DateTime.now(), // Adjusted the firstDate for wider range
                                lastDate: DateTime.now().add(const Duration(days: 365)), // Adjusted the lastDate for wider range
                              );
                              if (newDate != null) {
                                setState(() {
                                  dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                                  expense.date = newDate;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                FontAwesomeIcons.calendar,
                                size: 16,
                                color: Colors.grey,
                              ),
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      expense.amount = int.parse(expensesController.text);
                                    });
                                    context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF77D8E),
                                    minimumSize: const Size(double.infinity, 56),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:budgetbuddy/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:budgetbuddy/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:budgetbuddy/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:budgetbuddy/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:budgetbuddy/constants.dart';
import 'package:budgetbuddy/expense_repository/expense_repository.dart';
import 'package:budgetbuddy/model/bottomnavbar.dart';
import 'package:budgetbuddy/pages/add_page.dart';
import 'package:budgetbuddy/pages/stash_page.dart';
import 'package:budgetbuddy/pages/stats_page.dart';
import 'package:budgetbuddy/pages/user_page.dart';
import 'package:budgetbuddy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

import '../../model/menu.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;
  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;
  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;
  int _selectedIndex = 1; // Default to the HomePage
  late List<Expense> _expenses;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
    _expenses = [];
    _fetchExpenses(); // Fetch expenses when the widget is initialized
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchExpenses() async {
    final repo = FirebaseExpenseRepo();
    final expenses = await repo.getExpenses();
    setState(() {
      _expenses = expenses;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleNewExpense(Expense expense) {
    setState(() {
      _expenses.insert(0, expense);
      _expenses.sort((a, b) {
        if (a.date == b.date) {
          return b.expenseId.compareTo(a.expenseId); // Sort by expenseId if dates are equal
        }
        return b.date.compareTo(a.date); // Sort by date in descending order
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateCategoryBloc(FirebaseExpenseRepo()),
        ),
        BlocProvider(
          create: (context) => GetCategoriesBloc(FirebaseExpenseRepo())
            ..add(GetCategories()),
        ),
        BlocProvider(
          create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
        ),
        BlocProvider(
          create: (context) => GetExpensesBloc(FirebaseExpenseRepo()),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor2,
        body: Stack(
          children: [
            AnimatedPositioned(
              width: 288,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 0 : -288,
              top: 0,
              child: const SideBar(),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(1 * animation.value - 30 * (animation.value) * pi / 180),
              child: Transform.translate(
                offset: Offset(animation.value * 265, 0),
                child: Transform.scale(
                  scale: scalAnimation.value,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24),
                    ),
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: [
                        const StatsPage(),
                        HomePage(expenses: _expenses), // Pass expenses to HomePage
                        AddPage(
                          onExpenseAdded: _handleNewExpense,
                        ),
                        const StashPage(),
                        const UserPage(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              left: isSideBarOpen ? 220 : 0,
              top: 16,
              child: MenuBtn(
                press: () {
                  isMenuOpenInput.value = !isMenuOpenInput.value;

                  if (_animationController.value == 0) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }

                  setState(() {
                    isSideBarOpen = !isSideBarOpen;
                  });
                },
                riveOnInit: (artboard) {
                  final controller = StateMachineController.fromArtboard(
                      artboard, "State Machine");

                  artboard.addController(controller!);

                  isMenuOpenInput =
                      controller.findInput<bool>("isOpen") as SMIBool;
                  isMenuOpenInput.value = true;
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Transform.translate(
          offset: Offset(0, 100 * animation.value),
          child: SafeArea(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 12, top: 9, right: 12, bottom: 0),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor2.withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor2.withOpacity(0.3),
                    offset: const Offset(0, 20),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  gifIcons.length,
                  (index) {
                    return GestureDetector(
                      onTap: () => _onItemTapped(index),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getGifImage(gifIcons[index]),
                          const SizedBox(height: 2),
                          Text(
                            gifIcons[index].label,
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.amber[800]
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:budgetbuddy/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:budgetbuddy/constants.dart';
import 'package:budgetbuddy/expense_repository/expense_repository.dart';
import 'package:budgetbuddy/model/icon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      Color categoryColor = Colors.white;
      final TextEditingController categoryNameController = TextEditingController();
      final TextEditingController categoryIconController = TextEditingController();
      final TextEditingController categoryColorController = TextEditingController();
      final screenWidth = MediaQuery.of(context).size.width;
      Category category = Category.empty;

      bool isLoading = false;
      String? iconSelected; // Reset iconSelected here

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(ctx, category);
                }
              },
              child: AlertDialog(
                title: const Text('Create a Category'),
                backgroundColor: backgroundColorLight,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: screenWidth,
                      child: TextFormField(
                        controller: categoryNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Name', // Changed label to labelText
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryIconController,
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        suffixIcon: const Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 16,
                          color: Colors.grey,
                        ),
                        fillColor: Colors.white,
                        hintText: 'Icon',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                    if (isExpanded)
                      Container(
                        width: screenWidth,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: myCategoriesIcons.length,
                            itemBuilder: (context, int i) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      iconSelected = myCategoriesIcons[i];
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: iconSelected == myCategoriesIcons[i]
                                              ? Colors.green.shade900
                                              : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        color: iconSelected == myCategoriesIcons[i]
                                            ? Colors.green
                                            : Colors.white,
                                      ),
                                      child: Transform.scale(
                                        scale: 0.5, // Adjust the scaling factor as needed
                                        child: Image.asset(
                                          'assets/categoryIcons/${myCategoriesIcons[i]}.png',
                                          fit: BoxFit.contain, // Ensure the image fits within the box after scaling
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: categoryColorController,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: categoryColor,
                                    onColorChanged: (value) {
                                      setState(() {
                                        categoryColor = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx2).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      categoryColorController.text = categoryColor.toString();
                                    });
                                    Navigator.of(ctx2).pop();
                                  },
                                  child: const Text('Save Color'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: categoryColor,
                        hintText: 'Color',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            // Add save category logic here
                            setState (() {
                            category.categoryId = const Uuid().v1();
                            category.name = categoryNameController.text;
                            category.icon = iconSelected ?? '';
                            category.color = categoryColor.value;
                            });
                            
                            context.read<CreateCategoryBloc>().add(CreateCategory(category));
                          },
                          child: const Text('Save'),
                        ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

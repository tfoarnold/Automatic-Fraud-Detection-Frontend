import 'dart:convert';
import 'dart:io';

import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/providers/categories_provider.dart';
import 'package:automatic_fraud_detection/widgets/add_category.dart';
import 'package:automatic_fraud_detection/widgets/category_item.dart';
import 'package:automatic_fraud_detection/widgets/screens_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = Provider.of<CategoriesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return const AddCategory();
              });
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ScreenHeader(text: 'Your Categories'),
          Expanded(
            child: FutureBuilder(
                future: categoryProvider.getCategories(authProvider.token),
                builder: (context, snapshot) {
                  return ListView.builder(
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryItem(
                          categroy: categoryProvider.categories[index],
                          isEven: index % 2 == 0 ? true : false,
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

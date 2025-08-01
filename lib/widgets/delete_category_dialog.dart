import 'package:automatic_fraud_detection/models/category.dart';
import 'package:automatic_fraud_detection/providers/auth_provider.dart';
import 'package:automatic_fraud_detection/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteCategoryDialog extends StatefulWidget {
  final LocalCategory? category;

  const DeleteCategoryDialog({Key? key, this.category}) : super(key: key);

  @override
  State<DeleteCategoryDialog> createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<DeleteCategoryDialog> {

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoriesProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return  IconButton(
      icon: Icon(Icons.delete,color: Colors.red.shade700,),

      onPressed: () {

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text(
                    'you sure you want to delete this category'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          categoryProvider.deleteCategory(
                              widget.category!
                                  .id ??
                                  0,
                          authProvider.token
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('no'))
                ],
              );
            });
      },
    );
  }
}

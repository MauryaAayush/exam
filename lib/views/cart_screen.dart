import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Obx(() {
        if (cartController.loading.value) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        }

        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('No items in the cart'));
        }

        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];

            return ListTile(
              title: Text(item['product']),
              subtitle: Text(item['category']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showUpdateDialog(context, item);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cartController.deleteCartItem(item['id']);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showUpdateDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController productController = TextEditingController(text: item['product']);
    final TextEditingController categoryController = TextEditingController(text: item['category']);
    final TextEditingController priceController = TextEditingController(text: item['price']); // Assuming price is also part of the item

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: productController,
                  decoration: const InputDecoration(labelText: 'Product'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await cartController.updateCartItem(
                  item['id'],
                  productController.text,
                  categoryController.text,
                );
                Get.back(); // Close the dialog
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog without making changes
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

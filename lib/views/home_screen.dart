import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/controller/database_controller.dart';
import 'package:exam/views/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/cart_controller.dart';
import '../helper/local_database_helper.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController producttxt = TextEditingController();
  TextEditingController categorytxt = TextEditingController();
  TextEditingController pricetxt = TextEditingController();

  final CartController cartController = Get.put(CartController());

  final AddUsers addUsers = Get.put(AddUsers());

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_outlined),
        title: const Text('Hello, Aayush'),
        actions: [
          Row(
            children: [
              const Icon(Icons.notifications),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {
                    cartController.fetchCartItems();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ));
                  },
                  icon: const Icon(Icons.shopping_cart_sharp)),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 130,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Text(
                      'Customise Your\n grocery list as you like ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Add Item'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: producttxt,
                                        decoration: const InputDecoration(
                                            hintText: 'Product'),
                                      ),
                                      TextField(
                                        controller: categorytxt,
                                        decoration: const InputDecoration(
                                            hintText: 'Category'),
                                      ),
                                      TextField(
                                        controller: pricetxt,
                                        decoration: const InputDecoration(
                                            hintText: 'Price'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                addUsers.addUser(
                                                    producttxt.text,
                                                    categorytxt.text,
                                                    pricetxt.text);
                                                producttxt.clear();
                                                categorytxt.clear();
                                                pricetxt.clear();

                                                Navigator.pop(context);
                                              },
                                              child: const Text("Done"))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Items',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return SizedBox(
                    height: 500,
                    width: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String docId = document.id;

                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Choose one of them'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await LocalDatabase().addToCart(
                                            data['Product'],
                                            data['Category'],
                                          );
                                          Navigator.pop(context);
                                          Get.snackbar(
                                            backgroundColor: Colors.green,
                                              'Success', 'Item added to cart');
                                        },
                                        child: const Text('Add to cart'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController
                                                  productController =
                                                  TextEditingController(
                                                      text: data['Product']);
                                              TextEditingController
                                                  categoryController =
                                                  TextEditingController(
                                                      text: data['Category']);
                                              TextEditingController
                                                  priceController =
                                                  TextEditingController(
                                                      text: data['Price']);

                                              return AlertDialog(
                                                title:
                                                    const Text('Update User'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          productController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Product',
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          categoryController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Category',
                                                      ),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          priceController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Price',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      addUsers.updateUser(
                                                        docId,
                                                        productController.text,
                                                        categoryController.text,
                                                        priceController.text,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Update'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('Update'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          addUsers.deleteUser(docId);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(data['Product']),
                            subtitle: Text(data['Category']),
                            trailing: Text(data['Price']),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

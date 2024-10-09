import 'package:exam/views/cart_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu_outlined),
        title: const Text('Hello, Aayush'),
        actions: [
          Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ));
                  },
                  icon: Icon(Icons.shopping_cart_sharp)),
              SizedBox(
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
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String title;
                                String subTitle;
                                String price;

                                return AlertDialog(
                                  title: const Text('Add Item'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          title = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Title'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          subTitle = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Subtitle'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          price = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Price'),
                                      ),
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
              SizedBox(
                height: 500,
                width: 300,
                // color: Colors.red,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      leading: Text('1'),
                      title: Text('Apple'),
                      subtitle: Text('Fruit'),
                      trailing: Text('1000'),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

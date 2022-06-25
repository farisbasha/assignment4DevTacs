// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var productList = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SHOP APP'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                //TODO implement api call here

                setState(() {
                  isLoading = true;
                });
                final response =
                    await Dio().get("https://fakestoreapi.com/products");
                productList = response.data;
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (ctx, indx) => ProductCard(
                      price: productList[indx]['price'],
                      title: productList[indx]['title'],
                      image: productList[indx]['image']),
                ),
        ));
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.price,
    required this.title,
    required this.image,
  }) : super(key: key);

  final double price;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black87,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        "₹ $price",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '$title',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

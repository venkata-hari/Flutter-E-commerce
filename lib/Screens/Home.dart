import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/Home.dart' as home;
import 'package:my_flutter_app/Screens/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  ProductsState createState() => ProductsState();
}

class ProductsState extends State<HomeScreen> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {'Connection': 'keep-alive'},
      );
      setState(() {
        data = jsonDecode(res.body);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child:
          data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder:
                          (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        data[index]['image'],
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    data[index]['title'].length > 10
                                        ? '${data[index]['title'].substring(0, 10)}...'
                                        : data[index]['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.1, // Adjusted ratio for better fit
                        crossAxisCount: 2,
                      ),
                      itemCount: data.length,
                      itemBuilder:
                          (context, index) => Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Colors.black,
                                      ),
                                      padding:
                                          EdgeInsets
                                              .zero, // Removes extra padding
                                      constraints:
                                          BoxConstraints(), // Removes button constraints
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Expanded(
                                  child: Image.network(
                                    data[index]['image'],
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data[index]['title'].length > 10
                                      ? '${data[index]['title'].substring(0, 10)}...'
                                      : data[index]['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBarIndicator(
                                  rating:
                                      (data[index]['rating']['rate'] ?? 0)
                                          .toDouble(),
                                  itemBuilder:
                                      (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 19,
                                ),
                                SizedBox(height: 2),
                                Container(
                                  width: double.infinity,
                                  // Full width
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.black,
                                      ), // Top border
                                    ),
                                  ), // Adds spacing after the border
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '\$${data[index]['price'].toString()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setInt(
                                            'product_id',
                                            data[index]['id'],
                                          );
                                          await prefs.setString(
                                            'category',
                                            data[index]['category'],
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ProductScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          backgroundColor: Colors.black,
                                          foregroundColor: Colors.white,
                                          // Button background
                                        ),
                                        child: FittedBox(
                                          // Ensures the text fits inside the button
                                          child: Text(
                                            'View',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ), // Set initial size
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}

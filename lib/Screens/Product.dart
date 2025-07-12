import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/Screens/Category.dart';

class ProductScreen extends StatefulWidget {
  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  Map<String, dynamic> data = {};
  List<dynamic> data1 = [];
  int? productId;
  String? category;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadStoredData();
  }

  Future<void> loadStoredData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      productId = pref.getInt('product_id');
      category = pref.getString('category');
    });
    if (productId != null || category != null) {
      fetchProducts();
      fetchCategory();
    }
  }

  Future<void> fetchCategory() async {
    if (category == null) return;
    try {
      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products/category/${category}'),
        headers: {'Connection': 'keep-alive'},
      );
      setState(() {
        data1 = jsonDecode(res.body);
        isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  /// Fetch product details from API
  Future<void> fetchProducts() async {
    if (productId == null) return;
    try {
      final res = await http.get(
        Uri.parse('https://fakestoreapi.com/products/$productId'),
        headers: {'Connection': 'keep-alive'},
      );
      setState(() {
        data = jsonDecode(res.body);
        isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void navigateToProduct(int newId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('product_id', newId);
    setState(() {
      productId = newId;
      isLoading = true;
    });
    fetchProducts();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color.fromARGB(210, 219, 213, 216),
      ),
      body:
           isLoading
              ? Center(child: CircularProgressIndicator())
              :SingleChildScrollView(
              child:Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 204, 191, 191),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Image.network(
                              data['image'],
                              width: 120,
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Category: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                ),
                              ),
                              TextSpan(
                                text: '${data['category']}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RatingBarIndicator(
                          rating: (data['rating']['rate'] ?? 0).toDouble(),
                          itemBuilder:
                              (context, index) =>
                                  Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 28,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                 
                        child: Text(
                          data['description'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${data['price'].toString()}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Add To Cart'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Category(data1: data1, onProductSelect: navigateToProduct),
                  ],
                ),
              ),
    ));
  }
}

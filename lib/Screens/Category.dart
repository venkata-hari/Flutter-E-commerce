import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category extends StatelessWidget {
  final List<dynamic> data1;
  final Function(int) onProductSelect;
  Category({required this.data1, required this.onProductSelect});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Related Products',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Length:'),
                  TextSpan(text: '${data1.length}'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        ListView.builder(
           shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
            itemCount: data1.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Expanded(
                        flex: 2,
                        child: Image.network(
                          data1[index]['image'],
                          height: 70,
                          width: 70,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data1[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${data1[index]['price'].toString()}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                RatingBarIndicator(
                                  rating:
                                      data1[index]['rating']['rate'].toDouble(),
                                  itemCount: 5,
                                  itemSize: 19,
                                  itemBuilder:
                                      (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          onProductSelect(data1[index]['id']);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 2,
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('view'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

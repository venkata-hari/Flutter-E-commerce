import 'package:flutter/material.dart';
import 'package:my_flutter_app/Screens/Fav.dart';
import 'package:my_flutter_app/Screens/Home.dart';
import 'package:my_flutter_app/Screens/Settings.dart';

class BottomNavigation extends StatefulWidget {
  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int setIndex = 0;
  final List pages = [HomeScreen(), Fav(), Settings()];
  void OnTappedItems(int index) {
    setState(() {
      setIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.black,
        foregroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.all(5), // Adds padding to title and actions
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Spaces title and icons
            children: [
              Text('Logo', style: TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: [
                 
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notification_add),
                  ),
                   IconButton(onPressed: () {}, icon: Icon(Icons.logout))
                ],
              ),
            ],
          ),
        ),
      ),
      body: pages[setIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1)],
          ),

          child: BottomNavigationBar(
            // type:BottomNavigationBarType.shifting,
            currentIndex: setIndex,
            onTap: OnTappedItems,
            selectedItemColor: Colors.white,
            selectedFontSize: 13.0,
            unselectedFontSize: 12.0,
            unselectedItemColor: const Color.fromARGB(255, 212, 207, 207),
            backgroundColor: Colors.transparent,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  setIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  setIndex == 1 ? Icons.favorite : Icons.favorite_border,
                ),
                label: 'Fav',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  setIndex == 2 ? Icons.settings : Icons.settings_outlined,
                ),
                label: 'Settings',
                backgroundColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

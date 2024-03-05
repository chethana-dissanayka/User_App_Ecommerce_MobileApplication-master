import 'package:flutter/material.dart';
import 'package:appecommerce/const/AppColors.dart';
import 'package:appecommerce/ui/bottom_nav_pages/cart.dart';
import 'package:appecommerce/ui/bottom_nav_pages/favourite.dart';
import 'package:appecommerce/ui/bottom_nav_pages/home.dart';
import 'package:appecommerce/ui/bottom_nav_pages/profile.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    Home(),
    Favourite(),
    Cart(),
    Profile(),
  ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 127, 189),
        elevation: 0,
        title: Text(
          "HAPPY SHOP",
          style: TextStyle(color: const Color.fromARGB(255, 252, 252, 252),fontSize: 30,fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orange,
        backgroundColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 176, 18, 18),
        currentIndex: _currentIndex,
        selectedLabelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
           
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favourite',
          
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Cart',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
      body: _pages[_currentIndex],
      
    );
  }
}

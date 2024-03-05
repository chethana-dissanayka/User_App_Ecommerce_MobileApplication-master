import 'package:flutter/material.dart';
import 'package:appecommerce/widgets/fetchdatfavorite.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: fetchDatafav("users-favourite-items"),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:green_thumb/config/global_variables.dart';
import 'package:green_thumb/screens/chat/conversations.dart';
import 'package:green_thumb/screens/home_page/home_page.dart';
import 'package:green_thumb/screens/my_account.dart';
import 'package:green_thumb/screens/shopping_cart.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  static String id = "BottomNavigationBar_screen";
  final int currentIndex;
  const BottomNavigationBarScreen({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex; // assign it a value here
  }

  final List<Widget> _routes = [
    HomePageScreen(),
    ShoppingCartScreen(),
    ConversationScreen(),
    MyAccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: <Widget>[
              Icon(Icons.shopping_cart_rounded),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    shoppingCartItems.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          label: 'Shopping cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'My Account',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => _routes[index]));
        ;
      },
    );
  }
}

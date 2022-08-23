import 'package:flutter/material.dart';

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

  final List<Widget> _routes = [];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
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
        /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => _routes[index]));*/
        ;
      },
    );
  }
}

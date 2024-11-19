import 'package:anota_cep/src/modules/home/passbook/passbook_page.dart';
import 'package:flutter/material.dart';
import 'package:anota_cep/src/modules/home/map/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          SafeArea(
            child: MapPage(),
          ),
          PassbookPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFFBFBFB),
        items: const [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/mapa.png'),
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/mapa_selected.png'),
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/icons/caderneta.png'),
            ),
            activeIcon: Image(
              image: AssetImage('assets/icons/caderneta_selected.png'),
            ),
            label: 'Caderneta',
          ),
        ],
      ),
    );
  }
}

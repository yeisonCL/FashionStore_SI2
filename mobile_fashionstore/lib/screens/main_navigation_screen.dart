import 'package:flutter/material.dart';
import 'home_catalog_screen.dart';
import 'ar_vestidor_screen.dart';
import 'ia_outfits_screen.dart';
import 'reportes_voz_screen.dart';
import 'perfil_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeCatalogScreen(),
    const ArVestidorScreen(),
    const IaOutfitsScreen(),
    const ReportesVozScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF334155), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: primaryViolet,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront, color: primaryViolet),
              label: 'Catálogo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar_outlined),
              activeIcon: Icon(Icons.view_in_ar, color: primaryViolet),
              label: 'AR 3D',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_outlined),
              activeIcon: Icon(Icons.psychology, color: primaryViolet),
              label: 'IA Shopper',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none_outlined),
              activeIcon: Icon(Icons.mic, color: primaryViolet),
              label: 'Voz NLP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, color: primaryViolet),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

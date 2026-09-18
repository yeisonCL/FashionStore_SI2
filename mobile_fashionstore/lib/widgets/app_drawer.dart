import 'package:flutter/material.dart';
import '../screens/home_catalog_screen.dart';
import '../screens/ar_vestidor_screen.dart';
import '../screens/ia_outfits_screen.dart';
import '../screens/reportes_voz_screen.dart';
import '../screens/carrito_checkout_screen.dart';
import '../screens/reservas_screen.dart';
import '../screens/resenas_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatefulWidget {
  final Function(Widget screen, String title)? onSelectScreen;

  const AppDrawer({super.key, this.onSelectScreen});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool p1Expanded = true;
  bool p2Expanded = false;
  bool p3Expanded = false;
  bool p4Expanded = false;
  bool p5Expanded = false;

  void _navigateTo(Widget screen, String title) {
    Navigator.pop(context); // Cierra el Drawer
    if (widget.onSelectScreen != null) {
      widget.onSelectScreen!(screen, title);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkDrawerBg = Color(0xFF0B0F19);
    const activeHeaderBg = Color(0xFF1E1B4B);
    const primaryPurple = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Drawer(
      backgroundColor: darkDrawerBg,
      child: SafeArea(
        child: Column(
          children: [
            // Header del Drawer (Igual a Screenshot 4)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [primaryPurple, secondaryBlue]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.checkroom, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FashionStore', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Moda & Vestidores AR', style: TextStyle(color: secondaryBlue, fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),

            // Lista de Módulos Categorizados
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                children: [
                  // Dashboard
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: activeHeaderBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryPurple.withValues(alpha: 0.6)),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _navigateTo(const HomeCatalogScreen(), 'Dashboard Omnicanal'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.dashboard_outlined, color: primaryPurple, size: 20),
                            SizedBox(width: 12),
                            Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('📱 CASOS DE USO MÓVIL', style: TextStyle(color: secondaryBlue, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  ),

                  // Casos de Uso Móvil Principales (100% Funcionales)
                  _buildMainMobileItem('[CU16] Vestidor Virtual AR 3D', Icons.view_in_ar, primaryPurple, () => _navigateTo(const ArVestidorScreen(), 'CU16: Vestidor AR 3D')),
                  _buildMainMobileItem('[CU17] Personal Shopper IA', Icons.psychology, secondaryBlue, () => _navigateTo(const IaOutfitsScreen(), 'CU17: Personal Shopper IA')),
                  _buildMainMobileItem('[CU11] Catálogo Omnicanal', Icons.checkroom, Colors.greenAccent, () => _navigateTo(const HomeCatalogScreen(), 'CU11: Catálogo Omnicanal')),
                  _buildMainMobileItem('[CU12] Reservas Web-to-Store (48h)', Icons.event_available, Colors.orangeAccent, () => _navigateTo(const ReservasScreen(), 'CU12: Reservas 48h')),
                  _buildMainMobileItem('[CU15] Carrito & Ventas Digitales', Icons.shopping_cart_outlined, Colors.pinkAccent, () => _navigateTo(const CarritoCheckoutScreen(carritoItems: []), 'CU15: Ventas Digitales')),
                  _buildMainMobileItem('[CU18] Reportes por Voz (NLP)', Icons.mic_none, Colors.tealAccent, () => _navigateTo(const ReportesVozScreen(), 'CU18: Reportes por Voz NLP')),
                  _buildMainMobileItem('[CU19] Reseñas & Estrellas', Icons.star_outline, Colors.amberAccent, () => _navigateTo(const ResenasScreen(prendaId: 1, prendaNombre: 'Chaqueta Denim'), 'CU19: Reseñas')),
                  _buildMainMobileItem('[CU01] Mi Perfil & Seguridad', Icons.person_outline, Colors.purpleAccent, () => _navigateTo(const PerfilScreen(), 'CU01: Mi Perfil')),

                  const Divider(color: Color(0xFF1E293B), height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text('💻 MÓDULOS ADMINISTRATIVOS WEB', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                  ),

                  // P1: Seguridad y Administración Web
                  _buildExpansionTile(
                    title: 'P1: Seguridad y Administra.',
                    icon: Icons.verified_user_outlined,
                    isExpanded: p1Expanded,
                    onToggle: () => setState(() => p1Expanded = !p1Expanded),
                    children: [
                      _buildSubItem('[CU02] Personal & Roles', Icons.badge_outlined, () => _navigateTo(const PerfilScreen(), 'CU02: Personal')),
                      _buildSubItem('[CU03] Bitácora Auditoría', Icons.history, () => _navigateTo(const PerfilScreen(), 'CU03: Bitácora Auditoría')),
                    ],
                  ),

                  // P2: Configuración y Catálogo Web
                  _buildExpansionTile(
                    title: 'P2: Configuración y Catálogo',
                    icon: Icons.settings_outlined,
                    isExpanded: p2Expanded,
                    onToggle: () => setState(() => p2Expanded = !p2Expanded),
                    children: [
                      _buildSubItem('[CU04] Parámetros Moda', Icons.tune, () => _navigateTo(const HomeCatalogScreen(), 'CU04: Parámetros Moda')),
                      _buildSubItem('[CU05] Productos / Prendas', Icons.checkroom, () => _navigateTo(const HomeCatalogScreen(), 'CU05: Productos')),
                      _buildSubItem('[CU06] Variantes (Talla/Color)', Icons.style_outlined, () => _navigateTo(const HomeCatalogScreen(), 'CU06: Variantes')),
                      _buildSubItem('[CU07] Sucursales Cadena', Icons.store_outlined, () => _navigateTo(const HomeCatalogScreen(), 'CU07: Sucursales')),
                    ],
                  ),

                  // P3: Logística e Inventario Web
                  _buildExpansionTile(
                    title: 'P3: Logística e Inventario',
                    icon: Icons.inventory_2_outlined,
                    isExpanded: p3Expanded,
                    onToggle: () => setState(() => p3Expanded = !p3Expanded),
                    children: [
                      _buildSubItem('[CU08] Inventario Local POS', Icons.inventory, () => _navigateTo(const HomeCatalogScreen(), 'CU08: Inventario Local')),
                      _buildSubItem('[CU10] Traspasos Almacén', Icons.swap_horiz, () => _navigateTo(const HomeCatalogScreen(), 'CU10: Traspasos Almacén')),
                    ],
                  ),
                ],
              ),
            ),

            // Footer con usuario activo y logout
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: primaryPurple,
                    child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('admin (Administrador)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Sesión Activa Local', style: TextStyle(color: Colors.white54, fontSize: 10)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    const primaryPurple = Color(0xFF8B5CF6);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: primaryPurple, size: 18),
                      const SizedBox(width: 10),
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: Colors.white54, size: 18),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 6),
              child: Column(children: children),
            ),
        ],
      ),
    );
  }

  Widget _buildMainMobileItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubItem(String title, IconData icon, VoidCallback onTap) {
    const secondaryBlue = Color(0xFF38BDF8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: secondaryBlue, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12))),
          ],
        ),
      ),
    );
  }
}

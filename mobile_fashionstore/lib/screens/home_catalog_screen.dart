import 'package:flutter/material.dart';
import '../models/prenda_model.dart';
import '../services/api_service.dart';
import '../widgets/app_drawer.dart';
import 'carrito_checkout_screen.dart';
import 'reservas_screen.dart';
import 'resenas_screen.dart';
import 'perfil_screen.dart';
import 'login_screen.dart';

class HomeCatalogScreen extends StatefulWidget {
  const HomeCatalogScreen({super.key});

  @override
  State<HomeCatalogScreen> createState() => _HomeCatalogScreenState();
}

class _HomeCatalogScreenState extends State<HomeCatalogScreen> {
  List<PrendaModel> prendas = [];
  bool isLoading = true;
  String searchQuery = '';
  final List<Map<String, dynamic>> carritoLocal = [];
  String periodoSeleccionado = 'Último año';

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    setState(() => isLoading = true);
    final data = await ApiService.getCatalogo(buscar: searchQuery);
    setState(() {
      prendas = data;
      isLoading = false;
    });
  }

  void _mostrarMenuUsuario(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 80, 0, 0),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          onTap: () {
            final nav = Navigator.of(context);
            Future.delayed(Duration.zero, () {
              nav.push(MaterialPageRoute(builder: (_) => const PerfilScreen()));
            });
          },
          child: const Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF1E293B), size: 18),
              SizedBox(width: 10),
              Text('Mi Perfil', style: TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.settings_outlined, color: Color(0xFF1E293B), size: 18),
              SizedBox(width: 10),
              Text('Configuración', style: TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.keyboard_outlined, color: Color(0xFF1E293B), size: 18),
              SizedBox(width: 10),
              Text('Atajos de Teclado', style: TextStyle(color: Color(0xFF1E293B), fontSize: 13)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          onTap: () {
            final nav = Navigator.of(context);
            Future.delayed(Duration.zero, () {
              nav.pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
            });
          },
          child: const Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent, size: 18),
              SizedBox(width: 10),
              Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  void _mostrarModalDisponibilidad(BuildContext context, PrendaModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.store, color: Color(0xFF8B5CF6), size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Disponibilidad por Sucursal (CU11)',
                    style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.nombre, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 14, fontWeight: FontWeight.bold)),
            const Divider(color: Color(0xFFE2E8F0), height: 24),
            _buildBranchRow('Sucursal Central', 'Central (Calle 21 de Calacoto)', 1),
            _buildBranchRow('Sucursal Equipetrol', 'Santa Cruz - Av. San Martín', 15),
            _buildBranchRow('Sucursal Ventura Mall', 'Santa Cruz - Nivel 2', 15),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                icon: const Icon(Icons.event_available, size: 18),
                label: const Text('Apartar en Sucursal (CU12 Reserva)'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservasScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBranchRow(String nombre, String ubicacion, int stock) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
              Text(ubicacion, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: stock > 5 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: stock > 5 ? const Color(0xFF86EFAC) : const Color(0xFFFCD34D)),
            ),
            child: Text(
              '$stock u. disponibles',
              style: TextStyle(color: stock > 5 ? const Color(0xFF166534) : const Color(0xFF92400E), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);
    const lightBg = Color(0xFFF4F6F9);

    return Scaffold(
      backgroundColor: lightBg,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        elevation: 1,
        title: const Text(
          'FashionStore',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF475569)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF475569)),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF475569)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CarritoCheckoutScreen(carritoItems: carritoLocal)));
                },
              ),
              if (carritoLocal.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: primaryViolet, shape: BoxShape.circle),
                    child: Text('${carritoLocal.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
          GestureDetector(
            onTap: () => _mostrarMenuUsuario(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: primaryViolet,
                    child: Icon(Icons.person, color: Colors.white, size: 15),
                  ),
                  SizedBox(width: 4),
                  Text('admin', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 12)),
                  Icon(Icons.arrow_drop_down, color: Color(0xFF475569), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del Dashboard (Exacto al Screenshot)
            Container(
              padding: const EdgeInsets.all(16),
              color: lightBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Alerta Verde
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF166534), size: 18),
                        SizedBox(width: 8),
                        Text('¡Bienvenido Administrador del Sistema!', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('¡Hola, Administrador del\nSistema!', style: TextStyle(color: Color(0xFF1E293B), fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('👋', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text('Resumen de tu negocio - Hoy', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  const SizedBox(height: 14),

                  // Fila de Filtros y Botones (Exactos al Screenshot)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: periodoSeleccionado,
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold),
                            items: ['Último año', 'Último mes', 'Última semana'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                            onChanged: (val) => setState(() => periodoSeleccionado = val!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: primaryViolet.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.sync, color: Colors.white, size: 16),
                            label: const Text('Reentrenar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✨ Modelo de Recomendación IA Reentrenado en tiempo real!'), backgroundColor: primaryViolet),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Color(0xFF1E293B), size: 20),
                          onPressed: _loadCatalog,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Contenedor de Tarjeta Blanca Principal donde va el Catálogo (Exacto al Screenshot)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Buscador Omnicanal dentro de la tarjeta blanca
                  TextField(
                    onChanged: (val) {
                      searchQuery = val;
                      _loadCatalog();
                    },
                    style: const TextStyle(color: Color(0xFF1E293B)),
                    decoration: InputDecoration(
                      hintText: 'Buscar poleras, chaquetas, vestidos...',
                      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.search, color: primaryViolet),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Grilla de Productos
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(child: CircularProgressIndicator(color: primaryViolet)),
                        )
                      : prendas.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(child: Text('No hay datos disponibles para mostrar.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14))),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: prendas.length,
                              itemBuilder: (context, index) {
                                final item = prendas[index];
                                return _buildProductCard(context, item);
                              },
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, PrendaModel item) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen y Tag AR
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item.imagenPrincipal ?? 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(Icons.checkroom, color: primaryViolet, size: 40),
                    ),
                  ),
                ),
              if (item.tieneModeloAr)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.view_in_ar, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text('3D AR FIT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.categoriaNombre.toUpperCase(),
                  style: const TextStyle(color: secondaryBlue, fontSize: 9, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  item.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bs. ${item.precioBase.toStringAsFixed(2)}',
                  style: const TextStyle(color: primaryViolet, fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),

                // Stock por Sucursales (Boton modal CU11)
                GestureDetector(
                  onTap: () => _mostrarModalDisponibilidad(context, item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF10B981), size: 12),
                            const SizedBox(width: 4),
                            Text('Stock: ${item.stockDisponibleCadena} u.', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Botones Rápidos (Reseñas CU19 / Añadir Carrito CU15)
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ResenasScreen(prendaId: item.id, prendaNombre: item.nombre)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              SizedBox(width: 2),
                              Text('Reseñas', style: TextStyle(color: Color(0xFF1E293B), fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          carritoLocal.add({
                            'variante_id': item.variantes.isNotEmpty ? item.variantes.first.varianteId : 1,
                            'nombre': item.nombre,
                            'precio': item.precioBase,
                            'cantidad': 1,
                            'talla': item.variantes.isNotEmpty ? item.variantes.first.talla : 'M',
                            'color': item.variantes.isNotEmpty ? item.variantes.first.color : 'Azul',
                            'imagen': item.imagenPrincipal,
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.nombre} agregado al carrito!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: primaryViolet,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryViolet,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

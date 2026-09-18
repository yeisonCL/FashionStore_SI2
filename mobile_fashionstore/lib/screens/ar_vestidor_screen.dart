import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'carrito_checkout_screen.dart';
import 'reservas_screen.dart';

class ArVestidorScreen extends StatefulWidget {
  const ArVestidorScreen({super.key});

  @override
  State<ArVestidorScreen> createState() => _ArVestidorScreenState();
}

class _ArVestidorScreenState extends State<ArVestidorScreen> {
  List<dynamic> prendas3d = [];
  dynamic prendaSeleccionada;
  dynamic texturaSeleccionada;
  bool isLoading = true;
  double anguloRotacion = 0.0;

  // Medidas Biométricas del Usuario (CU16)
  double alturaCm = 175;
  double pechoCm = 96;
  double cinturaCm = 82;
  double caderaCm = 98;

  Map<String, dynamic>? ajusteResultado;

  @override
  void initState() {
    super.initState();
    _loadCatalog3D();
  }

  Future<void> _loadCatalog3D() async {
    final data = await ApiService.getCatalogoAR();
    setState(() {
      prendas3d = data;
      if (data.isNotEmpty) {
        prendaSeleccionada = data[0];
        texturaSeleccionada = data[0]['texturas_disponibles']?[0];
      }
      isLoading = false;
    });
    _calcularAjuste();
  }

  Future<void> _calcularAjuste() async {
    if (prendaSeleccionada == null) return;
    final res = await ApiService.validarAjusteBiometrico(
      ropaId: prendaSeleccionada['ropa_id'] ?? 1,
      alturaCm: alturaCm,
      pechoCm: pechoCm,
      cinturaCm: cinturaCm,
      caderaCm: caderaCm,
    );
    setState(() {
      ajusteResultado = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('CU16: Vestidor Virtual AR 3D & Biometría'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryViolet))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Destacado CU16 (El más importante)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryViolet.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryViolet,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.view_in_ar, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Probador Biométrico 3D AR',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Motor de simulación de entalle corporal en tiempo real',
                                    style: TextStyle(color: secondaryBlue, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Selector de Prenda 3D
                  if (prendas3d.isNotEmpty)
                    SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: prendas3d.length,
                        itemBuilder: (context, idx) {
                          final item = prendas3d[idx];
                          bool isSel = prendaSeleccionada?['ropa_id'] == item['ropa_id'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(item['nombre'] ?? 'Prenda 3D'),
                              selected: isSel,
                              selectedColor: primaryViolet,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSel ? Colors.white : const Color(0xFF334155),
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    prendaSeleccionada = item;
                                    texturaSeleccionada = item['texturas_disponibles']?[0];
                                  });
                                  _calcularAjuste();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Visor Interactivo 3D con Modelo y Anclaje
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Simulación de Render 3D con Rotación
                        Center(
                          child: Transform.rotate(
                            angle: anguloRotacion,
                            child: AnimatedScale(
                              scale: (ajusteResultado?['escala_avatar_sugerida']?[1] ?? 1.0),
                              duration: const Duration(milliseconds: 300),
                              child: Image.network(
                                prendaSeleccionada?['imagen_uri'] ?? 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
                                height: 210,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.checkroom, color: primaryViolet, size: 90),
                              ),
                            ),
                          ),
                        ),

                        // Tag Modelo GLB & Anclaje Espacial
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.view_in_ar, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text('ARCore / SceneKit (.glb)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),

                        // Tag Anclaje Espacial
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Text(
                              'Anclaje: ${prendaSeleccionada?['posicion_anclaje'] ?? 'TORSO'}',
                              style: const TextStyle(color: Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // Botones de Giro 3D
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.rotate_left, color: primaryViolet),
                                onPressed: () => setState(() => anguloRotacion -= 0.3),
                              ),
                              IconButton(
                                icon: const Icon(Icons.rotate_right, color: primaryViolet),
                                onPressed: () => setState(() => anguloRotacion += 0.3),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text('Texturas y Colores 3D Disponibles:', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 10),

                  // Selector de Texturas / Colores 3D
                  if (prendaSeleccionada != null && prendaSeleccionada['texturas_disponibles'] != null)
                    Row(
                      children: (prendaSeleccionada['texturas_disponibles'] as List).map((tex) {
                        bool selected = texturaSeleccionada?['variante_id'] == tex['variante_id'];
                        return GestureDetector(
                          onTap: () {
                            setState(() => texturaSeleccionada = tex);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✨ Textura 3D aplicada: ${tex['color_nombre']} (Talla ${tex['talla']})'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: primaryViolet,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 14),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: selected ? primaryViolet : Colors.transparent, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(int.parse((tex['color_hex'] ?? '#3b82f6').replaceAll('#', '0xFF'))),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24),

                  // Validador Biométrico y Sliders Corporales (CU16)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.straighten, color: primaryViolet, size: 22),
                            SizedBox(width: 8),
                            Text('Ajuste Biométrico y Calce 3D', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _buildSlider('Altura del Usuario', alturaCm, 140, 210, 'cm', (val) {
                          setState(() => alturaCm = val);
                          _calcularAjuste();
                        }),
                        _buildSlider('Contorno de Pecho', pechoCm, 70, 140, 'cm', (val) {
                          setState(() => pechoCm = val);
                          _calcularAjuste();
                        }),
                        _buildSlider('Contorno de Cintura', cinturaCm, 60, 130, 'cm', (val) {
                          setState(() => cinturaCm = val);
                          _calcularAjuste();
                        }),

                        const SizedBox(height: 16),
                        if (ajusteResultado != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: primaryViolet.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: primaryViolet,
                                  child: Text(
                                    ajusteResultado!['talla_recomendada'] ?? 'M',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Precisión de Calce: ${ajusteResultado!['porcentaje_calce']}%',
                                        style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        ajusteResultado!['mensaje_ajuste'] ?? 'Ajuste biométrico ideal para tu estructura física.',
                                        style: const TextStyle(color: Color(0xFF475569), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botones de Acción: Comprar o Apartar (CU15 & CU12)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shopping_cart, size: 18),
                            label: const Text('Comprar Ahora (CU15)'),
                            style: ElevatedButton.styleFrom(backgroundColor: primaryViolet),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CarritoCheckoutScreen(carritoItems: [])));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.event_available, size: 18, color: primaryViolet),
                            label: const Text('Apartar 48h (CU12)', style: TextStyle(color: primaryViolet, fontWeight: FontWeight.bold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryViolet, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ReservasScreen()));
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildSlider(String label, double val, double min, double max, String unit, Function(double) onChanged) {
    const primaryViolet = Color(0xFF8B5CF6);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label:', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w500)),
            Text('${val.toInt()} $unit', style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          activeColor: primaryViolet,
          inactiveColor: const Color(0xFFE2E8F0),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

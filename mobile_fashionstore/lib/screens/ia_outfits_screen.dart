import 'package:flutter/material.dart';
import '../models/outfit_model.dart';
import '../services/api_service.dart';

class IaOutfitsScreen extends StatefulWidget {
  const IaOutfitsScreen({super.key});

  @override
  State<IaOutfitsScreen> createState() => _IaOutfitsScreenState();
}

class _IaOutfitsScreenState extends State<IaOutfitsScreen> {
  OutfitModel? outfitActual;
  bool isLoading = false;
  String ocasionSeleccionada = 'Casual';
  final List<String> ocasiones = ['Casual', 'Formal', 'Fiesta', 'Deportivo', 'Trabajo'];

  @override
  void initState() {
    super.initState();
    _generarOutfit();
  }

  Future<void> _generarOutfit() async {
    setState(() => isLoading = true);
    final outfit = await ApiService.generarOutfit(clienteId: '2001', ocasion: ocasionSeleccionada);
    setState(() {
      outfitActual = outfit;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('CU17: Personal Shopper IA', style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de Ocasión
            const Text('Selecciona la Ocasión del Outfit:', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ocasiones.map((oc) {
                  bool selected = ocasionSeleccionada == oc;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(oc),
                      selected: selected,
                      selectedColor: primaryViolet,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: selected ? primaryViolet : const Color(0xFFE2E8F0)),
                      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF475569), fontWeight: selected ? FontWeight.bold : FontWeight.normal),
                      onSelected: (val) {
                        if (val) {
                          setState(() => ocasionSeleccionada = oc);
                          _generarOutfit();
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            if (isLoading)
              const Center(child: CircularProgressIndicator(color: primaryViolet))
            else if (outfitActual != null) ...[
              // Tarjeta del Outfit Sugerido por IA
              Container(
                padding: const EdgeInsets.all(20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            outfitActual!.outfitNombre,
                            style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Afinidad IA: ${outfitActual!.scoreAfinidad}%',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      outfitActual!.descripcionEstilo,
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                    ),
                    const Divider(color: Color(0xFFE2E8F0), height: 24),

                    // Prenda Principal
                    if (outfitActual!.prendaPrincipal != null) ...[
                      const Text('Prenda Eje Principal:', style: TextStyle(color: primaryViolet, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      _buildPrendaTile(outfitActual!.prendaPrincipal!),
                      const SizedBox(height: 14),
                    ],

                    // Prendas Complementarias
                    const Text('Prendas Complementarias (Combo IA):', style: TextStyle(color: primaryViolet, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    ...outfitActual!.prendasComplementarias.map((p) => _buildPrendaTile(p)),

                    const Divider(color: Color(0xFFE2E8F0), height: 24),

                    // Precios y Descuento Combo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio Regular: Bs. ${outfitActual!.precioTotalOutfit.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, decoration: TextDecoration.lineThrough),
                            ),
                            Text(
                              'Combo IA (10% OFF): Bs. ${outfitActual!.precioFinalConDescuento.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFF10B981), fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_bag, size: 16),
                          label: const Text('Añadir Combo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryViolet,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🛒 ¡Outfit completo añadido al Carrito con 10% OFF!'),
                                backgroundColor: primaryViolet,
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildPrendaTile(PrendaSugerida p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              p.imagenUri ?? 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.checkroom, color: Color(0xFF8B5CF6)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.nombre, style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
                Text(p.motivoSugerencia, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
          ),
          Text('Bs. ${p.precio.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

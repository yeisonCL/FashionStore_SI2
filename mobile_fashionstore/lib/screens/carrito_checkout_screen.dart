import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarritoCheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> carritoItems;

  const CarritoCheckoutScreen({super.key, required this.carritoItems});

  @override
  State<CarritoCheckoutScreen> createState() => _CarritoCheckoutScreenState();
}

class _CarritoCheckoutScreenState extends State<CarritoCheckoutScreen> {
  String metodoPagoSeleccionado = 'qr';
  bool procesando = false;

  double get subtotal => widget.carritoItems.fold(0.0, (sum, item) => sum + (item['precio'] * item['cantidad']));
  double get descuento => subtotal > 300 ? 30.0 : 0.0;
  double get total => subtotal - descuento;

  Future<void> _finalizarCompra() async {
    setState(() => procesando = true);

    final res = await ApiService.procesarVentaDigital(
      clienteId: '1001',
      metodoPago: metodoPagoSeleccionado == 'tarjeta' ? 'Tarjeta de Crédito / Débito' : 'Pago QR',
      total: total,
      detalles: widget.carritoItems.map((item) => {
        'variante_id': item['variante_id'],
        'cantidad': item['cantidad'],
        'precio_unitario': item['precio'],
      }).toList(),
    );

    setState(() => procesando = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF8B5CF6)),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
              SizedBox(width: 10),
              Text('¡Venta Digital Procesada!', style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nro. Factura: ${res['nro_factura'] ?? 'FAC-ECOM-2026-MOB01'}', style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Nro. Comprobante: ${res['nro_comprobante'] ?? 'TRX-MOB-8841'}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              const SizedBox(height: 6),
              Text('Monto Total Pagado: Bs. ${total.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Stock físico descontado automáticamente en almacén central.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
              onPressed: () {
                Navigator.pop(context); // Cierra dialogo
                Navigator.pop(context); // Vuelve al catalogo
              },
              child: const Text('Entendido'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Procesar Venta Digital (CU15)'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: widget.carritoItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Color(0xFFCBD5E1), size: 64),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío', style: TextStyle(color: Color(0xFF1E293B), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Explorar Productos'),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumen de Prendas Seleccionadas:', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),

                  ...widget.carritoItems.map((item) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imagen'] ?? 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.checkroom, color: primaryViolet),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['nombre'], style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
                                    Text('Talla: ${item['talla']} | Color: ${item['color']} | Cant: ${item['cantidad']}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('Bs. ${(item['precio'] * item['cantidad']).toStringAsFixed(2)}', style: const TextStyle(color: primaryViolet, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ),
                      )),

                  const SizedBox(height: 20),
                  const Text('Selecciona Pasarela Electrónica de Pago:', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),

                  // Selector de métodos de pago
                  GestureDetector(
                    onTap: () => setState(() => metodoPagoSeleccionado = 'qr'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: metodoPagoSeleccionado == 'qr' ? primaryViolet.withValues(alpha: 0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: metodoPagoSeleccionado == 'qr' ? primaryViolet : const Color(0xFFE2E8F0),
                          width: metodoPagoSeleccionado == 'qr' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.qr_code_2, color: Color(0xFF10B981), size: 30),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pago Rápido con QR Simple (Instantáneo)', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Genera código QR compatible con cualquier banco', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                              ],
                            ),
                          ),
                          if (metodoPagoSeleccionado == 'qr') const Icon(Icons.check_circle, color: primaryViolet),
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => metodoPagoSeleccionado = 'tarjeta'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: metodoPagoSeleccionado == 'tarjeta' ? primaryViolet.withValues(alpha: 0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: metodoPagoSeleccionado == 'tarjeta' ? primaryViolet : const Color(0xFFE2E8F0),
                          width: metodoPagoSeleccionado == 'tarjeta' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.credit_card, color: primaryViolet, size: 30),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tarjeta de Crédito / Débito (Pasarela Stripe)', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Visa, Mastercard, Cybersource cifrado de 256 bits', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                              ],
                            ),
                          ),
                          if (metodoPagoSeleccionado == 'tarjeta') const Icon(Icons.check_circle, color: primaryViolet),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:', style: TextStyle(color: Color(0xFF64748B))),
                            Text('Bs. ${subtotal.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF1E293B))),
                          ],
                        ),
                        if (descuento > 0) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Descuento E-commerce (Promo):', style: TextStyle(color: Color(0xFF10B981))),
                              Text('- Bs. ${descuento.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const Divider(color: Color(0xFFE2E8F0), height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL A PAGAR:', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Bs. ${total.toStringAsFixed(2)}', style: const TextStyle(color: primaryViolet, fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryViolet, Color(0xFFA855F7)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: procesando ? null : _finalizarCompra,
                        child: procesando
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Confirmar y Pagar Ahora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

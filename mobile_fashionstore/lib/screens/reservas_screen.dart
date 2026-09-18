import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  bool creandoReserva = false;
  Map<String, dynamic>? ticketReserva;

  Future<void> _crearReserva() async {
    setState(() => creandoReserva = true);
    final res = await ApiService.crearReserva(
      sucursalId: 1,
      varianteId: 1,
      cantidad: 1,
      clienteCi: '2001',
    );

    setState(() {
      ticketReserva = res;
      creandoReserva = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Apartado Web-to-Store (CU12)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: secondaryBlue),
                boxShadow: [
                  BoxShadow(
                    color: secondaryBlue.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.event_available, color: secondaryBlue, size: 24),
                      SizedBox(width: 10),
                      Text('Apartado de Prenda por 48 Horas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Aparta prendas digitalmente para probártelas y abonarlas en la sucursal física de tu preferencia sin compromiso previo.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton.icon(
                        icon: creandoReserva
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.qr_code, color: Colors.white),
                        label: Text(
                          creandoReserva ? 'Generando Ticket...' : 'Crear Nueva Reserva de Prueba',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: creandoReserva ? null : _crearReserva,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (ticketReserva != null) ...[
              const Text('Ticket de Reserva Generado:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Código: ${ticketReserva!['codigo_reserva'] ?? 'RES-0001'}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('ACTIVA 48H', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 24),
                    const Text('Prenda: Chaqueta Denim Vintage (Talla M)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Sucursal de Retiro: ${ticketReserva!['sucursal_nombre'] ?? 'Sucursal Central'}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Vence: ${ticketReserva!['fec_limite_retiro'] ?? 'En 48 Horas'}', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

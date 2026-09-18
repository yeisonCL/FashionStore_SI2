import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReportesVozScreen extends StatefulWidget {
  const ReportesVozScreen({super.key});

  @override
  State<ReportesVozScreen> createState() => _ReportesVozScreenState();
}

class _ReportesVozScreenState extends State<ReportesVozScreen> {
  final TextEditingController comandoController = TextEditingController(text: 'Mostrar ventas por sucursal');
  bool escuchando = false;
  bool procesando = false;
  Map<String, dynamic>? resultadoReporte;

  final List<String> comandosSugeridos = [
    'Mostrar ventas por sucursal',
    'Productos más vendidos de la semana',
    'Ventas canal digital vs tiendas POS',
    'Stock crítico en almacenes',
  ];

  Future<void> _ejecutarComando([String? texto]) async {
    final consulta = texto ?? comandoController.text.trim();
    if (consulta.isEmpty) return;

    setState(() {
      procesando = true;
      comandoController.text = consulta;
    });

    final res = await ApiService.procesarComandoVoz(consulta);

    setState(() {
      resultadoReporte = res;
      procesando = false;
    });
  }

  void _simularMicrofono() {
    setState(() => escuchando = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => escuchando = false);
        _ejecutarComando('Reporte de ventas de prendas de este mes');
      }
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
        title: const Text('Reportes por Voz NLP (CU18)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Micrófono e Input de Voz
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryViolet.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: primaryViolet.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _simularMicrofono,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: escuchando ? [Colors.red, Colors.orange] : [primaryViolet, secondaryBlue],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (escuchando ? Colors.red : primaryViolet).withValues(alpha: 0.4),
                            blurRadius: escuchando ? 30 : 15,
                            spreadRadius: escuchando ? 6 : 2,
                          )
                        ],
                      ),
                      child: Icon(
                        escuchando ? Icons.graphic_eq : Icons.mic,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    escuchando ? 'Escuchando comando de voz...' : 'Toca el micrófono para dictar comando por voz',
                    style: TextStyle(
                      color: escuchando ? Colors.redAccent : Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: comandoController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'O escribe tu consulta en lenguaje natural...',
                      hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: primaryViolet),
                        onPressed: () => _ejecutarComando(),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text('Comandos NLP Frecuentes:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: comandosSugeridos.map((cmd) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(cmd, style: const TextStyle(color: Colors.white, fontSize: 11)),
                    backgroundColor: const Color(0xFF1E293B),
                    side: const BorderSide(color: Color(0xFF334155)),
                    onPressed: () => _ejecutarComando(cmd),
                  ),
                )).toList(),
              ),
            ),

            const SizedBox(height: 24),

            if (procesando)
              const Center(child: CircularProgressIndicator(color: primaryViolet))
            else if (resultadoReporte != null) ...[
              const Text('Resultado del Análisis NLP:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: secondaryBlue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: secondaryBlue, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resultadoReporte!['interpretacion'] ?? 'Procesamiento NLP',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 24),

                    // Tarjetas KPI
                    if (resultadoReporte!['kpis'] != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildKpiCard(
                              'Ventas Totales',
                              'Bs. ${resultadoReporte!['kpis']['total_ventas_bs'] ?? '14,850.50'}',
                              Icons.monetization_on,
                              primaryViolet,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildKpiCard(
                              'Canal Digital',
                              '${resultadoReporte!['kpis']['canal_digital_pct'] ?? '68.5%'}',
                              Icons.devices,
                              secondaryBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Gráfico Simulado de Datos
                    const Text('Desglose por Sucursal:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 10),

                    _buildBarRow('Sucursal Central', 0.8, 'Bs. 6,200.00', primaryViolet),
                    _buildBarRow('Sucursal Equipetrol', 0.6, 'Bs. 4,850.50', secondaryBlue),
                    _buildBarRow('Sucursal Ventura Mall', 0.45, 'Bs. 3,800.00', const Color(0xFF10B981)),

                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: secondaryBlue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              resultadoReporte!['mensaje'] ?? 'Generado automáticamente mediante comandos de voz.',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          )
                        ],
                      ),
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

  Widget _buildKpiCard(String titulo, String valor, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(titulo, style: const TextStyle(color: Colors.white60, fontSize: 10))),
            ],
          ),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildBarRow(String etiqueta, double pct, String monto, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(etiqueta, style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text(monto, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          )
        ],
      ),
    );
  }
}

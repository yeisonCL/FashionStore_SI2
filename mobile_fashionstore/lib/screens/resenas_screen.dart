import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';

class ResenasScreen extends StatefulWidget {
  final int prendaId;
  final String prendaNombre;

  const ResenasScreen({
    super.key,
    required this.prendaId,
    required this.prendaNombre,
  });

  @override
  State<ResenasScreen> createState() => _ResenasScreenState();
}

class _ResenasScreenState extends State<ResenasScreen> {
  double estrellasSeleccionadas = 5;
  final TextEditingController comentarioController = TextEditingController();
  bool enviando = false;

  final List<Map<String, dynamic>> resenasMock = [
    {
      'cliente': 'María Choque',
      'estrellas': 5,
      'comentario': 'Excelente calidad de tela denim, la talla M me quedó perfecta. Muy recomendado.',
      'fecha': '2026-09-14',
    },
    {
      'cliente': 'Carlos L.',
      'estrellas': 4,
      'comentario': 'Buena prenda y rápido el retiro en la sucursal Central.',
      'fecha': '2026-09-12',
    }
  ];

  Future<void> _publicarResena() async {
    if (comentarioController.text.trim().isEmpty) return;

    setState(() => enviando = true);
    await ApiService.publicarResena(
      ropaId: widget.prendaId,
      clienteCi: '2001',
      estrellas: estrellasSeleccionadas.toInt(),
      comentario: comentarioController.text,
    );

    setState(() {
      resenasMock.insert(0, {
        'cliente': 'admin (Tú)',
        'estrellas': estrellasSeleccionadas.toInt(),
        'comentario': comentarioController.text,
        'fecha': '2026-09-16',
      });
      comentarioController.clear();
      enviando = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ ¡Reseña publicada con éxito en PostgreSQL!'),
          backgroundColor: Color(0xFF8B5CF6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Reseñas — ${widget.prendaNombre}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulario Publicar Reseña
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Escribir una Opinión sobre la Prenda:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),

                  RatingBar.builder(
                    initialRating: estrellasSeleccionadas,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 32,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() => estrellasSeleccionadas = rating);
                    },
                  ),

                  const SizedBox(height: 14),
                  TextField(
                    controller: comentarioController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Comparte tu experiencia de entalle, calidad de tela y calce biométrico...',
                      hintStyle: const TextStyle(color: Colors.white54, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [primaryViolet, secondaryBlue]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton.icon(
                        icon: enviando
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send, color: Colors.white),
                        label: Text(
                          enviando ? 'Publicando...' : 'Publicar Reseña Pública',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: enviando ? null : _publicarResena,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de Opiniones de Clientes
            const Text('Opiniones de la Comunidad de Clientes:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            ...resenasMock.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r['cliente'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                size: 14,
                                color: i < r['estrellas'] ? Colors.amber : Colors.white24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(r['comentario'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(r['fecha'], style: const TextStyle(color: secondaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

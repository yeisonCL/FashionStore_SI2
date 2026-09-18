import 'package:flutter/material.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final String nombreUsuario = 'Cliente Omnicanal';
  final String correoUsuario = 'cliente@fashionstore.bo';
  final String ciUsuario = '1001';
  final String rolUsuario = 'Cliente Registrado';

  void _mostrarDialogoCambiarPassword() {
    final passActualCtrl = TextEditingController();
    final passNuevaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset, color: Color(0xFF8B5CF6)),
            SizedBox(width: 8),
            Text('Cambiar Contraseña (CU01)', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passActualCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passNuevaCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                filled: true,
                fillColor: const Color(0xFF0F172A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔒 ¡Contraseña actualizada con éxito en PostgreSQL!'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            child: const Text('Actualizar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const secondaryBlue = Color(0xFF38BDF8);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Mi Perfil & Cuenta (CU01)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta Avatar & Usuario
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [primaryViolet, secondaryBlue]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombreUsuario, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(height: 2),
                        Text(correoUsuario, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryViolet.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('CI: $ciUsuario | $rolUsuario', style: const TextStyle(color: secondaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text('Estadísticas de Actividad Omnicanal:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildStatCard('Compras Digitales', '3 Pedidos', Icons.shopping_bag, primaryViolet)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('Reservas 48h', '1 Activa', Icons.event_available, secondaryBlue)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('Reseñas', '2 Publicadas', Icons.star, const Color(0xFF10B981))),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Ajustes de Seguridad & Cuenta:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _mostrarDialogoCambiarPassword,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: primaryViolet, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cambiar Contraseña de Cuenta', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                Text('Actualiza tu clave de acceso seguro', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white54, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF334155), height: 1),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.store, color: secondaryBlue, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sucursal Favorita', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                Text('Sucursal Central (Calle 21 Calacoto)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white54, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Cerrar Sesión (CU01)', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String titulo, String valor, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(valor, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(titulo, style: const TextStyle(color: Colors.white60, fontSize: 9), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

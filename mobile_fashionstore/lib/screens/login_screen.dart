import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController(text: 'admin');
  final TextEditingController passwordController = TextEditingController(text: 'admin123');
  bool cargando = false;
  bool ocultarPassword = true;
  bool recordarme = true;

  Future<void> _iniciarSesion() async {
    if (usuarioController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa usuario y contraseña')),
      );
      return;
    }

    setState(() => cargando = true);
    final res = await ApiService.login(
      usuarioController.text,
      passwordController.text,
    );
    setState(() => cargando = false);

    if (res['success'] == true) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Error al iniciar sesión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryViolet = Color(0xFF8B5CF6);
    const deepPurpleBg = Color(0xFF1E1B4B);

    return Scaffold(
      backgroundColor: deepPurpleBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Icono Tienda Morado con sombra
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryViolet, Color(0xFFA855F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryViolet.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: const Icon(Icons.store, color: Colors.white, size: 40),
                ),
              ),
              const SizedBox(height: 24),

              // Tarjeta Blanca Principal (Idéntica a Screenshot 1)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ingresa a tu sistema [Desarrollo Local]',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo Usuario o Correo
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Usuario o Correo', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: usuarioController,
                      style: const TextStyle(color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: 'admin',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: const Color(0xFFEFF6FF),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Contraseña & Olvidaste contraseña
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Contraseña', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 13)),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: passwordController,
                      obscureText: ocultarPassword,
                      style: const TextStyle(color: Color(0xFF1E293B)),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF64748B)),
                        suffixIcon: IconButton(
                          icon: Icon(ocultarPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF64748B)),
                          onPressed: () => setState(() => ocultarPassword = !ocultarPassword),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFEFF6FF),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Checkbox Recordarme
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: recordarme,
                            activeColor: primaryViolet,
                            onChanged: (val) => setState(() => recordarme = val ?? true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Recordarme', style: TextStyle(color: Color(0xFF475569), fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Botón Morado Ingresar al Sistema
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryViolet, Color(0xFFA855F7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryViolet.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ElevatedButton.icon(
                          icon: cargando
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.login, color: Colors.white),
                          label: Text(
                            cargando ? 'Ingresando...' : 'Ingresar al Sistema',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: cargando ? null : _iniciarSesion,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Caja Azul Infocredenciales por defecto
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Color(0xFF3B82F6), size: 18),
                              SizedBox(width: 8),
                              Text('Credenciales por defecto:', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 13)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Usuario: ', style: TextStyle(color: Color(0xFF475569), fontSize: 12)),
                              Text('admin', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Text('Contraseña: ', style: TextStyle(color: Color(0xFF475569), fontSize: 12)),
                              Text('admin123', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
                      },
                      child: const Text('← Ir a Inicio y Planes\nRegistrar Nueva Empresa', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569), fontSize: 12)),
                    ),

                    const Divider(color: Color(0xFFE2E8F0), height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta? ', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
                          },
                          child: const Text('Crear una cuenta', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('© 2026 FashionStore - Sistema de Gestión', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

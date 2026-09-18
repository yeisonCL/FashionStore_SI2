class ReservaModel {
  final int id;
  final String codigoReserva;
  final String fechaReserva;
  final String fechaVencimiento;
  final String estado;
  final String sucursalNombre;
  final String prendaNombre;
  final String talla;
  final String color;
  final int cantidad;
  final double precioTotal;

  ReservaModel({
    required this.id,
    required this.codigoReserva,
    required this.fechaReserva,
    required this.fechaVencimiento,
    required this.estado,
    required this.sucursalNombre,
    required this.prendaNombre,
    required this.talla,
    required this.color,
    required this.cantidad,
    required this.precioTotal,
  });

  factory ReservaModel.fromJson(Map<String, dynamic> json) {
    return ReservaModel(
      id: json['id'] ?? 1,
      codigoReserva: json['codigo_reserva'] ?? 'RES-0001',
      fechaReserva: json['fecha_reserva'] ?? '2026-09-14',
      fechaVencimiento: json['fecha_vencimiento'] ?? '2026-09-16',
      estado: json['estado'] ?? 'PENDIENTE_RETIRO',
      sucursalNombre: json['sucursal_nombre'] ?? 'Sucursal Central',
      prendaNombre: json['prenda_nombre'] ?? 'Prenda Reservada',
      talla: json['talla'] ?? 'M',
      color: json['color'] ?? 'Azul',
      cantidad: json['cantidad'] ?? 1,
      precioTotal: (json['precio_total'] ?? json['total'] ?? 150.0).toDouble(),
    );
  }
}

class ResenaModel {
  final int id;
  final int ropaId;
  final String clienteCi;
  final String clienteNombre;
  final int puntuacionEstrellas;
  final String comentario;
  final String fecha;

  ResenaModel({
    required this.id,
    required this.ropaId,
    required this.clienteCi,
    required this.clienteNombre,
    required this.puntuacionEstrellas,
    required this.comentario,
    required this.fecha,
  });

  factory ResenaModel.fromJson(Map<String, dynamic> json) {
    return ResenaModel(
      id: json['id'] ?? 1,
      ropaId: json['ropa_id'] ?? 1,
      clienteCi: json['cliente_ci']?.toString() ?? '2001',
      clienteNombre: json['cliente_nombre'] ?? 'Cliente Verificado',
      puntuacionEstrellas: json['puntuacion_estrellas'] ?? 5,
      comentario: json['comentario'] ?? 'Excelente producto de gran calidad.',
      fecha: json['fecha'] ?? '2026-09-14',
    );
  }
}

class ResumenCalificacionesModel {
  final int ropaId;
  final String ropaNombre;
  final double promedioCalificacion;
  final int totalResenas;
  final double porcentajeRecomendacion;
  final List<ResenaModel> ultimasResenas;

  ResumenCalificacionesModel({
    required this.ropaId,
    required this.ropaNombre,
    required this.promedioCalificacion,
    required this.totalResenas,
    required this.porcentajeRecomendacion,
    required this.ultimasResenas,
  });

  factory ResumenCalificacionesModel.fromJson(Map<String, dynamic> json) {
    var list = (json['ultimas_resenas'] as List? ?? [])
        .map((r) => ResenaModel.fromJson(r))
        .toList();

    return ResumenCalificacionesModel(
      ropaId: json['ropa_id'] ?? 1,
      ropaNombre: json['ropa_nombre'] ?? 'Prenda',
      promedioCalificacion: (json['promedio_calificacion'] ?? 4.8).toDouble(),
      totalResenas: json['total_resenas'] ?? 10,
      porcentajeRecomendacion: (json['porcentaje_recomendacion'] ?? 95.0).toDouble(),
      ultimasResenas: list,
    );
  }
}

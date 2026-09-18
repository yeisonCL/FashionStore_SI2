class PrendaSugerida {
  final int ropaId;
  final String nombre;
  final String categoria;
  final double precio;
  final String? imagenUri;
  final String motivoSugerencia;

  PrendaSugerida({
    required this.ropaId,
    required this.nombre,
    required this.categoria,
    required this.precio,
    this.imagenUri,
    required this.motivoSugerencia,
  });

  factory PrendaSugerida.fromJson(Map<String, dynamic> json) {
    return PrendaSugerida(
      ropaId: json['ropa_id'] ?? 1,
      nombre: json['nombre'] ?? 'Prenda Sugerida',
      categoria: json['categoria'] ?? 'General',
      precio: (json['precio'] ?? 100.0).toDouble(),
      imagenUri: json['imagen_uri'] ?? 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0',
      motivoSugerencia: json['motivo_sugerencia'] ?? 'Combinación armónica recomendada',
    );
  }
}

class OutfitModel {
  final int? id;
  final String outfitNombre;
  final String descripcionEstilo;
  final String ocasion;
  final double scoreAfinidad;
  final String tipoAlgoritmo;
  final PrendaSugerida? prendaPrincipal;
  final List<PrendaSugerida> prendasComplementarias;
  final double precioTotalOutfit;
  final double descuentoCombo;
  final double precioFinalConDescuento;

  OutfitModel({
    this.id,
    required this.outfitNombre,
    required this.descripcionEstilo,
    required this.ocasion,
    required this.scoreAfinidad,
    required this.tipoAlgoritmo,
    this.prendaPrincipal,
    required this.prendasComplementarias,
    required this.precioTotalOutfit,
    required this.descuentoCombo,
    required this.precioFinalConDescuento,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    var comp = (json['prendas_complementarias'] as List? ?? [])
        .map((p) => PrendaSugerida.fromJson(p))
        .toList();

    return OutfitModel(
      id: json['id'],
      outfitNombre: json['outfit_nombre'] ?? 'Outfit Recomendado IA',
      descripcionEstilo: json['descripcion_estilo'] ?? 'Conjunto estilístico armonizado por IA.',
      ocasion: json['ocasion'] ?? 'Casual',
      scoreAfinidad: (json['score_afinidad'] ?? 95.0).toDouble(),
      tipoAlgoritmo: json['tipo_algoritmo'] ?? 'PERSONAL_SHOPPER_IA',
      prendaPrincipal: json['prenda_principal'] != null
          ? PrendaSugerida.fromJson(json['prenda_principal'])
          : null,
      prendasComplementarias: comp,
      precioTotalOutfit: (json['precio_total_outfit'] ?? 300.0).toDouble(),
      descuentoCombo: (json['descuento_combo_aplicable'] ?? 30.0).toDouble(),
      precioFinalConDescuento: (json['precio_final_con_descuento'] ?? 270.0).toDouble(),
    );
  }
}

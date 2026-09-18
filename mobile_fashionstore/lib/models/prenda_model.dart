class StockSucursal {
  final int sucursalId;
  final String sucursalNombre;
  final String ciudad;
  final int stockFisico;
  final int stockReservado;
  final int stockDisponible;
  final String estadoStock;

  StockSucursal({
    required this.sucursalId,
    required this.sucursalNombre,
    required this.ciudad,
    required this.stockFisico,
    required this.stockReservado,
    required this.stockDisponible,
    required this.estadoStock,
  });

  factory StockSucursal.fromJson(Map<String, dynamic> json) {
    return StockSucursal(
      sucursalId: json['sucursal_id'] ?? 1,
      sucursalNombre: json['sucursal_nombre'] ?? 'Sucursal',
      ciudad: json['ciudad'] ?? 'Santa Cruz',
      stockFisico: json['stock_fisico'] ?? 0,
      stockReservado: json['stock_reservado'] ?? 0,
      stockDisponible: json['stock_disponible'] ?? 0,
      estadoStock: json['estado_stock'] ?? 'DISPONIBLE',
    );
  }
}

class VariantePrenda {
  final int varianteId;
  final String sku;
  final String talla;
  final String color;
  final String colorHex;
  final double precio;
  final int stockDisponibleTotal;
  final List<StockSucursal> disponibilidadSucursales;

  VariantePrenda({
    required this.varianteId,
    required this.sku,
    required this.talla,
    required this.color,
    required this.colorHex,
    required this.precio,
    required this.stockDisponibleTotal,
    required this.disponibilidadSucursales,
  });

  factory VariantePrenda.fromJson(Map<String, dynamic> json) {
    var sucs = (json['disponibilidad_sucursales'] as List? ?? [])
        .map((s) => StockSucursal.fromJson(s))
        .toList();

    return VariantePrenda(
      varianteId: json['variante_id'] ?? json['id'] ?? 1,
      sku: json['sku'] ?? json['cod_barra'] ?? 'SKU-001',
      talla: json['talla'] is Map ? (json['talla']['medida'] ?? 'Única') : (json['talla']?.toString() ?? 'M'),
      color: json['color'] is Map ? (json['color']['nombre'] ?? 'Estándar') : (json['color']?.toString() ?? 'Estándar'),
      colorHex: json['codigo_hex'] ?? json['color_hex'] ?? '#3b82f6',
      precio: (json['precio_especifico'] ?? json['precio'] ?? 0.0).toDouble(),
      stockDisponibleTotal: json['stock_disponible_total'] ?? 10,
      disponibilidadSucursales: sucs,
    );
  }
}

class PrendaModel {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final double precioBase;
  final double? precioPromocional;
  final double? descuentoPct;
  final int categoriaId;
  final String categoriaNombre;
  final String? imagenPrincipal;
  final String? modelo3dUri;
  final bool tieneModeloAr;
  final int stockDisponibleCadena;
  final bool disponibleEnCadena;
  final double calificacionPromedio;
  final int totalResenas;
  final List<VariantePrenda> variantes;

  PrendaModel({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.precioBase,
    this.precioPromocional,
    this.descuentoPct,
    required this.categoriaId,
    required this.categoriaNombre,
    this.imagenPrincipal,
    this.modelo3dUri,
    required this.tieneModeloAr,
    required this.stockDisponibleCadena,
    required this.disponibleEnCadena,
    required this.calificacionPromedio,
    required this.totalResenas,
    required this.variantes,
  });

  factory PrendaModel.fromJson(Map<String, dynamic> json) {
    var vars = (json['variantes'] as List? ?? [])
        .map((v) => VariantePrenda.fromJson(v))
        .toList();

    String? rawImg = json['imagen_principal'] ?? json['imagen_uri'];
    if (rawImg != null && rawImg.startsWith('/static/')) {
      rawImg = 'http://localhost:8000$rawImg';
    } else if (rawImg == null || rawImg.isEmpty) {
      rawImg = 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0';
    }

    String? rawModel = json['modelo_3d_uri'];
    if (rawModel != null && rawModel.startsWith('/static/')) {
      rawModel = 'http://localhost:8000$rawModel';
    }

    return PrendaModel(
      id: json['id'] ?? 1,
      codigo: json['codigo'] ?? 'ROPA-${json['id'] ?? 1}',
      nombre: json['nombre'] ?? 'Prenda FashionStore',
      descripcion: json['descripcion'] ?? 'Prenda confeccionada con tejidos premium de alta durabilidad.',
      precioBase: (json['precio_base'] ?? json['precio'] ?? 150.0).toDouble(),
      precioPromocional: json['precio_promocional'] != null ? (json['precio_promocional']).toDouble() : null,
      descuentoPct: json['descuento_aplicado_pct'] != null ? (json['descuento_aplicado_pct']).toDouble() : null,
      categoriaId: json['id_categoria'] ?? json['categoria_id'] ?? 1,
      categoriaNombre: json['categoria_nombre'] ?? (json['categoria'] is Map ? json['categoria']['nombre'] : 'General'),
      imagenPrincipal: rawImg,
      modelo3dUri: rawModel,
      tieneModeloAr: json['tiene_modelo_ar'] ?? json['tiene_ar'] ?? (rawModel != null),
      stockDisponibleCadena: json['stock_disponible_cadena'] ?? json['stock_disponible_total'] ?? 10,
      disponibleEnCadena: json['disponible_en_cadena'] ?? true,
      calificacionPromedio: (json['calificacion_promedio'] ?? 4.8).toDouble(),
      totalResenas: json['total_resenas'] ?? 12,
      variantes: vars,
    );
  }
}

//!INC Local Scripts.EAConstants-JScript
/*
 * ==============================================================================
 * PROYECTO: Sistema de Información (SI2) - Arquitectura BCE (3 Capas)
 * ITERACIÓN: Iteración 2 (Ciclo 2 - Gestión Comercial, Inventario y Catálogo)
 * CASOS DE USO INCLUIDOS:
 *   - CU08: Gestionar promociones y descuentos (Web)
 *   - CU09: Gestionar inventario físico local (Web)
 *   - CU10: Gestionar traspasos entre sucursales (Web)
 *   - CU11: Consultar catálogo y disponibilidad en tiempo real (Web/Móvil)
 *   - CU12: Gestionar reservas Web-to-Store (Web/Móvil)
 *
 * DESCRIPCIÓN: Script en JScript para Enterprise Architect.
 *              Crea una carpeta raíz 'Iteracion 2' y dentro subcarpetas para
 *              cada Caso de Uso con su Diagrama de Secuencia, Líneas de Vida
 *              (Actor, UI, Control, Entity), Fragmentos (alt/opt) y Mensajes.
 * ==============================================================================
 */

// Función auxiliar para registrar mensajes de secuencia
function registrarMensaje(origen, destino, nombreMensaje, esRetorno, seqCounter) {
    var con = origen.Connectors.AddNew(nombreMensaje, "Sequence");
    con.SupplierID = destino.ElementID;
    con.SequenceNo = seqCounter;
    if (esRetorno) {
        con.Stereotype = "return";
        con.SubType = "Return";
    } else {
        con.SubType = "SynchCall";
    }
    con.Update();
    origen.Connectors.Refresh();
    return con;
}

// Función auxiliar para posicionar Lifelines en el diagrama
function posicionarLifelines(diagram, lifelines) {
    var startX = 60;
    var elemWidth = 120;
    var gapX = 80;
    var topY = -30;
    var bottomY = -560;

    for (var i = 0; i < lifelines.length; i++) {
        var left = startX + (i * (elemWidth + gapX));
        var right = left + elemWidth;
        var coords = "l=" + left + ";r=" + right + ";t=" + topY + ";b=" + bottomY + ";";
        
        var diagObj = diagram.DiagramObjects.AddNew(coords, "");
        diagObj.ElementID = lifelines[i].ElementID;
        diagObj.Update();
    }
}

// ==============================================================================
// 1. CU08: Gestionar Promociones y Descuentos
// ==============================================================================
function generarCU08(parentPkg) {
    Repository.WriteOutput("Script", "-> Generando CU08: Gestionar promociones y descuentos...", 0);
    var pkg = parentPkg.Packages.AddNew("CU08 - Gestionar Promociones y Descuentos", "");
    pkg.Update();

    var diagram = pkg.Diagrams.AddNew("CU08 Gestionar promociones y descuentos", "Sequence");
    diagram.Update();

    // Lifelines BCE
    var elemActor = pkg.Elements.AddNew("Administrador", "Actor");
    elemActor.Update();

    var elemUI = pkg.Elements.AddNew("UI Promociones", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    var elemCtrl = pkg.Elements.AddNew("PromocionController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    var elemEntity = pkg.Elements.AddNew("Promocion", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    pkg.Elements.Refresh();
    posicionarLifelines(diagram, [elemActor, elemUI, elemCtrl, elemEntity]);

    // Fragmentos
    var fragAlt = pkg.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Fechas o porcentaje inválidos]\n--\n[Datos válidos]";
    fragAlt.Update();
    var dAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-220;b=-390;", "");
    dAlt.ElementID = fragAlt.ElementID;
    dAlt.Update();

    var fragOpt = pkg.Elements.AddNew("opt", "InteractionFragment");
    fragOpt.Stereotype = "opt";
    fragOpt.Notes = "[Desactivar o eliminar promoción]";
    fragOpt.Update();
    var dOpt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-400;b=-510;", "");
    dOpt.ElementID = fragOpt.ElementID;
    dOpt.Update();

    diagram.DiagramObjects.Refresh();

    // Mensajes
    var seq = 1;
    registrarMensaje(elemActor, elemUI, "1. Acceder a módulo de promociones()", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "2. Listar promociones activas()", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "2.1. Consultar promociones y vigencias()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Lista de promociones", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Mostrar tabla de promociones()", true, seq++);
    registrarMensaje(elemActor, elemUI, "3. Crear nueva campaña(nombre, desc%, fechas, categoriaId)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "4. Registrar promoción(datosPromo)", false, seq++);
    registrarMensaje(elemCtrl, elemCtrl, "4.1. Validar fechas y porcentaje()", false, seq++);

    // alt: inválido
    registrarMensaje(elemCtrl, elemUI, "Notificar error de validación()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar alerta de error en formulario()", true, seq++);

    // alt: válido
    registrarMensaje(elemCtrl, elemEntity, "5. Guardar promoción()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Promoción creada exitosamente", true, seq++);
    registrarMensaje(elemCtrl, elemEntity, "6. Aplicar descuento a catálogo()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Precios recalculados", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "7. Notificar campaña activada()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar confirmación de éxito()", true, seq++);

    // opt: desactivar
    registrarMensaje(elemActor, elemUI, "8. Desactivar promoción(promoId)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "Desactivar campaña(promoId)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "Actualizar estado inactivo()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Estado actualizado", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Mostrar promoción inactiva()", true, seq++);

    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
}

// ==============================================================================
// 2. CU09: Gestionar Inventario Físico Local
// ==============================================================================
function generarCU09(parentPkg) {
    Repository.WriteOutput("Script", "-> Generando CU09: Gestionar inventario físico local...", 0);
    var pkg = parentPkg.Packages.AddNew("CU09 - Gestionar Inventario Físico Local", "");
    pkg.Update();

    var diagram = pkg.Diagrams.AddNew("CU09 Gestionar inventario físico local", "Sequence");
    diagram.Update();

    // Lifelines BCE
    var elemActor = pkg.Elements.AddNew("Encargado de Sucursal", "Actor");
    elemActor.Update();

    var elemUI = pkg.Elements.AddNew("UI Inventario Local", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    var elemCtrl = pkg.Elements.AddNew("InventarioController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    var elemEntity = pkg.Elements.AddNew("InventarioSucursal", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    pkg.Elements.Refresh();
    posicionarLifelines(diagram, [elemActor, elemUI, elemCtrl, elemEntity]);

    // Fragmentos
    var fragAlt = pkg.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Cantidad <= 0 o variante inexistente]\n--\n[Ingreso válido]";
    fragAlt.Update();
    var dAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-210;b=-370;", "");
    dAlt.ElementID = fragAlt.ElementID;
    dAlt.Update();

    var fragOpt = pkg.Elements.AddNew("opt", "InteractionFragment");
    fragOpt.Stereotype = "opt";
    fragOpt.Notes = "[Ajuste por merma / daño físico]";
    fragOpt.Update();
    var dOpt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-380;b=-500;", "");
    dOpt.ElementID = fragOpt.ElementID;
    dOpt.Update();

    diagram.DiagramObjects.Refresh();

    // Mensajes
    var seq = 1;
    registrarMensaje(elemActor, elemUI, "1. Consultar stock sucursal()", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "2. Obtener inventario(sucursalId)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "2.1. Consultar existencias por prenda y talla()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Lista de existencias y variantes", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Renderizar tabla de inventario()", true, seq++);
    registrarMensaje(elemActor, elemUI, "3. Registrar entrada mercadería(varianteId, cantidad)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "4. Procesar ingreso stock(datosEntrada)", false, seq++);

    // alt: cantidad inválida
    registrarMensaje(elemCtrl, elemUI, "Notificar error en cantidades()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar alerta de validación()", true, seq++);

    // alt: ingreso válido
    registrarMensaje(elemCtrl, elemEntity, "5. Incrementar stock y registrar kardex()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Stock actualizado exitosamente", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "6. Confirmar registro de entrada()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar inventario actualizado()", true, seq++);

    // opt: ajuste por merma
    registrarMensaje(elemActor, elemUI, "7. Registrar ajuste por merma(varianteId, cantidad, motivo)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "Procesar ajuste inventario()", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "Descontar stock y registrar motivo kardex()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Ajuste completado", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Confirmar ajuste de inventario()", true, seq++);

    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
}

// ==============================================================================
// 3. CU10: Gestionar Traspasos entre Sucursales
// ==============================================================================
function generarCU10(parentPkg) {
    Repository.WriteOutput("Script", "-> Generando CU10: Gestionar traspasos entre sucursales...", 0);
    var pkg = parentPkg.Packages.AddNew("CU10 - Gestionar Traspasos entre Sucursales", "");
    pkg.Update();

    var diagram = pkg.Diagrams.AddNew("CU10 Gestionar traspasos entre sucursales", "Sequence");
    diagram.Update();

    // Lifelines BCE
    var elemActor = pkg.Elements.AddNew("Encargado de Sucursal", "Actor");
    elemActor.Update();

    var elemUI = pkg.Elements.AddNew("UI Traspasos", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    var elemCtrl = pkg.Elements.AddNew("TraspasoController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    var elemEntity = pkg.Elements.AddNew("Traspaso", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    pkg.Elements.Refresh();
    posicionarLifelines(diagram, [elemActor, elemUI, elemCtrl, elemEntity]);

    // Fragmentos
    var fragAlt = pkg.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Stock insuficiente en origen]\n--\n[Stock disponible]";
    fragAlt.Update();
    var dAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-180;b=-350;", "");
    dAlt.ElementID = fragAlt.ElementID;
    dAlt.Update();

    var fragOpt = pkg.Elements.AddNew("opt", "InteractionFragment");
    fragOpt.Stereotype = "opt";
    fragOpt.Notes = "[Confirmar recepción en sucursal destino]";
    fragOpt.Update();
    var dOpt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-360;b=-480;", "");
    dOpt.ElementID = fragOpt.ElementID;
    dOpt.Update();

    diagram.DiagramObjects.Refresh();

    // Mensajes
    var seq = 1;
    registrarMensaje(elemActor, elemUI, "1. Solicitar nuevo traspaso(origenId, destinoId, items)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "2. Crear solicitud traspaso(datosTraspaso)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "2.1. Validar disponibilidad stock origen()", false, seq++);

    // alt: insuficiente
    registrarMensaje(elemEntity, elemCtrl, "Stock insuficiente", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Notificar rechazo por falta de stock()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar error de disponibilidad()", true, seq++);

    // alt: disponible
    registrarMensaje(elemEntity, elemCtrl, "Disponibilidad confirmada", true, seq++);
    registrarMensaje(elemCtrl, elemEntity, "3. Descontar stock origen y crear ticket en tránsito()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Traspaso en estado EN TRÁNSITO", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "4. Confirmar despacho de mercadería()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar guía de traspaso generada()", true, seq++);

    // opt: recepción
    registrarMensaje(elemActor, elemUI, "5. Confirmar llegada íntegra(traspasoId)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "Procesar recepción traspaso(traspasoId)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "Incrementar stock destino y marcar COMPLETADO()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Traspaso completado", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Notificar traspaso finalizado()", true, seq++);

    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
}

// ==============================================================================
// 4. CU11: Consultar Catálogo y Disponibilidad en Tiempo Real
// ==============================================================================
function generarCU11(parentPkg) {
    Repository.WriteOutput("Script", "-> Generando CU11: Consultar catálogo y disponibilidad...", 0);
    var pkg = parentPkg.Packages.AddNew("CU11 - Consultar Catálogo y Disponibilidad", "");
    pkg.Update();

    var diagram = pkg.Diagrams.AddNew("CU11 Consultar catálogo y disponibilidad", "Sequence");
    diagram.Update();

    // Lifelines BCE
    var elemActor = pkg.Elements.AddNew("Cliente", "Actor");
    elemActor.Update();

    var elemUI = pkg.Elements.AddNew("UI Catálogo Online", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    var elemCtrl = pkg.Elements.AddNew("CatalogoController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    var elemEntity = pkg.Elements.AddNew("Prenda", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    pkg.Elements.Refresh();
    posicionarLifelines(diagram, [elemActor, elemUI, elemCtrl, elemEntity]);

    // Fragmento ALT
    var fragAlt = pkg.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Stock global == 0]\n--\n[Stock disponible > 0]";
    fragAlt.Update();
    var dAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-310;b=-460;", "");
    dAlt.ElementID = fragAlt.ElementID;
    dAlt.Update();

    diagram.DiagramObjects.Refresh();

    // Mensajes
    var seq = 1;
    registrarMensaje(elemActor, elemUI, "1. Explorar catálogo()", false, seq++);
    registrarMensaje(elemActor, elemUI, "2. Aplicar filtros(categoría, talla, color)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "3. Consultar prendas filtradas(criterios)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "3.1. Buscar prendas coincidentes y fotos()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Lista de prendas encontradas", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Renderizar catálogo en cuadrícula()", true, seq++);
    registrarMensaje(elemActor, elemUI, "4. Seleccionar prenda para ver detalle(prendaId)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "5. Consultar disponibilidad en tiempo real(prendaId)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "5.1. Consultar existencias por sucursal física()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Detalle de stock por sucursales", true, seq++);

    // alt: sin stock
    registrarMensaje(elemCtrl, elemUI, "Notificar producto sin stock()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar botón 'Avisarme cuando haya stock'()", true, seq++);

    // alt: con stock
    registrarMensaje(elemCtrl, elemUI, "6. Mostrar tabla de sucursales con unidades()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Habilitar botones 'Comprar' y 'Reservar'()", true, seq++);

    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
}

// ==============================================================================
// 5. CU12: Gestionar Reservas Web-to-Store
// ==============================================================================
function generarCU12(parentPkg) {
    Repository.WriteOutput("Script", "-> Generando CU12: Gestionar reservas Web-to-Store...", 0);
    var pkg = parentPkg.Packages.AddNew("CU12 - Gestionar Reservas Web-to-Store", "");
    pkg.Update();

    var diagram = pkg.Diagrams.AddNew("CU12 Gestionar reservas Web-to-Store", "Sequence");
    diagram.Update();

    // Lifelines BCE
    var elemActor = pkg.Elements.AddNew("Cliente", "Actor");
    elemActor.Update();

    var elemUI = pkg.Elements.AddNew("UI Reservas", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    var elemCtrl = pkg.Elements.AddNew("ReservaController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    var elemEntity = pkg.Elements.AddNew("Reserva", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    pkg.Elements.Refresh();
    posicionarLifelines(diagram, [elemActor, elemUI, elemCtrl, elemEntity]);

    // Fragmentos
    var fragAlt = pkg.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Stock agotado o límite alcanzado]\n--\n[Reserva válida]";
    fragAlt.Update();
    var dAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-180;b=-340;", "");
    dAlt.ElementID = fragAlt.ElementID;
    dAlt.Update();

    var fragOpt1 = pkg.Elements.AddNew("opt", "InteractionFragment");
    fragOpt1.Stereotype = "opt";
    fragOpt1.Notes = "[Confirmar retiro presencial en sucursal]";
    fragOpt1.Update();
    var dOpt1 = diagram.DiagramObjects.AddNew("l=35;r=720;t=-350;b=-450;", "");
    dOpt1.ElementID = fragOpt1.ElementID;
    dOpt1.Update();

    var fragOpt2 = pkg.Elements.AddNew("opt", "InteractionFragment");
    fragOpt2.Stereotype = "opt";
    fragOpt2.Notes = "[Expiración automática por tiempo límite]";
    fragOpt2.Update();
    var dOpt2 = diagram.DiagramObjects.AddNew("l=35;r=720;t=-460;b=-530;", "");
    dOpt2.ElementID = fragOpt2.ElementID;
    dOpt2.Update();

    diagram.DiagramObjects.Refresh();

    // Mensajes
    var seq = 1;
    registrarMensaje(elemActor, elemUI, "1. Solicitar reserva Web-to-Store(prendaId, sucursalId, talla)", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "2. Crear reserva(datosReserva)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "2.1. Validar existencia y stock en sucursal()", false, seq++);

    // alt: no permitida
    registrarMensaje(elemEntity, elemCtrl, "Reserva no permitida", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Notificar rechazo de reserva()", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar alerta de stock no disponible()", true, seq++);

    // alt: válida
    registrarMensaje(elemEntity, elemCtrl, "Stock disponible verificado", true, seq++);
    registrarMensaje(elemCtrl, elemEntity, "3. Bloquear stock y generar código PIN/QR()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Reserva en estado PENDIENTE", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "4. Retornar confirmación reserva(código, límiteTiempo)", true, seq++);
    registrarMensaje(elemUI, elemActor, "Mostrar voucher de reserva()", true, seq++);

    // opt 1: retiro
    registrarMensaje(elemActor, elemUI, "5. Presentar código en sucursal física()", false, seq++);
    registrarMensaje(elemUI, elemCtrl, "Confirmar retiro de reserva(codigoReserva)", false, seq++);
    registrarMensaje(elemCtrl, elemEntity, "Marcar RETIRADA y registrar salida stock()", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Retiro confirmado", true, seq++);
    registrarMensaje(elemCtrl, elemUI, "Notificar entrega exitosa()", true, seq++);

    // opt 2: expiración
    registrarMensaje(elemCtrl, elemEntity, "Liberar prendas de reservas vencidas (Cron Job)", false, seq++);
    registrarMensaje(elemEntity, elemCtrl, "Stock desbloqueado", true, seq++);

    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
}

// ==============================================================================
// FUNCIÓN PRINCIPAL DE EJECUCIÓN
// ==============================================================================
function generarIteracion2() {
    Repository.EnsureOutputVisible("Script");
    Repository.WriteOutput("Script", "==================================================", 0);
    Repository.WriteOutput("Script", "=== INICIANDO GENERACIÓN DE ITERACIÓN 2 (EA)   ===", 0);
    Repository.WriteOutput("Script", "==================================================", 0);

    var currentPackage = Repository.GetTreeSelectedPackage();
    if (currentPackage == null) {
        Session.Prompt("Por favor seleccione un Paquete en el Project Browser antes de ejecutar.", promptOK);
        Repository.WriteOutput("Script", "[ERROR] Ningún paquete seleccionado.", 0);
        return;
    }

    // Crear la carpeta principal de la Iteración 2
    var iterPkg = currentPackage.Packages.AddNew("Iteración 2 - Gestión Comercial e Inventario", "");
    iterPkg.Update();
    Repository.WriteOutput("Script", "Carpeta raíz creada: " + iterPkg.Name, 0);

    // Generar cada Caso de Uso en su respectiva subcarpeta
    generarCU08(iterPkg);
    generarCU09(iterPkg);
    generarCU10(iterPkg);
    generarCU11(iterPkg);
    generarCU12(iterPkg);

    // Refrescar el árbol de paquetes
    currentPackage.Packages.Refresh();
    Repository.RefreshModelView(currentPackage.PackageID);

    Repository.WriteOutput("Script", "==================================================", 0);
    Repository.WriteOutput("Script", "=== [OK] ITERACIÓN 2 GENERADA CON ÉXITO (5 CUs) ===", 0);
    Repository.WriteOutput("Script", "==================================================", 0);
    
    Session.Prompt("¡Iteración 2 generada exitosamente con sus 5 Casos de Uso y Diagramas de Secuencia!", promptOK);
}

// Ejecutar
generarIteracion2();

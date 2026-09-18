//!INC Local Scripts.EAConstants-JScript
/*
 * ==============================================================================
 * PROYECTO: Sistema de Información (SI2) - Arquitectura BCE (3 Capas)
 * DIAGRAMA: CU1 Gestión de usuarios y autenticación
 * DESCRIPCIÓN: Script en JScript para Enterprise Architect (Sparx Systems)
 *              Estructura con:
 *              - Actor: Usuario del sistema
 *              - Boundary (Interfaz): UI Autenticación
 *              - Control (Lógica): AuthController
 *              - Entity (BD / Modelo): Usuario
 *              - Fragmentos Combinados: alt [Credenciales inválidas / válidas],
 *                                       opt [Cerrar sesión],
 *                                       opt [Sesión expirada]
 * ==============================================================================
 */

function crearDiagramaSecuenciaCU1() {
    Repository.EnsureOutputVisible("Script");
    Repository.WriteOutput("Script", "=== Generando Diagrama de Secuencia: CU1 Gestión de usuarios y autenticación ===", 0);

    // 1. Obtener paquete seleccionado
    var currentPackage = Repository.GetTreeSelectedPackage();
    if (currentPackage == null) {
        Session.Prompt("Por favor seleccione un Paquete en el Project Browser antes de ejecutar.", promptOK);
        Repository.WriteOutput("Script", "[ERROR] Ningún paquete seleccionado.", 0);
        return;
    }

    // 2. Crear Diagrama de Secuencia
    var diagName = "CU1 Gestión de usuarios y autenticación";
    var diagram = currentPackage.Diagrams.AddNew(diagName, "Sequence");
    if (!diagram.Update()) {
        Repository.WriteOutput("Script", "[ERROR] No se pudo crear el diagrama: " + diagram.GetLastError(), 0);
        return;
    }

    // 3. Crear Líneas de Vida (Lifelines) por Capas (Actor, UI, Control, Entity/BD)
    
    // Actor
    var elemActor = currentPackage.Elements.AddNew("Usuario del sistema", "Actor");
    elemActor.Update();

    // Boundary (UI)
    var elemUI = currentPackage.Elements.AddNew("UI Autenticación", "Sequence");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    // Control (Lógica)
    var elemCtrl = currentPackage.Elements.AddNew("AuthController", "Sequence");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    // Entity (BD)
    var elemEntity = currentPackage.Elements.AddNew("Usuario", "Sequence");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    currentPackage.Elements.Refresh();

    // 4. Posicionar Lifelines en el Diagrama
    var lifelines = [elemActor, elemUI, elemCtrl, elemEntity];
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

    // 5. Crear Fragmentos Combinados (alt y opt)
    
    // Fragmento ALT: [Credenciales inválidas] / [Credenciales válidas]
    var fragAlt = currentPackage.Elements.AddNew("alt", "InteractionFragment");
    fragAlt.Stereotype = "alt";
    fragAlt.Notes = "[Credenciales inválidas]\n--\n[Credenciales válidas]";
    fragAlt.Update();

    var diagObjAlt = diagram.DiagramObjects.AddNew("l=35;r=720;t=-180;b=-340;", "");
    diagObjAlt.ElementID = fragAlt.ElementID;
    diagObjAlt.Update();

    // Fragmento OPT: [Cerrar sesión]
    var fragOpt1 = currentPackage.Elements.AddNew("opt", "InteractionFragment");
    fragOpt1.Stereotype = "opt";
    fragOpt1.Notes = "[Cerrar sesión]";
    fragOpt1.Update();

    var diagObjOpt1 = diagram.DiagramObjects.AddNew("l=35;r=720;t=-350;b=-450;", "");
    diagObjOpt1.ElementID = fragOpt1.ElementID;
    diagObjOpt1.Update();

    // Fragmento OPT: [Sesión expirada]
    var fragOpt2 = currentPackage.Elements.AddNew("opt", "InteractionFragment");
    fragOpt2.Stereotype = "opt";
    fragOpt2.Notes = "[Sesión expirada]";
    fragOpt2.Update();

    var diagObjOpt2 = diagram.DiagramObjects.AddNew("l=35;r=720;t=-460;b=-530;", "");
    diagObjOpt2.ElementID = fragOpt2.ElementID;
    diagObjOpt2.Update();

    diagram.DiagramObjects.Refresh();

    // 6. Función para registrar mensajes
    var seqNumber = 1;
    function registrarMensaje(origen, destino, nombreMensaje, esRetorno) {
        var con = origen.Connectors.AddNew(nombreMensaje, "Sequence");
        con.SupplierID = destino.ElementID;
        con.SequenceNo = seqNumber++;
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

    // 7. Flujo de Mensajes exacto a la estructura

    // --- Flujo Inicial ---
    // 1. Acceder()
    registrarMensaje(elemActor, elemUI, "1. Acceder()", false);
    
    // 2. Introducir credenciales()
    registrarMensaje(elemActor, elemUI, "2. Introducir credenciales()", false);
    
    // 3. Validar credenciales()
    registrarMensaje(elemUI, elemCtrl, "3. Validar credenciales()", false);
    
    // 3.1. Buscar usuario()
    registrarMensaje(elemCtrl, elemEntity, "3.1. Buscar usuario()", false);
    
    // Datos del usuario (retorno)
    registrarMensaje(elemEntity, elemCtrl, "Datos del usuario", true);

    // --- Bloque ALT: Credenciales inválidas ---
    // Notificar error de acceso()
    registrarMensaje(elemCtrl, elemUI, "Notificar error de acceso()", true);
    
    // Mostrar mensaje de error()
    registrarMensaje(elemUI, elemActor, "Mostrar mensaje de error()", true);

    // --- Bloque ALT: Credenciales válidas ---
    // 4. Identificar rol()
    registrarMensaje(elemCtrl, elemEntity, "4. Identificar rol()", false);
    
    // Rol encontrado (retorno)
    registrarMensaje(elemEntity, elemCtrl, "Rol encontrado", true);
    
    // 5. Acceso permitido()
    registrarMensaje(elemCtrl, elemUI, "5. Acceso permitido()", false);
    
    // Redirigir al panel() (retorno)
    registrarMensaje(elemUI, elemActor, "Redirigir al panel()", true);

    // --- Bloque OPT: Cerrar sesión ---
    // 6. Cerrar sesión()
    registrarMensaje(elemActor, elemUI, "6. Cerrar sesión()", false);
    
    // Cerrar sesión()
    registrarMensaje(elemUI, elemCtrl, "Cerrar sesión()", false);
    
    // Sesión cerrada() (retorno)
    registrarMensaje(elemCtrl, elemUI, "Sesión cerrada()", true);
    
    // Mostrar login() (retorno)
    registrarMensaje(elemUI, elemActor, "Mostrar login()", true);

    // --- Bloque OPT: Sesión expirada ---
    // Notificar sesión expirada()
    registrarMensaje(elemUI, elemActor, "Notificar sesión expirada()", true);

    // 8. Actualizar diagrama y abrir
    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
    Repository.OpenDiagram(diagram.DiagramID);

    Repository.WriteOutput("Script", "=== [OK] Diagrama de Secuencia CU1 estructurado generado exitosamente (ID: " + diagram.DiagramID + ") ===", 0);
}

// Ejecutar
crearDiagramaSecuenciaCU1();

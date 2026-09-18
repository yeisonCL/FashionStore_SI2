//!INC Local Scripts.EAConstants-JScript
/*
 * ==============================================================================
 * PROYECTO: Sistema de Información (SI2) - Arquitectura Robusta (BCE)
 * CASO DE USO: CU01. Gestionar autenticación y perfil
 * TIPO DE DIAGRAMA: Diagrama de Robustez / Comunicación (Analysis Diagram)
 * 
 * ELEMENTOS CON FORMAS REDONDAS NATIVAS DE ENTERPRISE ARCHITECT:
 *   - : Usuario              -> Type: "Actor" (Muñeco de palo)
 *   - :UI Autenticación      -> Type: "Class", Stereotype: "boundary" (Círculo con barra vertical)
 *   - :Control Autenticación -> Type: "Class", Stereotype: "control"  (Círculo con flecha/bucle)
 *   - :Modelo Usuario        -> Type: "Class", Stereotype: "entity"   (Círculo con base horizontal)
 * 
 * FUNCIONES EN FLECHAS:
 *   - Enlace 1: 1: iniciarSesion() / 2: cerrarSesion()
 *   - Enlace 2: 1.1: login_usuario() / 2.1: logout_usuario()
 *   - Enlace 3: 1.1.1: Usuario.objects.filter() / 1.1.2: Rol.objects.get() / 2.1.1: Bitacora.objects.create()
 * ==============================================================================
 */

function crearDiagramaComunicacionCU01() {
    Repository.EnsureOutputVisible("Script");
    Repository.WriteOutput("Script", "=== Generando Diagrama de Robustez/Comunicación: CU01 ===", 0);

    // 1. Obtener paquete seleccionado
    var currentPackage = Repository.GetTreeSelectedPackage();
    if (currentPackage == null) {
        Session.Prompt("Por favor seleccione un Paquete en el Project Browser antes de ejecutar.", promptOK);
        Repository.WriteOutput("Script", "[ERROR] Ningún paquete seleccionado.", 0);
        return;
    }

    // 2. Crear Diagrama de Tipo 'Analysis' (Garantiza que EA dibuje los círculos de Robustez)
    var diagName = "CU01. Gestionar autenticación y perfil";
    var diagram = currentPackage.Diagrams.AddNew(diagName, "Analysis");
    if (!diagram.Update()) {
        diagram = currentPackage.Diagrams.AddNew(diagName, "Communication");
        diagram.Update();
    }
    Repository.WriteOutput("Script", "Diagrama creado: " + diagName, 0);

    // 3. Crear Elementos del Análisis Robusto (Class con estereotipos boundary, control, entity)
    
    // a) Actor
    var elemActor = currentPackage.Elements.AddNew(": Usuario", "Actor");
    elemActor.Update();

    // b) Boundary (Interfaz) -> Círculo con barra vertical izquierda
    var elemUI = currentPackage.Elements.AddNew(":UI Autenticación", "Class");
    elemUI.Stereotype = "boundary";
    elemUI.Update();

    // c) Control (Controlador) -> Círculo con flecha/bucle superior
    var elemCtrl = currentPackage.Elements.AddNew(":Control Autenticación", "Class");
    elemCtrl.Stereotype = "control";
    elemCtrl.Update();

    // d) Entity (Modelo / BD) -> Círculo con línea horizontal inferior
    var elemEntity = currentPackage.Elements.AddNew(":Modelo Usuario", "Class");
    elemEntity.Stereotype = "entity";
    elemEntity.Update();

    currentPackage.Elements.Refresh();

    // 4. Posicionar Elementos Horizontalmente con dimensiones cuadradas (80x80 px)
    var topPos = -110;
    var botPos = -190;

    // Actor (l=50, r=130)
    var dObjActor = diagram.DiagramObjects.AddNew("l=50;r=130;t=" + topPos + ";b=" + botPos + ";", "");
    dObjActor.ElementID = elemActor.ElementID;
    dObjActor.Update();

    // :UI Autenticación (l=250, r=330)
    var dObjUI = diagram.DiagramObjects.AddNew("l=250;r=330;t=" + topPos + ";b=" + botPos + ";", "");
    dObjUI.ElementID = elemUI.ElementID;
    dObjUI.Update();

    // :Control Autenticación (l=470, r=550)
    var dObjCtrl = diagram.DiagramObjects.AddNew("l=470;r=550;t=" + topPos + ";b=" + botPos + ";", "");
    dObjCtrl.ElementID = elemCtrl.ElementID;
    dObjCtrl.Update();

    // :Modelo Usuario (l=690, r=770)
    var dObjEntity = diagram.DiagramObjects.AddNew("l=690;r=770;t=" + topPos + ";b=" + botPos + ";", "");
    dObjEntity.ElementID = elemEntity.ElementID;
    dObjEntity.Update();

    diagram.DiagramObjects.Refresh();

    // 5. Crear Conectores con Flechas de Dirección y Funciones
    
    // --- ENLACE 1: : Usuario ----> :UI Autenticación ---
    var link1 = elemActor.Connectors.AddNew("", "Association");
    link1.SupplierID = elemUI.ElementID;
    link1.Direction = "Source -> Destination";
    link1.Name = "1: iniciarSesion()\n2: cerrarSesion()";
    link1.Update();
    
    try {
        var m1 = link1.Messages.AddNew("iniciarSesion()", "Message");
        m1.SenderID = elemActor.ElementID;
        m1.ReceiverID = elemUI.ElementID;
        m1.SequenceNum = "1";
        m1.Update();

        var m2 = link1.Messages.AddNew("cerrarSesion()", "Message");
        m2.SenderID = elemActor.ElementID;
        m2.ReceiverID = elemUI.ElementID;
        m2.SequenceNum = "2";
        m2.Update();
    } catch(e) {}
    elemActor.Connectors.Refresh();

    // --- ENLACE 2: :UI Autenticación ----> :Control Autenticación ---
    var link2 = elemUI.Connectors.AddNew("", "Association");
    link2.SupplierID = elemCtrl.ElementID;
    link2.Direction = "Source -> Destination";
    link2.Name = "1.1: login_usuario()\n2.1: logout_usuario()";
    link2.Update();

    try {
        var m3 = link2.Messages.AddNew("login_usuario()", "Message");
        m3.SenderID = elemUI.ElementID;
        m3.ReceiverID = elemCtrl.ElementID;
        m3.SequenceNum = "1.1";
        m3.Update();

        var m4 = link2.Messages.AddNew("logout_usuario()", "Message");
        m4.SenderID = elemUI.ElementID;
        m4.ReceiverID = elemCtrl.ElementID;
        m4.SequenceNum = "2.1";
        m4.Update();
    } catch(e) {}
    elemUI.Connectors.Refresh();

    // --- ENLACE 3: :Control Autenticación ----> :Modelo Usuario ---
    var link3 = elemCtrl.Connectors.AddNew("", "Association");
    link3.SupplierID = elemEntity.ElementID;
    link3.Direction = "Source -> Destination";
    link3.Name = "1.1.1: Usuario.objects.filter()\n1.1.2: Rol.objects.get()\n2.1.1: Bitacora.objects.create()";
    link3.Update();

    try {
        var m5 = link3.Messages.AddNew("Usuario.objects.filter()", "Message");
        m5.SenderID = elemCtrl.ElementID;
        m5.ReceiverID = elemEntity.ElementID;
        m5.SequenceNum = "1.1.1";
        m5.Update();

        var m6 = link3.Messages.AddNew("Rol.objects.get()", "Message");
        m6.SenderID = elemCtrl.ElementID;
        m6.ReceiverID = elemEntity.ElementID;
        m6.SequenceNum = "1.1.2";
        m6.Update();

        var m7 = link3.Messages.AddNew("Bitacora.objects.create()", "Message");
        m7.SenderID = elemCtrl.ElementID;
        m7.ReceiverID = elemEntity.ElementID;
        m7.SequenceNum = "2.1.1";
        m7.Update();
    } catch(e) {}
    elemCtrl.Connectors.Refresh();

    // 6. Actualizar y abrir el diagrama
    diagram.Update();
    Repository.ReloadDiagram(diagram.DiagramID);
    Repository.OpenDiagram(diagram.DiagramID);

    Repository.WriteOutput("Script", "=== [OK] Diagrama de Robustez con Iconos Redondos y Flechas generado con éxito (ID: " + diagram.DiagramID + ") ===", 0);
}

// Ejecutar
crearDiagramaComunicacionCU01();

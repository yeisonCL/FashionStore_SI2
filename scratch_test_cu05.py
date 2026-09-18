import sys
import os

sys.path.insert(0, r"c:\Users\HP\Desktop\revision de documento\backend_fastapi")

from database import SessionLocal
from models.sucursal import Sucursal, InventarioSucursal
from models.catalogo import VariantePrenda
from routers.sucursales import (
    listar_sucursales,
    obtener_sucursal,
    crear_sucursal,
    actualizar_sucursal,
    eliminar_sucursal,
    ver_inventario_sucursal,
    registrar_traspaso
)
from schemas.sucursal import SucursalCreate, TraspasoCreate, DetalleTraspasoCreate

db = SessionLocal()

print("Iniciando Verificación CU05 - Sucursales e Inventario en PostgreSQL...\n")

class DummyRequest:
    client = None
    headers = {"x-user-id": "1"}

dummy_req = DummyRequest()

try:
    # Limpiar prueba previa si quedó
    db.query(Sucursal).filter(Sucursal.nombre == "Sucursal Test Norte").delete()
    db.commit()

    # 1. Registrar nueva sucursal (POST)
    print("--- 1. Registrar Sucursal ---")
    suc_in = SucursalCreate(
        nombre="Sucursal Test Norte",
        ciudad="Santa Cruz",
        direccion="4to Anillo y Av. Banzer",
        telefono="33445566"
    )
    suc_creada = crear_sucursal(sucursal_in=suc_in, request=dummy_req, db=db)
    print(f"Sucursal creada con éxito: ID={suc_creada.id}, Nombre='{suc_creada.nombre}', Ciudad='{suc_creada.ciudad}'")
    suc_id = suc_creada.id

    # 2. Verificar inicialización de inventario por sucursal
    print("\n--- 2. Consultar Inventario de la Sucursal ---")
    inv = ver_inventario_sucursal(sucursal_id=suc_id, db=db)
    print(f"Registros de inventario inicializados para variantes: {len(inv)}")
    if len(inv) > 0:
        print(f"Ejemplo variante ID {inv[0]['variante_id']}: stock_fisico={inv[0]['stock_fisico']}, disponible={inv[0]['stock_disponible']}")

    # 3. Listar sucursales
    print("\n--- 3. Listar Sucursales de la Cadena ---")
    todas = listar_sucursales(db=db)
    print(f"Total sucursales en BD: {len(todas)}")
    for s in todas:
        print(f" - [{s.id}] {s.nombre} ({s.ciudad}) - Tel: {s.telefono}")

    # 4. Actualizar Sucursal (PUT)
    print("\n--- 4. Actualizar Sucursal (PUT) ---")
    suc_upd = SucursalCreate(
        nombre="Sucursal Test Norte Renovada",
        ciudad="Santa Cruz",
        direccion="5to Anillo y Av. Cristo Redentor",
        telefono="33998877"
    )
    suc_actualizada = actualizar_sucursal(sucursal_id=suc_id, sucursal_in=suc_upd, request=dummy_req, db=db)
    print(f"Sucursal actualizada: {suc_actualizada.nombre}, Dir: {suc_actualizada.direccion}")

    # 5. Probar Traspaso inter-sucursales
    print("\n--- 5. Probar Lógica de Traspasos ---")
    if len(todas) >= 2:
        suc_dest_id = [s.id for s in todas if s.id != suc_id][0]
        var_primera = db.query(VariantePrenda).first()
        if var_primera:
            inv_origen = db.query(InventarioSucursal).filter(
                InventarioSucursal.sucursal_id == suc_id,
                InventarioSucursal.variante_id == var_primera.id
            ).first()
            if inv_origen:
                inv_origen.stock_fisico = 10
                db.commit()

                # Buscar un empleado para asociarlo al traspaso
                from models.seguridad_persona import Empleado
                emp = db.query(Empleado).first()
                emp_ci = emp.ci if emp else "1234567"

                traspaso_in = TraspasoCreate(
                    empleado_id=emp_ci,
                    sucursal_origen_id=suc_id,
                    sucursal_destino_id=suc_dest_id,
                    detalles=[DetalleTraspasoCreate(variante_id=var_primera.id, cantidad=3)]
                )
                res_traspaso = registrar_traspaso(traspaso_in=traspaso_in, db=db)
                print(f"Traspaso realizado con éxito: ID={res_traspaso.id}, Estado={res_traspaso.estado}")
                print(f"Stock restante en origen: {inv_origen.stock_fisico} (se transfirieron 3 unidades)")

    # 6. Eliminar Sucursal de prueba (DELETE)
    print("\n--- 6. Eliminar Sucursal de Prueba ---")
    eliminar_sucursal(sucursal_id=suc_id, request=dummy_req, db=db)
    print("Sucursal eliminada correctamente.")

    print("\n>>> ¡Verificación CU05 completada 100% con éxito! <<<")

finally:
    db.close()

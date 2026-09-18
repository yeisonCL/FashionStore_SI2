import urllib.request
import json

BASE_URL = "http://localhost:8000/api/v1"

def test_endpoint(name, method, endpoint, data=None):
    url = f"{BASE_URL}{endpoint}"
    req = urllib.request.Request(url, method=method)
    req.add_header('Content-Type', 'application/json')
    body_bytes = json.dumps(data).encode('utf-8') if data else None
    
    try:
        res = urllib.request.urlopen(req, data=body_bytes, timeout=5)
        resp_data = json.loads(res.read().decode('utf-8'))
        print(f"[OK] {name} ({method} {endpoint}) -> Status {res.status}")
        return True, resp_data
    except Exception as e:
        print(f"[FAIL] {name} ({method} {endpoint}) -> Error: {e}")
        return False, str(e)

print("--- VERIFICANDO ENDPOINTS DE LA APP MÓVIL EN FASTAPI ---")
test_endpoint("CU01 Login", "POST", "/seguridad/login", {"username": "admin", "password": "adminpassword"})
test_endpoint("CU11 Catálogo", "GET", "/catalogo-disponibilidad/")
test_endpoint("CU16 Catálogo AR 3D", "GET", "/ar/catalogo-3d")
test_endpoint("CU16 Validar Ajuste AR", "POST", "/ar/validar-ajuste", {"ropa_id": 1, "altura_cm": 175, "pecho_cm": 95, "cintura_cm": 80, "cadera_cm": 95})
test_endpoint("CU17 Generar Outfit IA", "POST", "/ia/generar-outfit", {"cliente_id": "1001", "ocasion": "Casual"})
test_endpoint("CU15 Procesar Venta Digital", "POST", "/ventas/ecommerce", {
    "cliente_id": "1001",
    "sucursal_id": 1,
    "metodo_pago_id": 1,
    "nit_cliente": "1234567",
    "razon_social": "Cliente Movil",
    "direccion_envio": "Entrega a domicilio",
    "token_pasarela": "tok_simulado"
})
test_endpoint("CU12 Crear Reserva", "POST", "/reservas/crear", {
    "cliente_id": "1001",
    "sucursal_id": 1,
    "hora_estimada": "18:00",
    "detalles": [{"variante_id": 1, "cantidad": 1}]
})
test_endpoint("CU19 Publicar Reseña", "POST", "/resenas/", {
    "ropa_id": 1,
    "cliente_ci": "1001",
    "puntuacion_estrellas": 5,
    "comentario": "Excelente prenda y ajuste biométrico"
})

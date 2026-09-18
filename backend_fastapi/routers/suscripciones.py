"""
Router para Suscripciones de Empresa y Planes (SaaS/Multisucursal).
Proporciona datos operativos para el panel de suscripción en Angular.
"""
from typing import List, Optional
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from database import get_db

router = APIRouter(tags=["Empresa - Suscripciones y Planes"])

# Mock dataset dinámico de suscripción activa de la empresa
MOCK_PLANES = [
    {
        "id": 1,
        "nombre": "Plan Básico Moda",
        "descripcion": "Ideal para boutique única. Incluye catálogo digital y gestión de inventario.",
        "precio_mensual": 29.0,
        "precio_anual": 290.0,
        "limite_sucursales": 1,
        "limite_usuarios": 3,
        "limite_productos": 500,
        "limite_clientes": 1000,
        "limite_proveedores": 50,
        "feature_realidad_aumentada": False,
        "feature_fotos_3d": False,
        "feature_reportes_dinamicos": True,
        "feature_backup_automatico": False,
        "soporta_ar": False,
        "soporta_ia": False,
        "activo": True
    },
    {
        "id": 2,
        "nombre": "Plan Pro AR Fashion",
        "descripcion": "Para tiendas en crecimiento. Incluye Vestidor Virtual AR 3D y Sugerencias IA.",
        "precio_mensual": 79.0,
        "precio_anual": 790.0,
        "limite_sucursales": 5,
        "limite_usuarios": 10,
        "limite_productos": 5000,
        "limite_clientes": 10000,
        "limite_proveedores": 200,
        "feature_realidad_aumentada": True,
        "feature_fotos_3d": True,
        "feature_reportes_dinamicos": True,
        "feature_backup_automatico": True,
        "soporta_ar": True,
        "soporta_ia": True,
        "activo": True
    },
    {
        "id": 3,
        "nombre": "Plan Enterprise Omnicanal",
        "descripcion": "Solución multisucursal completa con IA Gemini, AR 3D sin límites y soporte 24/7.",
        "precio_mensual": 199.0,
        "precio_anual": 1990.0,
        "limite_sucursales": 99,
        "limite_usuarios": 50,
        "limite_productos": 50000,
        "limite_clientes": 100000,
        "limite_proveedores": 1000,
        "feature_realidad_aumentada": True,
        "feature_fotos_3d": True,
        "feature_reportes_dinamicos": True,
        "feature_backup_automatico": True,
        "soporta_ar": True,
        "soporta_ia": True,
        "activo": True
    }
]

MOCK_SUSCRIPCION = {
    "id": 1,
    "empresa": 1,
    "plan": 2,
    "estado": "activa",
    "ciclo": "mensual",
    "fecha_inicio": "2026-01-01T00:00:00Z",
    "fecha_fin": "2026-12-31T23:59:59Z",
    "auto_renovar": True,
    "ultima_renovacion": "2026-09-01T10:00:00Z",
    "cancelada_en": None,
    "cancelada_por": "",
    "fecha_creacion": "2026-01-01T00:00:00Z"
}

MOCK_CAMBIOS = [
    {
        "id": 1,
        "suscripcion": 1,
        "plan_anterior": 1,
        "plan_nuevo": 2,
        "cambiado_en": "2026-03-15T14:30:00Z",
        "motivo": "Actualización a multisucursal y recomendador IA para el parcial SI2"
    }
]


# === PLANES ===
@router.get("/api/planes/")
@router.get("/api/v1/planes/")
def listar_planes(page: Optional[int] = None, page_size: int = 10, activos: Optional[int] = None):
    planes = [p for p in MOCK_PLANES if (activos is None or p["activo"] == bool(activos))]
    if page is not None:
        return {
            "count": len(planes),
            "next": None,
            "previous": None,
            "results": planes
        }
    return planes


# === SUSCRIPCIONES ===
@router.get("/api/suscripciones/")
@router.get("/api/v1/suscripciones/")
def obtener_suscripciones(page: Optional[int] = None, page_size: int = 10):
    if page is not None:
        return {
            "count": 1,
            "next": None,
            "previous": None,
            "results": [MOCK_SUSCRIPCION]
        }
    return [MOCK_SUSCRIPCION]


@router.get("/api/suscripcion-cambios/")
@router.get("/api/v1/suscripcion-cambios/")
def obtener_cambios_suscripcion(page: Optional[int] = None, page_size: int = 10):
    if page is not None:
        return {
            "count": len(MOCK_CAMBIOS),
            "next": None,
            "previous": None,
            "results": MOCK_CAMBIOS
        }
    return MOCK_CAMBIOS


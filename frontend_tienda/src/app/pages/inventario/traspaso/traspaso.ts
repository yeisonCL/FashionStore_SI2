import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ConfigService } from 'src/app/services/config.service';

export interface Traspaso {
  id: number;
  sucursal_origen_id: number;
  sucursal_origen_nombre: string;
  sucursal_origen_ciudad: string;
  sucursal_destino_id: number;
  sucursal_destino_nombre: string;
  sucursal_destino_ciudad: string;
  estado: string;
  observacion?: string;
  fecha_solicitud: string;
  fecha_recepcion?: string;
  total_unidades: number;
  detalles?: any[];
}

@Component({
  selector: 'app-traspasos',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatSelectModule,
    MatSnackBarModule,
    MatProgressSpinnerModule,
    MatFormFieldModule,
    MatInputModule,
    MatTooltipModule
  ],
  templateUrl: './traspaso.html',
  styleUrls: ['./traspaso.scss']
})
export class TraspasosComponent implements OnInit {
  traspasos: Traspaso[] = [];
  sucursales: any[] = [];
  variantesDisponibles: any[] = [];
  cargando = true;
  guardando = false;
  mostrarModal = false;

  formulario: any = {
    sucursal_origen_id: 1,
    sucursal_destino_id: 2,
    variante_id: null,
    cantidad: 5,
    observacion: 'Traspaso inter-sucursal para balance de stock'
  };

  columnas: string[] = ['id', 'origen', 'destino', 'unidades', 'fecha', 'estado', 'acciones'];

  constructor(
    private http: HttpClient,
    private configService: ConfigService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.cargarSucursales();
    this.cargarTraspasos();
  }

  cargarSucursales(): void {
    const url = this.configService.getApiUrl('sucursales');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.sucursales = Array.isArray(res) ? res : (res.results || []);
        if (this.sucursales.length >= 2) {
          this.formulario.sucursal_origen_id = this.sucursales[0].id;
          this.formulario.sucursal_destino_id = this.sucursales[1].id;
        }
      }
    });
  }

  cargarTraspasos(): void {
    this.cargando = true;
    const url = this.configService.getApiUrl('traspasos');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.traspasos = Array.isArray(res) ? res : (res.results || []);
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
        this.snackBar.open('Error al cargar historial de traspasos', 'Cerrar', { duration: 3000 });
      }
    });
  }

  cargarVariantesOrigen(): void {
    if (!this.formulario.sucursal_origen_id) return;
    const url = ${this.configService.getApiUrl('inventario-local')}sucursal//;
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.variantesDisponibles = (res.items || []).filter((i: any) => i.stock_disponible > 0);
        if (this.variantesDisponibles.length > 0) {
          this.formulario.variante_id = this.variantesDisponibles[0].variante_id;
        }
      }
    });
  }

  abrirModalTraspaso(): void {
    this.cargarVariantesOrigen();
    this.mostrarModal = true;
  }

  cerrarModal(): void {
    this.mostrarModal = false;
  }

  guardarTraspaso(): void {
    if (!this.formulario.variante_id || this.formulario.cantidad <= 0) {
      this.snackBar.open('Selecciona una variante y cantidad válida', 'Cerrar', { duration: 2500 });
      return;
    }
    if (this.formulario.sucursal_origen_id === this.formulario.sucursal_destino_id) {
      this.snackBar.open('Las sucursales de origen y destino deben ser distintas', 'Cerrar', { duration: 3000 });
      return;
    }

    this.guardando = true;
    const url = this.configService.getApiUrl('traspasos');
    const body = {
      sucursal_origen_id: this.formulario.sucursal_origen_id,
      sucursal_destino_id: this.formulario.sucursal_destino_id,
      observacion: this.formulario.observacion,
      detalles: [
        {
          variante_id: this.formulario.variante_id,
          cantidad: this.formulario.cantidad
        }
      ]
    };

    this.http.post<any>(url, body).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarModal();
        this.snackBar.open('¡Traspaso creado y despachado con éxito!', 'OK', { duration: 3500 });
        this.cargarTraspasos();
      },
      error: (err) => {
        this.guardando = false;
        this.snackBar.open(err.error?.detail || 'Error al crear traspaso', 'Cerrar', { duration: 4000 });
      }
    });
  }

  confirmarRecepcion(t: Traspaso): void {
    const url = ${this.configService.getApiUrl('traspasos')}/recibir/;
    this.http.post<any>(url, {}).subscribe({
      next: () => {
        this.snackBar.open('¡Traspaso recibido y stock sumado a destino!', 'OK', { duration: 3500 });
        this.cargarTraspasos();
      },
      error: (err) => {
        this.snackBar.open(err.error?.detail || 'Error al confirmar recepción', 'Cerrar', { duration: 3000 });
      }
    });
  }
}

import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatTableModule } from '@angular/material/table';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatTooltipModule } from '@angular/material/tooltip';
import { ConfigService } from 'src/app/services/config.service';

export interface Promocion {
  id: number;
  nombre: string;
  descripcion?: string;
  porcentaje_descuento: number;
  fecha_inicio: string;
  fecha_fin: string;
  activo?: boolean;
  esta_vigente?: boolean;
  estado_calculado?: string;
  total_prendas_asociadas?: number;
  prendas?: any[];
}

@Component({
  selector: 'app-promocion',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatSnackBarModule,
    MatProgressSpinnerModule,
    MatFormFieldModule,
    MatInputModule,
    MatTooltipModule
  ],
  templateUrl: './promocion.html',
  styleUrls: ['./promocion.scss']
})
export class PromocionComponent implements OnInit {
  promociones: Promocion[] = [];
  cargando = true;
  guardando = false;
  mostrarModal = false;

  formulario: any = {
    nombre: '',
    descripcion: '',
    porcentaje_descuento: 20,
    fecha_inicio: new Date().toISOString().substring(0, 10),
    fecha_fin: new Date(Date.now() + 30 * 86400000).toISOString().substring(0, 10)
  };

  columnas: string[] = ['id', 'nombre', 'descuento', 'vigencia', 'prendas', 'estado', 'acciones'];

  constructor(
    private http: HttpClient,
    private configService: ConfigService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.cargarPromociones();
  }

  cargarPromociones(): void {
    this.cargando = true;
    const url = this.configService.getApiUrl('promociones');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.promociones = Array.isArray(res) ? res : (res.results || []);
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
        this.snackBar.open('Error al cargar la lista de promociones', 'Cerrar', { duration: 3000 });
      }
    });
  }

  abrirModalCrear(): void {
    this.formulario = {
      nombre: '',
      descripcion: '',
      porcentaje_descuento: 20,
      fecha_inicio: new Date().toISOString().substring(0, 10),
      fecha_fin: new Date(Date.now() + 30 * 86400000).toISOString().substring(0, 10)
    };
    this.mostrarModal = true;
  }

  cerrarModal(): void {
    this.mostrarModal = false;
  }

  guardarPromocion(): void {
    if (!this.formulario.nombre || !this.formulario.porcentaje_descuento) {
      this.snackBar.open('Nombre y porcentaje de descuento son obligatorios', 'Cerrar', { duration: 2500 });
      return;
    }

    this.guardando = true;
    const baseUrl = this.configService.getApiUrl('promociones');
    const body = {
      ...this.formulario,
      fecha_inicio: ${this.formulario.fecha_inicio}T00:00:00Z,
      fecha_fin: ${this.formulario.fecha_fin}T23:59:59Z,
      activo: true
    };

    this.http.post<any>(baseUrl, body).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarModal();
        this.snackBar.open('Promoción creada exitosamente', 'OK', { duration: 3000 });
        this.cargarPromociones();
      },
      error: (err) => {
        this.guardando = false;
        this.snackBar.open(err.error?.detail || 'Error al crear la promoción', 'Cerrar', { duration: 3000 });
      }
    });
  }

  eliminarPromocion(p: Promocion): void {
    if (confirm(¿Estás seguro de eliminar la promoción "?)) {
 const url = ${this.configService.getApiUrl('promociones')}/;
 this.http.delete(url).subscribe({
 next: () => {
 this.snackBar.open('Promoción eliminada', 'OK', { duration: 3000 });
 this.cargarPromociones();
 },
 error: (err) => {
 this.snackBar.open(err.error?.detail || 'Error al eliminar', 'Cerrar', { duration: 3000 });
 }
 });
 }
 }
}

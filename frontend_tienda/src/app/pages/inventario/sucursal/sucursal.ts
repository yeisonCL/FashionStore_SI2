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

export interface Sucursal {
  id: number;
  nombre: string;
  ciudad: string;
  direccion?: string;
  telefono?: string;
  horario_atencion?: string;
  activo?: boolean;
}

@Component({
  selector: 'app-sucursal',
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
  templateUrl: './sucursal.html',
  styleUrls: ['./sucursal.scss']
})
export class SucursalComponent implements OnInit {
  sucursales: Sucursal[] = [];
  cargando = true;
  guardando = false;
  mostrarModal = false;
  sucursalEnEdicion: Sucursal | null = null;

  formulario: Partial<Sucursal> = {
    nombre: '',
    ciudad: 'Santa Cruz',
    direccion: '',
    telefono: '',
    horario_atencion: 'Lun - Sáb: 09:00 - 21:00'
  };

  columnas: string[] = ['id', 'nombre', 'ciudad', 'telefono', 'horario', 'estado', 'acciones'];

  constructor(
    private http: HttpClient,
    private configService: ConfigService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.cargarSucursales();
  }

  cargarSucursales(): void {
    this.cargando = true;
    const url = this.configService.getApiUrl('sucursales');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.sucursales = Array.isArray(res) ? res : (res.results || []);
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
        this.snackBar.open('Error al cargar la lista de sucursales', 'Cerrar', { duration: 3000 });
      }
    });
  }

  abrirModalCrear(): void {
    this.sucursalEnEdicion = null;
    this.formulario = {
      nombre: '',
      ciudad: 'Santa Cruz',
      direccion: '',
      telefono: '',
      horario_atencion: 'Lun - Sáb: 09:00 - 21:00'
    };
    this.mostrarModal = true;
  }

  abrirModalEditar(s: Sucursal): void {
    this.sucursalEnEdicion = s;
    this.formulario = { ...s };
    this.mostrarModal = true;
  }

  cerrarModal(): void {
    this.mostrarModal = false;
  }

  guardarSucursal(): void {
    if (!this.formulario.nombre || !this.formulario.ciudad) {
      this.snackBar.open('Nombre y Ciudad son requeridos', 'Cerrar', { duration: 2500 });
      return;
    }

    this.guardando = true;
    const baseUrl = this.configService.getApiUrl('sucursales');

    if (this.sucursalEnEdicion) {
      this.http.put<any>(${baseUrl}/, this.formulario).subscribe({
        next: () => {
          this.guardando = false;
          this.cerrarModal();
          this.snackBar.open('Sucursal actualizada correctamente', 'OK', { duration: 3000 });
          this.cargarSucursales();
        },
        error: (err) => {
          this.guardando = false;
          this.snackBar.open(err.error?.detail || 'Error al actualizar', 'Cerrar', { duration: 3000 });
        }
      });
    } else {
      this.http.post<any>(baseUrl, this.formulario).subscribe({
        next: () => {
          this.guardando = false;
          this.cerrarModal();
          this.snackBar.open('Sucursal creada exitosamente', 'OK', { duration: 3000 });
          this.cargarSucursales();
        },
        error: (err) => {
          this.guardando = false;
          this.snackBar.open(err.error?.detail || 'Error al crear', 'Cerrar', { duration: 3000 });
        }
      });
    }
  }

  eliminarSucursal(s: Sucursal): void {
    if (confirm(¿Estás seguro de eliminar la sucursal "?)) {
 const url = ${this.configService.getApiUrl('sucursales')}/;
 this.http.delete(url).subscribe({
 next: () => {
 this.snackBar.open('Sucursal eliminada', 'OK', { duration: 3000 });
 this.cargarSucursales();
 },
 error: (err) => {
 this.snackBar.open(err.error?.detail || 'No se puede eliminar porque tiene inventario asignado', 'Cerrar', { duration: 4000 });
 }
 });
 }
 }
}

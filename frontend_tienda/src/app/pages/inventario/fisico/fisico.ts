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

export interface ResumenInventario {
  sucursal_id: number;
  sucursal_nombre: string;
  ciudad: string;
  total_skus: number;
  total_unidades_fisicas: number;
  total_unidades_reservadas: number;
  total_unidades_disponibles: number;
  total_alertas_bajo_stock: number;
  items: any[];
}

@Component({
  selector: 'app-inventario-fisico',
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
  templateUrl: './fisico.html',
  styleUrls: ['./fisico.scss']
})
export class InventarioFisicoComponent implements OnInit {
  sucursales: any[] = [];
  sucursalSeleccionadaId: number = 1;
  resumen: ResumenInventario | null = null;
  items: any[] = [];
  cargando = true;
  mostrarModalEntrada = false;
  guardandoEntrada = false;

  formularioEntrada: any = {
    variante_id: null,
    cantidad: 10,
    costo_unitario: 50.0,
    nro_documento: '',
    motivo: 'Recepción de mercadería de fábrica'
  };

  columnas: string[] = ['prenda', 'sku', 'talla_color', 'stock_fisico', 'stock_reservado', 'stock_disponible', 'estado'];

  constructor(
    private http: HttpClient,
    private configService: ConfigService,
    private snackBar: MatSnackBar
  ) {}

  ngOnInit(): void {
    this.cargarSucursales();
  }

  cargarSucursales(): void {
    const url = this.configService.getApiUrl('sucursales');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.sucursales = Array.isArray(res) ? res : (res.results || []);
        if (this.sucursales.length > 0) {
          this.sucursalSeleccionadaId = this.sucursales[0].id;
          this.cargarInventario();
        } else {
          this.cargando = false;
        }
      },
      error: () => {
        this.cargando = false;
        this.snackBar.open('Error al cargar sucursales', 'Cerrar', { duration: 3000 });
      }
    });
  }

  cambiarSucursal(): void {
    this.cargarInventario();
  }

  cargarInventario(): void {
    this.cargando = true;
    const url = ${this.configService.getApiUrl('inventario-local')}sucursal//;
    this.http.get<ResumenInventario>(url).subscribe({
      next: (res) => {
        this.resumen = res;
        this.items = res.items || [];
        this.cargando = false;
      },
      error: () => {
        this.cargando = false;
        this.snackBar.open('Error al consultar inventario de la sucursal', 'Cerrar', { duration: 3000 });
      }
    });
  }

  abrirModalEntrada(): void {
    this.formularioEntrada = {
      variante_id: this.items.length > 0 ? this.items[0].variante_id : null,
      cantidad: 10,
      costo_unitario: 50.0,
      nro_documento: '',
      motivo: 'Recepción de mercadería de fábrica'
    };
    this.mostrarModalEntrada = true;
  }

  cerrarModalEntrada(): void {
    this.mostrarModalEntrada = false;
  }

  guardarEntrada(): void {
    if (!this.formularioEntrada.variante_id || this.formularioEntrada.cantidad <= 0) {
      this.snackBar.open('Selecciona una variante y cantidad válida', 'Cerrar', { duration: 2500 });
      return;
    }

    this.guardandoEntrada = true;
    const url = ${this.configService.getApiUrl('inventario-local')}entrada/;
    const body = {
      sucursal_id: this.sucursalSeleccionadaId,
      variante_id: this.formularioEntrada.variante_id,
      cantidad: this.formularioEntrada.cantidad,
      costo_unitario: this.formularioEntrada.costo_unitario,
      nro_documento: this.formularioEntrada.nro_documento,
      motivo: this.formularioEntrada.motivo
    };

    this.http.post<any>(url, body).subscribe({
      next: () => {
        this.guardandoEntrada = false;
        this.cerrarModalEntrada();
        this.snackBar.open('¡Entrada de mercadería registrada con éxito!', 'OK', { duration: 3500 });
        this.cargarInventario();
      },
      error: (err) => {
        this.guardandoEntrada = false;
        this.snackBar.open(err.error?.detail || 'Error al registrar entrada', 'Cerrar', { duration: 4000 });
      }
    });
  }
}

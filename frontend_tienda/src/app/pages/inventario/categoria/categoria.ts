import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { MatPaginatorModule, PageEvent } from '@angular/material/paginator';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSnackBar, MatSnackBarModule } from '@angular/material/snack-bar';
import { MatTableModule } from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatTabsModule } from '@angular/material/tabs';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { Subject, takeUntil } from 'rxjs';
import { Categoria } from 'src/app/models/inventario/categoria.model';
import { ApiService } from 'src/app/services/api.service';
import { ConfigService } from 'src/app/services/config.service';
import { PermisosService } from 'src/app/services/permisos.service';
import { CrearCategoriaComponent } from './crear-categoria/crear-categoria';
import { EliminarCategoriaComponent } from './eliminar-categoria/eliminar-categoria';
import { MarcaComponent } from '../marca/marca';

@Component({
  selector: 'app-categoria',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatTableModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatButtonModule,
    MatIconModule,
    MatCardModule,
    MatSnackBarModule,
    MatTooltipModule,
    MatDialogModule,
    MatTabsModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MarcaComponent
  ],
  templateUrl: './categoria.html',
  styleUrl: './categoria.scss',
})
export class CategoriaComponent implements OnInit, OnDestroy {
  displayedColumns: string[] = ['id', 'nombre', 'acciones'];
  dataSource: Categoria[] = [];
  tallas: any[] = [];
  colores: any[] = [];
  temporadas: any[] = [];

  isLoading = false;
  cargandoTallas = false;
  cargandoColores = false;
  cargandoTemporadas = false;

  puedeVerCategoria = true;
  puedeCrear = true;
  puedeEditar = true;
  puedeEliminar = true;
  puedeVerMarca = true;

  mostrarModalTalla = false;
  mostrarModalColor = false;
  mostrarModalTemporada = false;

  formTalla: any = { medida: '', tipo: 'TEXTIL', guia_medida: 'Estándar' };
  formColor: any = { nombre: '', codigo_hex: '#1E3A8A' };
  formTemporada: any = { nombre: '' };

  private apiUrl: string;
  private destroy$ = new Subject<void>();

  constructor(
    private http: HttpClient,
    private apiService: ApiService,
    private configService: ConfigService,
    private snackBar: MatSnackBar,
    private dialog: MatDialog,
    private permisosService: PermisosService
  ) {
    this.apiUrl = this.configService.getApiUrl('categorias');
  }

  ngOnInit(): void {
    this.loadCategorias();
    this.loadTallas();
    this.loadColores();
    this.loadTemporadas();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  loadCategorias(): void {
    this.isLoading = true;
    this.http.get<any>(this.apiUrl).subscribe({
      next: (res) => {
        this.dataSource = Array.isArray(res) ? res : (res.results || []);
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      }
    });
  }

  loadTallas(): void {
    this.cargandoTallas = true;
    const url = this.configService.getApiUrl('tallas');
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.tallas = Array.isArray(res) ? res : (res.results || []);
        this.cargandoTallas = false;
      },
      error: () => this.cargandoTallas = false
    });
  }

  loadColores(): void {
    this.cargandoColores = true;
    const url = ${this.configService.getApiUrl('parametros')}colores/;
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.colores = Array.isArray(res) ? res : (res.results || []);
        this.cargandoColores = false;
      },
      error: () => this.cargandoColores = false
    });
  }

  loadTemporadas(): void {
    this.cargandoTemporadas = true;
    const url = ${this.configService.getApiUrl('parametros')}temporadas/;
    this.http.get<any>(url).subscribe({
      next: (res) => {
        this.temporadas = Array.isArray(res) ? res : (res.results || []);
        this.cargandoTemporadas = false;
      },
      error: () => this.cargandoTemporadas = false
    });
  }

  crearCategoria(): void {
    const dialogRef = this.dialog.open(CrearCategoriaComponent, {
      width: '500px',
      disableClose: true,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        this.loadCategorias();
      }
    });
  }

  editarCategoria(categoria: Categoria): void {
    const dialogRef = this.dialog.open(CrearCategoriaComponent, {
      width: '500px',
      disableClose: true,
      data: categoria,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        this.loadCategorias();
      }
    });
  }

  eliminarCategoria(categoria: Categoria): void {
    const dialogRef = this.dialog.open(EliminarCategoriaComponent, {
      width: '400px',
      data: categoria,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        this.loadCategorias();
      }
    });
  }

  abrirModalTalla(): void {
    this.formTalla = { medida: '', tipo: 'TEXTIL', guia_medida: 'Estándar' };
    this.mostrarModalTalla = true;
  }

  guardarTalla(): void {
    if (!this.formTalla.medida) return;
    const url = this.configService.getApiUrl('tallas');
    this.http.post<any>(url, this.formTalla).subscribe({
      next: () => {
        this.mostrarModalTalla = false;
        this.snackBar.open('Talla guardada', 'OK', { duration: 2500 });
        this.loadTallas();
      },
      error: (err) => this.snackBar.open(err.error?.detail || 'Error al guardar talla', 'Cerrar', { duration: 3000 })
    });
  }

  eliminarTalla(t: any): void {
    if (confirm(¿Eliminar talla ?)) {
      const url = ${this.configService.getApiUrl('tallas')}/;
      this.http.delete(url).subscribe({
        next: () => {
          this.snackBar.open('Talla eliminada', 'OK', { duration: 2500 });
          this.loadTallas();
        },
        error: (err) => this.snackBar.open(err.error?.detail || 'No se puede eliminar', 'Cerrar', { duration: 3000 })
      });
    }
  }

  abrirModalColor(): void {
    this.formColor = { nombre: '', codigo_hex: '#1E3A8A' };
    this.mostrarModalColor = true;
  }

  guardarColor(): void {
    if (!this.formColor.nombre) return;
    const url = ${this.configService.getApiUrl('parametros')}colores/;
    this.http.post<any>(url, this.formColor).subscribe({
      next: () => {
        this.mostrarModalColor = false;
        this.snackBar.open('Color guardado', 'OK', { duration: 2500 });
        this.loadColores();
      },
      error: (err) => this.snackBar.open(err.error?.detail || 'Error al guardar color', 'Cerrar', { duration: 3000 })
    });
  }

  eliminarColor(c: any): void {
    if (confirm(¿Eliminar color ?)) {
      const url = ${this.configService.getApiUrl('parametros')}colores//;
      this.http.delete(url).subscribe({
        next: () => {
          this.snackBar.open('Color eliminado', 'OK', { duration: 2500 });
          this.loadColores();
        },
        error: (err) => this.snackBar.open(err.error?.detail || 'No se puede eliminar', 'Cerrar', { duration: 3000 })
      });
    }
  }

  abrirModalTemporada(): void {
    this.formTemporada = { nombre: '' };
    this.mostrarModalTemporada = true;
  }

  guardarTemporada(): void {
    if (!this.formTemporada.nombre) return;
    const url = ${this.configService.getApiUrl('parametros')}temporadas/;
    this.http.post<any>(url, this.formTemporada).subscribe({
      next: () => {
        this.mostrarModalTemporada = false;
        this.snackBar.open('Temporada guardada', 'OK', { duration: 2500 });
        this.loadTemporadas();
      },
      error: (err) => this.snackBar.open(err.error?.detail || 'Error al guardar temporada', 'Cerrar', { duration: 3000 })
    });
  }

  eliminarTemporada(tp: any): void {
    if (confirm(¿Eliminar temporada ?)) {
      const url = ${this.configService.getApiUrl('parametros')}temporadas//;
      this.http.delete(url).subscribe({
        next: () => {
          this.snackBar.open('Temporada eliminada', 'OK', { duration: 2500 });
          this.loadTemporadas();
        },
        error: (err) => this.snackBar.open(err.error?.detail || 'No se puede eliminar', 'Cerrar', { duration: 3000 })
      });
    }
  }
}

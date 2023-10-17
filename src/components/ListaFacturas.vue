<template>
  <div>
    <h1>Listado de Facturas</h1>
    <div>
      <label for="fechaInicio">Desde:</label>
      <input type="date" v-model="fechaInicio" id="fechaInicio" />
      <label for="fechaFin">Hasta:</label>
      <input type="date" v-model="fechaFin" id="fechaFin" />
      <button @click="filtrarPorFechas">Filtrar</button>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>Fecha</th>
          <th>Cliente</th>
          <th>Número</th>
          <th>Estado de la factura</th>
          <th>CDC</th>
          <!-- Agregar más columnas según los datos -->
        </tr>
      </thead>
      <tbody>
        <tr v-for="factura in facturas" :key="factura.internalId">
          <td>{{ factura.fecha_factura }}</td>
          <td>{{ factura.cliente }}</td>
          <td>{{ factura.nro_factura }}</td>
          <td :class="estadoColor(factura.state_factura)">{{ factura.state_factura }}</td> <!-- Aplicar color según estado -->
          <td>{{ factura.cdc.slice(-5) }}</td>
          <!-- Agregar más celdas según los datos -->
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "ListaFacturas",
  data() {
    // Obtenemos la fecha actual y la primera fecha del mes
    const fechaActual = new Date();
    const primerDiaDelMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1);

    return {
      facturas: [],
      fechaInicio: primerDiaDelMes.toISOString().split('T')[0], // Fecha de inicio del mes actual
      fechaFin: fechaActual.toISOString().split('T')[0], // Fecha actual
      ordenAscendente: true,
    };
  },
  methods: {
    estadoColor(estado) { // Método para determinar la clase según el estado
      switch (estado) {
        case "Rechazado":
          return "text-danger";
        case "Aprobado":
          return "text-success";
        case "En espera":
          return "text-warning";
        default:
          return "";
      }
    },
    async obtenerFacturas() {
      let facturas;
      await axios.get(`${process.env.VUE_APP_API_URL}/facturas/tosco/`).then((response) => {
        facturas = response.data; // Asignamos las facturas desde la respuesta
      });

      if (this.fechaInicio || this.fechaFin) {
        facturas = facturas.filter(factura => {
          const fechaFactura = new Date(factura.fecha_factura);
          const fechaInicio = this.fechaInicio ? new Date(this.fechaInicio) : null;
          const fechaFin = this.fechaFin ? new Date(this.fechaFin) : null;
          return (!fechaInicio || fechaFactura >= fechaInicio) && (!fechaFin || fechaFactura <= fechaFin);
        });
      }
      this.facturas = facturas.sort((a, b) => this.ordenAscendente ? new Date(a.fecha_factura) - new Date(b.fecha_factura) : new Date(b.fecha_factura) - new Date(a.fecha_factura));
    },
    ordenarPorFecha() {
      this.ordenAscendente = !this.ordenAscendente; // Cambiar la dirección de la ordenación
      this.obtenerFacturas();
    },
    filtrarPorFechas() {
      this.obtenerFacturas(); // Llamar a obtener facturas con los nuevos filtros
    },
  },
  async mounted() {
    await this.obtenerFacturas();

    // Refrescar las facturas automáticamente cada 5 segundos
    setInterval(async () => {
      await this.obtenerFacturas();
    }, 5000);
  },
};
</script>

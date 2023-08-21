<template>
    <div>
      <h1>Listado de Documentos</h1>
      <div class="row">
        <div class="col-md-4 mb-4" v-for="documento in documentos" :key="documento.internalId">
          <div :class="['card', getCardClass(documento.state_factura)]">
            <div class="card-body">
              <h5 class="card-title">Cliente: {{ documento.cliente }}</h5>
              <p class="card-text">Fecha de factura: {{ documento.fecha_factura }}</p>
              <p class="card-text">Número de factura: {{ documento.nro_factura }}</p>
              <p class="card-text">Estado de la factura: {{ documento.state_factura }}</p>
              <p class="card-text">CDC: {{ documento.cdc }}</p>
              <p class="card-text">Estado: {{ documento.status }}</p>
              <p class="card-text">Inválido: {{ documento.invalid }}</p>
              <p class="card-text">Documento: {{ documento.document }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
        return {
            documentos: [],
        }
    },
    mounted() {
      this.fetchDocumentos();
    },
    methods: {
      async fetchDocumentos() {
        try {
          const response = await axios.get('http://192.168.102.169:5010/facturas/tosco/', {
            params: {
              page: 1, // Puedes ajustar el número de página según sea necesario
            },
          });
          if (response.data === null) {
            this.documentos = [];
          } else {
            this.documentos = response.data;
          }
        } catch (error) {
          console.error('Error al obtener los documentos', error);
        }
      },
      getCardClass(state) {
        if (state === 'Rechazado') {
            return 'bg-danger';
        } else if (state === 'Aprobado') {
            return 'bg-success';
        } else if (state === 'En espera') {
            return 'bg-warning';
        } else if (state === 'Impreso') {
            return 'bg-info';
        } else {
            return 'bg-pink'; // Fondo rosado para otros estados
        }
        },
    },
  };
  </script>
  

  <style scoped>
  /* Estilos personalizados */
  .card {
    margin: 10px; /* Agrega márgenes alrededor de cada tarjeta */
  }
  
  .card-body {
    padding: 0.5rem; /* Ajusta el espaciado interno de la tarjeta */
  }
  
  @media (max-width: 576px) {
    .mb-4 {
      margin-bottom: 10px !important; /* Reduce el espaciado entre las tarjetas en dispositivos móviles */
    }
  }
  </style>

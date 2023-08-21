<template>
    <div id="app">
      <ListaFacturas />
      <br/>
      <br/>
      <br/>
      <ListaRemisiones /> <!-- Actualiza el nombre del componente aquí -->
    </div>
  </template>
  
  <script>
  import ListaFacturas from "./components/ListaFacturas.vue"; // Actualiza la importación aquí
  import ListaRemisiones from "./components/ListaRemisiones.vue";
  
  export default {
    components: {
      ListaFacturas,
      ListaRemisiones, // Y aquí también
    },
  };
  </script>
  
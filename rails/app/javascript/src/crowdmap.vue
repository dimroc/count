<template>
  <section class="crowd-map">
    <img :src="frame.density_map_url"/>
  </section>
</template>

<script>
export default {
  data: () => {
    return {}
  },
  props: ['frame']
}
</script>

<style scoped lang="scss">

</style>

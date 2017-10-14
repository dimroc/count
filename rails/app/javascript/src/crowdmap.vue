<template>
  <section class="crowd-map">
    <img :src="frame.density_map_url"/>
  </section>

  <!--<section class="raw-feed">-->
    <!--<h4>Raw Feed</h4>-->
  <!--</section>-->
</template>

<script>
export default {
  props: ['frame']
}
</script>

<style scoped lang="scss">
</style>

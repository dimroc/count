<template>
  <section class="crowdmap">
    <img :src="frame.density_map_url"/>
    <img :src="frame.image_url"/>
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
.crowdmap {
  margin: auto;
  > img {
    width: 200px;
  }
}
</style>

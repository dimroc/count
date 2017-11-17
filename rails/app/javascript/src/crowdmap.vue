<template>
  <section class="crowdmap">
    <a :href="frame.density_map_url" target="_blank">
      <img :ix-src="frame.density_map_url" sizes="200w"/>
    </a>
    <a :href="frame.image_url" target="_blank">
      <img :ix-src="frame.image_url" sizes="200w"/>
    </a>
  </section>
</template>

<script>
export default {
  props: ['frame'],
  mounted: function () {
    imgix.init({ host: 'countingcompany.imgix.net' });
  }
}
</script>

<style scoped lang="scss">
.crowdmap {
  margin: auto;
  img {
    width: 200px;
    border-radius: 10px;
  }
}
</style>

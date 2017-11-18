<template>
  <section class="crowdmap">
    <a :href="current.density_map_url" target="_blank">
      <img :ix-src="current.density_map_url" sizes="200w"/>
    </a>
    <a :href="current.image_url" target="_blank">
      <img :ix-src="current.image_url" sizes="200w"/>
    </a>
  </section>
</template>

<script>
export default {
  props: ['current'],
  mounted: function() {
    imgix.init({ host: 'countingcompany.imgix.net' });
  },
  watch: {
    current: function() {
      this.$nextTick(() => imgix.init({ host: 'countingcompany.imgix.net', force: true }))
    }
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

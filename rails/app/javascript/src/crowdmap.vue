<template>
  <section class="crowdmap">
    <a :href="current.density_map_url" target="_blank" class="fuzzbox">
      <img :ix-src="current.density_map_url" sizes="200px"/>
    </a>
    <a :href="current.image_url" target="_blank">
      <img :ix-src="current.image_url" sizes="200px"/>
    </a>
  </section>
</template>

<script>
export default {
  props: ['current'],
  mounted: function() {
    imgix.init({ host: 'count-dimroc.imgix.net' });
  },
  watch: {
    current: function() {
      this.$nextTick(() => imgix.init({ host: 'count-dimroc.imgix.net', force: true }))
    }
  }
}
</script>

<style scoped lang="scss">
.crowdmap {
  margin: auto;
  text-align: center;
  img {
    width: 170px;
    border-radius: 2px;
    border: 1px solid #eff2f4;
  }

  small {
    display: block;
    max-width: 500px;
    margin-top: 20px;
  }
}
</style>

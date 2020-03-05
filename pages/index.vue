<template>
  <div id='home'>
    <section id='home-01' class='flex'>
      <h1 class='tit white'>
        プロ野球を楽しもう
      </h1>
    </section>
    <section id='home-02' class='flex'>
      <div>
        <h2 class='home-tit'>
          サイト概要
        </h2>
        <p class="text-center">
          プロ野球関連の楽しいコンテンツを<br>たくさん配信していきます！
        </p>
      </div>
    </section>
    <section id='home-03' class='flex'>
      <h2 class='home-tit'>
        セリーグ 2020
      </h2>
      <div v-for="team in api_data['central']" class='mb-1'>
        <a :href="getOpeningStartingLineupLink(team['name_en'])" class='white'>{{ team['name'] }}</a>
      </div>
    </section>
    <section id='home-04' class='flex'>
      <h2 class='home-tit'>
        パリーグ 2020
      </h2>
      <div v-for="team in api_data['pacific']" class='mb-1'>
        <a :href="getOpeningStartingLineupLink(team['name_en'])" class='white'>{{ team['name'] }}</a>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData () {
    const { data } = await axios.get(`http://sports-web/api/`)
    return { api_data: data }
  },
  methods: {
    getTeamImage: function(name) {
      return `/_nuxt/assets/images/common/team-logos/${name}.jpg`;
    },
    getOpeningStartingLineupLink: function(name) {
      return `opening_starting_lineup/${name}/2020`;
    }
  }
}
</script>

<style>
</style>

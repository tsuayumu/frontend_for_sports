<template>
  <div :id="api_data['league']['name_en']" class="pt-3">
    <h3 class='page-tit white'>{{ api_data['league']['name'] }}</h3>
    <div v-if="is_create_ranking" class='form-content container'>
      <form @submit.prevent="create_ranking">
        <div class="back-break">
          <table border="0" width="100%">
            <tr v-for="n of 6" style="text-align: center">
              <td>{{ n }}位</td>
              <td>
                <select v-model="api_data['selected_teams'][n-1]">
                  <option v-for="team in api_data['select_teams']" :value="team['id']">{{ team['name'] }}</option>
                </select>
              </td>
            </tr>
          </table>
        </div>
        <input type='submit' value='投稿'>
      </form>
    </div>

    <div class="container">
      <h5 class="text-dark bg-light my-3 p-1">投稿一覧</h5>
      <div class="row">
        <div v-for="ranking_manage in api_data['ranking_manages']" class="col-sm-4 bbs-contet mb-3">
          <section class='member white'>
            <div class="back-break">
              <table border="0" width="100%">
                <tr v-for="(ranking, index) in ranking_manage['rankings']" style="text-align: center">
                  <td>{{ index + 1 }}位</td>
                  <td>{{ ranking['name'] }}</td>
                </tr>
              </table>
            </div>
          </section>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params }) {
    const { data } = await axios.get(`http://sports-web/api/ranking/${params.league}/${params.year}`)
    return { api_data: data }
  },
  data() {
    return {
      is_create_ranking: true
    }
  },
  methods: {
    async create_ranking () {
      const { data } = await axios.post(`http://localhost:4000/api/ranking_manage`, {
        year: this.api_data['year'],
        league_id: this.api_data['league']['id'],
        ranking: [
          this.api_data['selected_teams'][0],
          this.api_data['selected_teams'][1],
          this.api_data['selected_teams'][2],
          this.api_data['selected_teams'][3],
          this.api_data['selected_teams'][4],
          this.api_data['selected_teams'][5]
        ]
      })
      this.api_data['ranking_manages'].unshift(
        {
          rankings: data['rankings']
        }
      )
      this.is_create_ranking = false
    }
  }
}
</script>


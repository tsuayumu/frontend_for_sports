<template>
  <div :id="api_data['team']['name_en']" class="pt-3">
    <h3 class='page-tit white'>{{ api_data['team']['name'] }}</h3>
    <div v-if="is_create_lineup" class='form-content container'>
      <form @submit.prevent="create_lineup">
        <div class="back-break">
          <table border="0" width="100%">
            <tr style="text-align: center">
              <td></td>
              <td>選手名</td>
              <td>打率</td>
              <td>本塁打</td>
              <td>打点</td>
            </tr>
            <tr v-for="n of 9" style="text-align: center">
              <td>{{ n }}番</td>
              <td>
                <select v-model="api_data['selected_players'][n-1]">
                  <option v-for="player in api_data['select_players']" :value="player['batter_id']">{{ player['name'] }}</option>
                </select>
              </td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'average') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'homerun') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'rbi') }}</td>
            </tr>
          </table>
        </div>
        <div class='block'>
          いちおしポイント
          <br>
          <input type='text' v-model="comment">
        </div>
        <input type='submit' value='投稿'>
      </form>
    </div>

    <div class="container">
      <p class="white text-center" v-if="error_message">
        {{ error_message }}
      </p>
    </div>

    <div class="container">
      <h5 class="text-dark bg-light my-3 p-1">投稿一覧</h5>
      <div v-for="lineup_manage in api_data['lineup_manages']" class="bbs-contet mb-3">
        <h6 class="text-center white manage-tit">
          {{ lineup_manage['comment'] }}
        </h6>
        <div class="row">
          <section class='member white col-sm-5'>
            <div class="back-break">
              <table border="0" width="100%">
                <tr style="text-align: center">
                  <td></td>
                  <td>選手名</td>
                  <td>打率</td>
                  <td>本塁打</td>
                  <td>打点</td>
                </tr>
                <tr v-for="(player, index) in lineup_manage['lineups']" style="text-align: center">
                  <td>{{ index + 1 }}番</td>
                  <td>{{ player['name'] }}</td>
                  <td>{{ player['average'] }}</td>
                  <td>{{ player['homerun'] }}</td>
                  <td>{{ player['rbi'] }}</td>
                </tr>
              </table>
            </div>
          </section>
          <section class='member col-sm-7 py-1 text-dark'>
            <div class="coment">
              <form @submit.prevent="create_user_comment(lineup_manage['id'])" class="py-2">
                <input type='text' v-model="user_comment">
                <input class="btn btn-light comment-btn" type="submit" value="投稿">
                <button v-bind:disabled="lineup_manage['like_flg']" v-on:click="count_like(lineup_manage)" class="btn btn-light comment-btn" type="button">いいね {{ lineup_manage['like'] }}</button>
              </form>
              <div class="text-coment">
                <p v-for="user_comment in lineup_manage['user_comments']" class="mb-1">
                  {{ user_comment }}
                </p>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>
    <div class="footer-nav text-center text-muted py-sm-4 py-3 fixed-bottom">
      <div class="row">
        <a class="col-6 border-right" :href="left_href()">
          ＜　順位予想
        </a>
        <a class="col-6" :href="right_href()">
          ローテーション　＞
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params, route }) {
    const { data } = await axios.get(`https://sports-memory.com/api/lineup_manage/${params.team}/${params.year}`)
    return { api_data: data }
  },
  data() {
    return {
      is_create_lineup: true
    }
  },
  methods: {
    async create_lineup () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'Lineup',
        'value': 1
      });
      const { data } = await axios.post(`https://sports-memory.com/api/lineup_manage`, {
        year: this.api_data['year'],
        team_id: this.api_data['team']['id'],
        lineup: [
          this.api_data['selected_players'][0],
          this.api_data['selected_players'][1],
          this.api_data['selected_players'][2],
          this.api_data['selected_players'][3],
          this.api_data['selected_players'][4],
          this.api_data['selected_players'][5],
          this.api_data['selected_players'][6],
          this.api_data['selected_players'][7],
          this.api_data['selected_players'][8]
        ],
        comment: this.comment
      })

      if(data['error_message'] == 'すでに登録済みです') {
        this.error_message = 'ご登録ありがとうございます、すでに登録済みの打順でしたmm'
      } else {
        this.api_data['lineup_manages'].unshift(
          {
            id: data['id'],
            lineups: data['lineups'],
            comment: data['comment'],
            user_comments: []
          }
        )
      }
      this.is_create_lineup = false
    },
    async create_user_comment (lineup_manage_id) {
      this.$gtag('event', 'クリック計測', {
        'event_category': 'コメント',
        'event_label': 'Lineup',
        'value': 1
      });
      const { data } = await axios.post(`https://sports-memory.com/api/lineup_manage_user_comment`, {
        lineup_manage_id: lineup_manage_id,
        user_comment: this.user_comment
      })
      this.user_comment = '';
      for(var index in this.api_data['lineup_manages']) {
        if(this.api_data['lineup_manages'][index]['id'] == lineup_manage_id){
          this.api_data['lineup_manages'][index]['user_comments'].push(data['user_comment']);
        }
      }
    },
    async count_like (lineup_manage) {
      this.$gtag('event', 'クリック計測', {
        'event_category': 'いいね',
        'event_label': 'Lineup',
        'value': 1
      });
      const { data } = await axios.post(`https://sports-memory.com/api/lineup_manage_like`, {
        lineup_manage_id: lineup_manage['id']
      })
      lineup_manage['like'] = data['like']
      lineup_manage['like_flg'] = true
    },
    player_record: function (batter_id, record) {
      for(var index in this.api_data['select_players']){
        if(this.api_data['select_players'][index]['batter_id'] == batter_id){
          return this.api_data['select_players'][index][record];
        }
      }
    },
    left_href: function() {
      return `/ranking/${this.api_data['league']['name_en']}/${this.api_data['year']}`
    },
    right_href: function() {
      return `/opening_rotation/${this.api_data['team']['name_en']}/${this.api_data['year']}`
    }
  }
}
</script>


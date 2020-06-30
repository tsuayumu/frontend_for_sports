<template>
  <div :id="api_data['team']['name_en']" class="pt-3 text-center">
    <h3 class='page-tit white'>本日の見所<br>{{ api_data['team']['name'] }}戦<br>{{ api_data['date'] }}</h3>

    <div class='form-content container'>
      <form @submit.prevent="update_lineup">
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
                  <option v-for="batter in api_data['select_players']" :value="batter['batter_id']">{{ batter['name'] }}</option>
                </select>
              </td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'average') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'homerun') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'rbi') }}</td>
            </tr>
          </table>
        </div>
        <input v-if="is_update_lineup" type='submit' value='更新'>
      </form>
    </div>

    <form @submit.prevent="create_highlight" class="py-3">
      <div class='block'>
        <textarea v-model="comment" rows="4" cols="35" placeholder="あなたの見所は？"></textarea>
      </div>
      <input type='submit' value='投稿'>
    </form>

    <div class="container" style="white-space: pre-line;">
      <h5 class="text-dark bg-light my-3 p-1">みんなの見所</h5>
      <div v-for="highlight_text in api_data['highlight_texts']" class="bbs-contet mb-3">
        <p class="white manage-tit text-left">{{highlight_text}}</p>
      </div>
    </div>

    <div class="footer-nav text-center text-muted py-sm-4 py-3 fixed-bottom">
      <div class="row">
        <a class="col-6 border-right" :href="left_href()">
          ＜　前の日の見所
        </a>
        <a class="col-6" :href="right_href()">
          次の日の見所　＞
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params }) {
    // 開発 http://sports-web
    // 本番 http://sports-memory.com
    const { data } = await axios.get(`http://sports-memory.com/api/game_highlight/${params.team}/${params.date}`)
    return {
      api_data: data
    }
  },
  data() {
    return {
      is_update_lineup: true
    }
  },
  methods: {
    async update_lineup () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'DailyLineup',
        'value': 1
      });
      const { data } = await axios.post(`http://sports-memory.com/api/daily_lineup_manage`, {
        date: this.api_data['date'],
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
        ]
      })
      this.is_update_lineup = false
    },
    async create_highlight () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'Highlight',
        'value': 1
      });
      // 開発 http://localhost:4000
      // 本番 http://sports-memory.com
      const { data } = await axios.post(`http://sports-memory.com/api/game_highlight`, {
        date: this.api_data['date'],
        team_id: this.api_data['team']['id'],
        text: this.comment
      })
      this.api_data['highlight_texts'].unshift(this.comment)
    },
    left_href: function() {
      return `/game_highlight/${this.api_data['team']['name_en']}/${Number(this.api_data['date_integer'])-1}`
    },
    right_href: function() {
      return `/game_highlight/${this.api_data['team']['name_en']}/${Number(this.api_data['date_integer'])+1}`
    },
    player_record: function (batter_id, record) {
      for(var index in this.api_data['select_players']){
        if(this.api_data['select_players'][index]['batter_id'] == batter_id){
          return this.api_data['select_players'][index][record];
        }
      }
    }
  }
}
</script>

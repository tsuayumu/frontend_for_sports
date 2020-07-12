<template>
  <div :id="game_highligt_data['team']['name_en']" class="pt-3 text-center">
    <h3 class='page-tit white'>本日の見所<br>{{ game_highligt_data['team']['name'] }}戦<br>{{ game_highligt_data['date'] }}</h3>

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
                <select v-model="daily_lineup_data['selected_players'][n-1]">
                  <option v-for="batter in daily_lineup_data['select_players']" :value="batter['batter_id']">{{ batter['name'] }}</option>
                </select>
              </td>
              <td>{{ player_record(daily_lineup_data['selected_players'][n-1], 'average') }}</td>
              <td>{{ player_record(daily_lineup_data['selected_players'][n-1], 'homerun') }}</td>
              <td>{{ player_record(daily_lineup_data['selected_players'][n-1], 'rbi') }}</td>
            </tr>
          </table>
        </div>
        <input v-if="is_update_lineup" type='submit' value='更新'>
      </form>
    </div>

    <div>
      <div class="container" style="white-space: pre-line;">
        <h5 class="text-dark bg-light my-3 p-1">みんなの見所</h5>
        <div v-for="highlight_text in game_highligt_data['highlight_texts']" class="bbs-contet mb-3">
          <p class="white manage-tit text-left">{{highlight_text}}</p>
        </div>
      </div>
    </div>

    <div>
      <div class="container" style="white-space: pre-line;">
        <h5 class="text-dark bg-light my-3 p-1">みんなのコメント</h5>
        <div v-for="(inning_text, index) in game_data['inning_texts']" class="bbs-contet mb-3">
          <div class="white text-left bg-secondary px-1 py-2" style="white-space: pre-line">
            <h6 class=''>{{ inning_text['inning'] }}</h6>
            <p class="mb-1">{{inning_text['text']}}</p>
          </div>
          <div v-for="game_comment_text in game_comment_data['game_comment_texts']" class="bbs-contet mb-3">
            <p v-if="game_comment_text['comment_at'] < inning_text['updated_at']" class="white manage-tit text-left">{{game_comment_text['text']}}</p>
          </div>
        </div>
        <div v-for="game_comment_text in game_comment_data['game_comment_texts']" class="bbs-contet mb-3">
          <p v-if="game_comment_text['comment_at'] > game_data['inning_texts'][game_data['inning_texts'].length - 1]['updated_at']" class="white manage-tit text-left">{{game_comment_text['text']}}</p>
        </div>
      </div>
    </div>

    <div class="footer-nav text-center text-muted py-1 fixed-bottom">
      <div class="container">
        <form v-if="game_data['inning_texts'].length == 0" @submit.prevent="create_highlight" class="py-1 row" style="width: 100%; margin: 0 auto;">
          <input type="text" v-model="highligt_comment" placeholder="あなたの見所は？" class='col-10'></input>
          <div class="col-2 text-center">
            <input type='submit' value='投稿'>
          </div>
        </form>
        <form v-if="game_data['inning_texts'].length > 0" @submit.prevent="create_game_comment" class="py-1 row" style="width: 100%; margin: 0 auto;">
          <input type="text" v-model="game_comment" placeholder="試合のコメントをどうそ！" class='col-10'></input>
          <div class="col-2 text-center">
            <input type='submit' value='投稿'>
          </div>
        </form>
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
    // 2つのHTTPのレスポンスを受けてからページがレンダリングされる
    const [game_data, game_highligt_data, daily_lineup_data, game_comment_data] = await Promise.all([
      axios.get(`http://sports-web/api/game/${params.team}/${params.date}`),
      axios.get(`http://sports-web/api/game_highlight/${params.team}/${params.date}`),
      axios.get(`http://sports-web/api/daily_lineup_manage/${params.team}/${params.date}`),
      axios.get(`http://sports-web/api/game_comment/${params.team}/${params.date}`)
    ]);
    console.log(game_data['data'])
    return {
      game_data: game_data['data'],
      game_highligt_data: game_highligt_data['data'],
      daily_lineup_data: daily_lineup_data['data'],
      game_comment_data: game_comment_data['data']
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
      // 開発 http://localhost:4000
      // 本番 http://sports-memory.com
      const { data } = await axios.post(`http://sports-memory.com/api/daily_lineup_manage`, {
        date: this.daily_lineup_data['date'],
        team_id: this.daily_lineup_data['team']['id'],
        lineup: [
          this.daily_lineup_data['selected_players'][0],
          this.daily_lineup_data['selected_players'][1],
          this.daily_lineup_data['selected_players'][2],
          this.daily_lineup_data['selected_players'][3],
          this.daily_lineup_data['selected_players'][4],
          this.daily_lineup_data['selected_players'][5],
          this.daily_lineup_data['selected_players'][6],
          this.daily_lineup_data['selected_players'][7],
          this.daily_lineup_data['selected_players'][8]
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
        date: this.game_highligt_data['date'],
        team_id: this.game_highligt_data['team']['id'],
        text: this.highligt_comment
      })
      this.highligt_comment = ''
      this.game_highligt_data['highlight_texts'].unshift(this.highligt_comment)
    },
    async create_game_comment () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'GameComment',
        'value': 1
      });
      // 開発 http://localhost:4000
      // 本番 http://sports-memory.com
      const { data } = await axios.post(`http://localhost:4000/api/game_comment`, {
        date: this.game_comment_data['date'],
        team_id: this.game_comment_data['team']['id'],
        text: this.game_comment
      })
      this.game_comment = ''
      this.game_comment_data['game_comment_texts'].unshift(
        {
          text: data['text'],
          comment_at: data['comment_at']
        }
      )
    },
    async switch_game_highlight() {
      this.is_visible_highlight = true
      this.is_visible_game_comment = false
    },
    async switch_game_comment() {
      this.is_visible_highlight = false
      this.is_visible_game_comment = true
    },
    player_record: function (batter_id, record) {
      for(var index in this.daily_lineup_data['select_players']){
        if(this.daily_lineup_data['select_players'][index]['batter_id'] == batter_id){
          return this.daily_lineup_data['select_players'][index][record];
        }
      }
    }
  }
}
</script>

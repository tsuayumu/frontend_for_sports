<template>
  <div :id="game_highligt_data['team']['name_en']" class="pt-3">
    <h3 class='page-tit white'>{{ game_highligt_data['date'] }}<br>{{ game_highligt_data['team']['name'] }}戦</h3>

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
          <p class="white text-left balloon1-left text-left">{{highlight_text}}</p>
        </div>
      </div>
    </div>

    <div>
      <div class="container" style="white-space: pre-line;">
        <h5 class="text-dark bg-light my-3 p-1">みんなのコメント</h5>
        <div v-for="(inning_text, index) in game_data['inning_texts']" class="bbs-contet mb-3">
          <div v-bind:id="'inning-' + index" class="white text-left bg-secondary px-2 py-2" style="white-space: pre-line; width: 100%;">
            <h6 class=''>{{ inning_text['inning'] }}</h6>
            <p class="mb-1">{{inning_text['text']}}</p>
          </div>
          <div v-for="(game_comment_text) in game_comment_data['game_comment_texts']" class="bbs-contet mb-3">
            <div v-if="index > 0 && game_data['inning_texts'][index-1]['updated_at'] < game_comment_text['comment_at']">
              <p v-if="game_comment_text['comment_at'] < inning_text['updated_at']" class="white text-left balloon1-left text-left">{{game_comment_text['text']}}</p>
            </div>
          </div>
        </div>
        <div v-for="game_comment_text in game_comment_data['game_comment_texts']" class="bbs-contet mb-3">
          <p v-if="game_comment_text['comment_at'] > game_data['inning_texts'][game_data['inning_texts'].length - 1]['updated_at']" class="white text-left balloon1-left text-left">{{game_comment_text['text']}}</p>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="row">
        <a class="col-6 text-center white" :href="left_href()">
          ＜ 前の日
        </a>
        <a class="col-6 text-center white" :href="right_href()">
          次の日 ＞
        </a>
      </div>
    </div>

    <div class="footer-nav text-center text-muted py-1 fixed-bottom">
      <div class="container">
        <form v-if="game_data['inning_texts'].length == 0" @submit.prevent="create_highlight" class="py-1 row" style="width: 100%; margin: 0 auto;">
          <input type="text" v-model="highligt_comment" placeholder="あなたの見所は？" class='col-10'></input>
          <div class="col-2 text-center">
            <input type='submit' value='▶︎'>
          </div>
        </form>
        <form v-if="game_data['inning_texts'].length > 0" @submit.prevent="create_game_comment" class="py-1 row" style="width: 100%; margin: 0 auto;">
          <input type="text" v-model="game_comment" placeholder="試合のコメントをどうそ！" class='col-10'></input>
          <div class="col-2 text-center">
            <input type='submit' value='▶︎'>
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
      axios.get(`http://sports-memory.com/api/game/${params.team}/${params.date}`),
      axios.get(`http://sports-memory.com/api/game_highlight/${params.team}/${params.date}`),
      axios.get(`http://sports-memory.com/api/daily_lineup_manage/${params.team}/${params.date}`),
      axios.get(`http://sports-memory.com/api/game_comment/${params.team}/${params.date}`)
    ]);
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
  mounted() {
    var headerHeight = 56
    var inningPos = []
    var inningPosHeight = []
    for (var i = 0; i <= 19; i++){
      var inning_id = '#inning-' + i;
      if ($( inning_id )[0]) {
        inningPos[i] = $( inning_id ).offset().top - headerHeight;
        inningPosHeight[i] = $( inning_id ).outerHeight() + headerHeight;
      }
    }

    $("html,body").animate({ duration: 'slow', easing: 'swing', scrollTop:$('body').outerHeight()});

    $( window ).on( 'scroll', function() {
      for (var i = 0; i < inningPos.length; i++){
        var inning_id = '#inning-' + i;
        if (i == inningPos.length - 1 ) {
          if ( inningPos[i] && inningPos[i] < $( this ).scrollTop()) {
            $( inning_id ).addClass( 'm_fixed' );
            $( inning_id ).css( 'width', $( '.bbs-contet' ).width() );
            $( 'body' ).css( 'padding-top', inningPosHeight[i] );
          } else {
            $( inning_id ).removeClass( 'm_fixed' );
          }
        } else {
          if ( inningPos[i] && inningPos[i] < $( this ).scrollTop() && inningPos[i+1] && $( this ).scrollTop() < inningPos[i+1]) {
            $( inning_id ).addClass( 'm_fixed' );
            $( inning_id ).css( 'width', $( '.bbs-contet' ).width() );
            $( 'body' ).css( 'padding-top', inningPosHeight[i] );
          } else {
            $( inning_id ).removeClass( 'm_fixed' );
          }
        }
      }
      if (inningPos[0] && inningPos[0] > $( this ).scrollTop()) {
        $( 'body' ).css( 'padding-top', 0 );
      }
    });
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
      this.game_highligt_data['highlight_texts'].push(this.highligt_comment)
      this.highligt_comment = ''
    },
    async create_game_comment () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'GameComment',
        'value': 1
      });
      // 開発 http://localhost:4000
      // 本番 http://sports-memory.com
      const { data } = await axios.post(`http://sports-memory.com/api/game_comment`, {
        date: this.game_comment_data['date'],
        team_id: this.game_comment_data['team']['id'],
        text: this.game_comment
      })
      this.game_comment = ''
      this.game_comment_data['game_comment_texts'].push(
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
    },
    left_href: function() {
      return `/game/${this.game_highligt_data['team']['name_en']}/${Number(this.game_highligt_data['date_integer'])-1}`
    },
    right_href: function() {
      return `/game/${this.game_highligt_data['team']['name_en']}/${Number(this.game_highligt_data['date_integer'])+1}`
    }
  }
}
</script>

<style>
  /* 吹き出し */
  .balloon1-left {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
    position: relative;
    display: inline-block;
    margin: 0 0 0 10px;
    padding: 7px 10px;
    min-width: 120px;
    max-width: 100%;
    color: #000;
    font-size: 16px;
    background: #fff;
    border-radius: 5px;
    z-index: 10;
  }
  .balloon1-left:before {
    content: "";
    display: inline-block;
    position: absolute;
    top: 3px; 
    left: -19px;
    border: 8px solid transparent;
    border-right: 18px solid #fff;
    -webkit-transform: rotate(35deg);
    transform: rotate(35deg);
  }
  .balloon1-left p {
    margin: 0;
    padding: 0;
  }

  .m_fixed {
    z-index: 20;
    position: fixed;
    top: 56px;
  }

</style>

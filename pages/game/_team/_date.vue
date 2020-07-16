<template>
  <div :id="game_highligt_data['team']['name_en']" class="pt-3">
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
    if ($( '#inning-0' )[0]) { var inningPos_0 = $( '#inning-0' ).offset().top; } else { var inningPos_0 = 1000000; }
    if ($( '#inning-1' )[0]) { var inningPos_1 = $( '#inning-1' ).offset().top; } else { var inningPos_1 = 1000000; }
    if ($( '#inning-2' )[0]) { var inningPos_2 = $( '#inning-2' ).offset().top; } else { var inningPos_2 = 1000000; }
    if ($( '#inning-3' )[0]) { var inningPos_3 = $( '#inning-3' ).offset().top; } else { var inningPos_3 = 1000000; }
    if ($( '#inning-4' )[0]) { var inningPos_4 = $( '#inning-4' ).offset().top; } else { var inningPos_4 = 1000000; }
    if ($( '#inning-5' )[0]) { var inningPos_5 = $( '#inning-5' ).offset().top; } else { var inningPos_5 = 1000000; }
    if ($( '#inning-6' )[0]) { var inningPos_6 = $( '#inning-6' ).offset().top; } else { var inningPos_6 = 1000000; }
    if ($( '#inning-7' )[0]) { var inningPos_7 = $( '#inning-7' ).offset().top; } else { var inningPos_7 = 1000000; }
    if ($( '#inning-8' )[0]) { var inningPos_8 = $( '#inning-8' ).offset().top; } else { var inningPos_8 = 1000000; }
    if ($( '#inning-9' )[0]) { var inningPos_9 = $( '#inning-9' ).offset().top; } else { var inningPos_9 = 1000000; }
    if ($( '#inning-10' )[0]) { var inningPos_10 = $( '#inning-10' ).offset().top; } else { var inningPos_10 = 1000000; }
    if ($( '#inning-11' )[0]) { var inningPos_11 = $( '#inning-11' ).offset().top; } else { var inningPos_11 = 1000000; }
    if ($( '#inning-12' )[0]) { var inningPos_12 = $( '#inning-12' ).offset().top; } else { var inningPos_12 = 1000000; }
    if ($( '#inning-13' )[0]) { var inningPos_13 = $( '#inning-13' ).offset().top; } else { var inningPos_13 = 1000000; }
    if ($( '#inning-14' )[0]) { var inningPos_14 = $( '#inning-14' ).offset().top; } else { var inningPos_14 = 1000000; }
    if ($( '#inning-15' )[0]) { var inningPos_15 = $( '#inning-15' ).offset().top; } else { var inningPos_15 = 1000000; }
    if ($( '#inning-16' )[0]) { var inningPos_16 = $( '#inning-16' ).offset().top; } else { var inningPos_16 = 1000000; }
    if ($( '#inning-17' )[0]) { var inningPos_17 = $( '#inning-17' ).offset().top; } else { var inningPos_17 = 1000000; }
    if ($( '#inning-18' )[0]) { var inningPos_18 = $( '#inning-18' ).offset().top; } else { var inningPos_18 = 1000000; }
    if ($( '#inning-19' )[0]) { var inningPos_19 = $( '#inning-19' ).offset().top; } else { var inningPos_19 = 1000000; }

    $( window ).on( 'scroll', function() {
      if ( $( this ).scrollTop() > inningPos_19 ) {
        $( '#inning-19' ).addClass( 'm_fixed' );
        $( '#inning-19' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-18' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_18 ) {
        $( '#inning-18' ).addClass( 'm_fixed' );
        $( '#inning-18' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-19' ).removeClass( 'm_fixed' );
        $( '#inning-17' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_17 ) {
        $( '#inning-17' ).addClass( 'm_fixed' );
        $( '#inning-17' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-18' ).removeClass( 'm_fixed' );
        $( '#inning-16' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_16 ) {
        $( '#inning-16' ).addClass( 'm_fixed' );
        $( '#inning-16' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-17' ).removeClass( 'm_fixed' );
        $( '#inning-15' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_15 ) {
        $( '#inning-15' ).addClass( 'm_fixed' );
        $( '#inning-15' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-16' ).removeClass( 'm_fixed' );
        $( '#inning-14' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_14 ) {
        $( '#inning-14' ).addClass( 'm_fixed' );
        $( '#inning-14' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-15' ).removeClass( 'm_fixed' );
        $( '#inning-13' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_13 ) {
        $( '#inning-13' ).addClass( 'm_fixed' );
        $( '#inning-13' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-14' ).removeClass( 'm_fixed' );
        $( '#inning-12' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_12 ) {
        $( '#inning-12' ).addClass( 'm_fixed' );
        $( '#inning-12' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-13' ).removeClass( 'm_fixed' );
        $( '#inning-11' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_11 ) {
        $( '#inning-11' ).addClass( 'm_fixed' );
        $( '#inning-11' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-12' ).removeClass( 'm_fixed' );
        $( '#inning-10' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_10 ) {
        $( '#inning-10' ).addClass( 'm_fixed' );
        $( '#inning-10' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-11' ).removeClass( 'm_fixed' );
        $( '#inning-9' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_9 ) {
        $( '#inning-9' ).addClass( 'm_fixed' );
        $( '#inning-9' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-10' ).removeClass( 'm_fixed' );
        $( '#inning-8' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_8 ) {
        $( '#inning-8' ).addClass( 'm_fixed' );
        $( '#inning-8' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-9' ).removeClass( 'm_fixed' );
        $( '#inning-7' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_7 ) {
        $( '#inning-7' ).addClass( 'm_fixed' );
        $( '#inning-7' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-8' ).removeClass( 'm_fixed' );
        $( '#inning-6' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_6 ) {
        $( '#inning-6' ).addClass( 'm_fixed' );
        $( '#inning-6' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-7' ).removeClass( 'm_fixed' );
        $( '#inning-5' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_5 ) {
        $( '#inning-5' ).addClass( 'm_fixed' );
        $( '#inning-5' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-6' ).removeClass( 'm_fixed' );
        $( '#inning-4' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_4 ) {
        $( '#inning-4' ).addClass( 'm_fixed' );
        $( '#inning-4' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-5' ).removeClass( 'm_fixed' );
        $( '#inning-3' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_3 ) {
        $( '#inning-3' ).addClass( 'm_fixed' );
        $( '#inning-3' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-4' ).removeClass( 'm_fixed' );
        $( '#inning-2' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_2 ) {
        $( '#inning-2' ).addClass( 'm_fixed' );
        $( '#inning-2' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-3' ).removeClass( 'm_fixed' );
        $( '#inning-1' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_1 ) {
        $( '#inning-1' ).addClass( 'm_fixed' );
        $( '#inning-1' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-2' ).removeClass( 'm_fixed' );
        $( '#inning-0' ).removeClass( 'm_fixed' );
      } else if ($( this ).scrollTop() > inningPos_0 ) {
        $( '#inning-0' ).addClass( 'm_fixed' );
        $( '#inning-0' ).css( 'width', $( '.bbs-contet' ).width() );
        $( '#inning-1' ).removeClass( 'm_fixed' );
      } else {
        $( '#inning-0' ).removeClass( 'm_fixed' );
        $( '#inning-1' ).removeClass( 'm_fixed' );
        $( '#inning-2' ).removeClass( 'm_fixed' );
        $( '#inning-3' ).removeClass( 'm_fixed' );
        $( '#inning-4' ).removeClass( 'm_fixed' );
        $( '#inning-5' ).removeClass( 'm_fixed' );
        $( '#inning-6' ).removeClass( 'm_fixed' );
        $( '#inning-7' ).removeClass( 'm_fixed' );
        $( '#inning-8' ).removeClass( 'm_fixed' );
        $( '#inning-9' ).removeClass( 'm_fixed' );
        $( '#inning-10' ).removeClass( 'm_fixed' );
        $( '#inning-11' ).removeClass( 'm_fixed' );
        $( '#inning-12' ).removeClass( 'm_fixed' );
        $( '#inning-13' ).removeClass( 'm_fixed' );
        $( '#inning-14' ).removeClass( 'm_fixed' );
        $( '#inning-15' ).removeClass( 'm_fixed' );
        $( '#inning-16' ).removeClass( 'm_fixed' );
        $( '#inning-17' ).removeClass( 'm_fixed' );
        $( '#inning-18' ).removeClass( 'm_fixed' );
        $( '#inning-19' ).removeClass( 'm_fixed' );
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

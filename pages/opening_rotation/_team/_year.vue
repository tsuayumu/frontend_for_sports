<template>
  <div :id="api_data['team']['name_en']" class="pt-3">
    <h3 class='page-tit white'>{{ api_data['team']['name'] }}</h3>
    <div v-if="is_create_rotation" class='form-content container'>
      <form class='' @submit.prevent="create_rotation">
        <div class="back-break">
          <table border="0" width="100%">
            <tr style="text-align: center">
              <td></td>
              <td>選手名</td>
              <td>試</td>
              <td>防</td>
              <td>勝</td>
              <td>敗</td>
              <td>H</td>
              <td>S</td>
            </tr>
            <tr v-for="n of 10" style="text-align: center">
              <td v-if="n == 1">先発</td>
              <td v-else-if="n == 7">中継ぎ</td>
              <td v-else-if="n == 10">守護神</td>
              <td v-else></td>
              <td>
                <select class="select-form" v-model="api_data['selected_players'][n-1]">
                  <option v-for="player in api_data['select_players']" :value="player['pitcher_id']">{{ player['name'] }}</option>
                </select>
              </td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'match') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'era') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'win') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'defeat') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'hold') }}</td>
              <td>{{ player_record(api_data['selected_players'][n-1], 'save_point') }}</td>
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
      <h5 class="text-dark bg-light my-3 p-1">投稿一覧</h5>
      <div v-for="rotation_manage in api_data['rotation_manages']" class="bbs-contet mb-3">
        <h6 class="text-center white manage-tit">
          {{ rotation_manage['comment'] }}
        </h6>
        <div class="row">
          <section class='member white col-sm-5'>
            <div class="back-break">
              <table border="0" width="100%">
                <tr style="text-align: center">
                  <td></td>
                  <td>選手名</td>
                  <td>試</td>
                  <td>防</td>
                  <td>勝</td>
                  <td>敗</td>
                  <td>H</td>
                  <td>S</td>
                </tr>
                <tr v-for="(player, index) in rotation_manage['rotations']" style="text-align: center">
                  <td v-if="index == 0">先発</td>
                  <td v-else-if="index == 6">中継ぎ</td>
                  <td v-else-if="index == 9">守護神</td>
                  <td v-else></td>
                  <td>{{ player['name'] }}</td>
                  <td>{{ player['match'] }}</td>
                  <td>{{ player['era'] }}</td>
                  <td>{{ player['win'] }}</td>
                  <td>{{ player['defeat'] }}</td>
                  <td>{{ player['hold'] }}</td>
                  <td>{{ player['save_point'] }}</td>
                </tr>
              </table>
            </div>
          </section>
          <section class='member col-sm-7 py-1 text-dark'>
            <div class="coment">
              <form @submit.prevent="create_user_comment(rotation_manage['id'])" class="py-2">
                <input type='text' v-model="user_comment">
                <input class="btn btn-light comment-btn" type="submit" value="投稿">
              </form>
              <div class="text-coment">
                <p v-for="user_comment in rotation_manage['user_comments']" class="mb-1">
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
          スタメン　＞
        </a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params }) {
    const { data } = await axios.get(`http://sports-memory.com/api/rotation_manage/${params.team}/${params.year}`)
    return { api_data: data }
  },
  data() {
    return {
      is_create_rotation: true
    }
  },
  methods: {
    async create_rotation () {
      this.$gtag('event', 'クリック計測', {
        'event_category': '作成',
        'event_label': 'Rotation',
        'value': 1
      });
      const { data } = await axios.post(`http://sports-memory.com/api/rotation_manage`, {
        year: this.api_data['year'],
        team_id: this.api_data['team']['id'],
        rotation: [
          this.api_data['selected_players'][0],
          this.api_data['selected_players'][1],
          this.api_data['selected_players'][2],
          this.api_data['selected_players'][3],
          this.api_data['selected_players'][4],
          this.api_data['selected_players'][5],
          this.api_data['selected_players'][6],
          this.api_data['selected_players'][7],
          this.api_data['selected_players'][8],
          this.api_data['selected_players'][9]
        ],
        comment: this.comment
      })
      this.api_data['rotation_manages'].unshift(
        {
          id: data['id'],
          rotations: data['rotations'],
          comment: data['comment'],
          user_comments: []
        }
      )
      this.is_create_rotation = false
    },
    async create_user_comment (rotation_manage_id) {
      this.$gtag('event', 'クリック計測', {
        'event_category': 'コメント',
        'event_label': 'Rotation',
        'value': 1
      });
      const { data } = await axios.post(`http://sports-memory.com/api/rotation_manage_user_comment`, {
        rotation_manage_id: rotation_manage_id,
        user_comment: this.user_comment
      })
      this.user_comment = '';
      for(var index in this.api_data['rotation_manages']) {
        if(this.api_data['rotation_manages'][index]['id'] == rotation_manage_id){
          this.api_data['rotation_manages'][index]['user_comments'].push(data['user_comment']);
        }
      }
    },
    player_record: function (pitcher_id, record) {
      for(var index in this.api_data['select_players']){
        if(this.api_data['select_players'][index]['pitcher_id'] == pitcher_id){
          return this.api_data['select_players'][index][record];
        }
      }
    },
    left_href: function() {
      return `/ranking/${this.api_data['league']['name_en']}/${this.api_data['year']}`
    },
    right_href: function() {
      return `/opening_starting_lineup/${this.api_data['team']['name_en']}/${this.api_data['year']}`
    }
  }
}
</script>

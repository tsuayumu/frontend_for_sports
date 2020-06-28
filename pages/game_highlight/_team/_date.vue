<template>
  <div :id="api_data['team']['name_en']" class="pt-3 text-center">
    <h3 class='page-tit white'>本日の見所<br>{{ api_data['team']['name'] }}戦<br>{{ api_data['date'] }}</h3>

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
    return { api_data: data }
  },
  methods: {
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
    }
  }
}
</script>

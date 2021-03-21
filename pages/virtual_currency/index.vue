<template>
  <div class="container text-center">
    <h1>仮想通貨Twitterランキング</h1>
    <section class=''>
      <div class="text-dark">
        <table border="0" width="100%">
          <tr style="text-align: center">
            <td>名称</td>
            <td v-on:click="sort_rate(0)">#〇〇</td>
            <td v-on:click="sort_rate(1)">#〇〇 仮想通貨</td>
            <td v-on:click="sort_rate(2)">#〇〇 買</td>
            <td v-on:click="sort_rate(3)">#〇〇 売</td>
          </tr>
          <tr v-for="virtual_currency in api_data['virtual_currencys']" style="text-align: center">
            <td>{{ virtual_currency['name'] }}</td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">
              <nuxt-link :to="{ name: 'virtual_currency_tweet_word-id', params: { id: virtual_currency['tweet_infos'][0]['id'] } }">
                {{ virtual_currency['tweet_infos'][0]['count'] }}<br>（{{ visible_rate(virtual_currency['tweet_infos'][0]['rate']) }}％）
              </nuxt-link>
            </td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">
              <nuxt-link :to="{ name: 'virtual_currency_tweet_word-id', params: { id: virtual_currency['tweet_infos'][1]['id'] } }">
                {{ virtual_currency['tweet_infos'][1]['count'] }}<br>（{{ visible_rate(virtual_currency['tweet_infos'][1]['rate']) }}％）
              </nuxt-link>
            </td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">
              <nuxt-link :to="{ name: 'virtual_currency_tweet_word-id', params: { id: virtual_currency['tweet_infos'][2]['id'] } }">
                {{ virtual_currency['tweet_infos'][2]['count'] }}<br>（{{ visible_rate(virtual_currency['tweet_infos'][2]['rate']) }}％）
              </nuxt-link>
            </td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">
              <nuxt-link :to="{ name: 'virtual_currency_tweet_word-id', params: { id: virtual_currency['tweet_infos'][3]['id'] } }">
                {{ virtual_currency['tweet_infos'][3]['count'] }}<br>（{{ visible_rate(virtual_currency['tweet_infos'][3]['rate']) }}％）
              </nuxt-link>
            </td>
          </tr>
        </table>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params, route }) {
    const { data } = await axios.get(`https://sports-memory.com/api/virtual_currency/`)
    return { api_data: data }
  },
  data() {
  },
  methods: {
    sort_rate: function(index) {
      this.api_data['virtual_currencys'].sort(function compareFunc(a, b) {
        return b['tweet_infos'][index]['rate'] - a['tweet_infos'][index]['rate'];
      })
    },
    visible_rate: function(r) {
      if (r) {
        if (r > 0) {
          return '+' + r
        } else {
          return r
        }
      } else {
        return '-'
      }
    }
  }
}
</script>

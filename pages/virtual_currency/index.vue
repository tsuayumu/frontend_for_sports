<template>
  <div class="container text-center">
    <h1>仮想通貨Twitterランキング</h1>
    <section class=''>
      <div class="text-dark">
        <table border="0" width="100%">
          <tr style="text-align: center">
            <td>名称</td>
            <td>#〇〇</td>
            <td>#〇〇 仮想通貨</td>
            <td>#〇〇 買</td>
            <td>#〇〇 売</td>
          </tr>
          <tr v-for="virtual_currency in api_data['virtual_currencys']" style="text-align: center">
            <td>{{ virtual_currency['name'] }}</td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">{{ virtual_currency['tweet_infos'][0]['count'] }}</td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">{{ virtual_currency['tweet_infos'][1]['count'] }}</td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">{{ virtual_currency['tweet_infos'][2]['count'] }}</td>
            <td v-if ="virtual_currency['tweet_infos'].length != 0">{{ virtual_currency['tweet_infos'][3]['count'] }}</td>
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
  }
}
</script>

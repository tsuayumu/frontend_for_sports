<template>
  <div style="background-color: #000;" class="py-2">
    <h1 class="text-center white">{{ api_data['title'] }}</h1>
    <div class="container">
      <div class="container" style="white-space: pre-line;">
        <div v-for="tweet in api_data['tweet_word']" class="bbs-contet mb-3">
          <div class="white text-left balloon1-left text-left"><span class="font-weight-bold">{{tweet["name"]}}</span>（{{tweet["followers_count"]}}人）
            {{tweet["text"]}}

            ♡ {{tweet["favorite_count"]}}　{{tweet["tweeted_at"]}}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  async asyncData ({ params, route }) {
    const { data } = await axios.get(`https://sports-memory.com/api/virtual_currency_tweet_word/${params.id}`)
    return { api_data: data }
  },
  data() {
  },
  mounted() {
  },
  methods: {
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

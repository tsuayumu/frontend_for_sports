<template>
  <header class="sticky-top">
    <nav class="navbar navbar-expand-sm navbar-light">
      <a href="/" class="navbar-brand">Fun Baseball</a>
      <button class="navbar-toggler" data-toggle="collapse" data-target="#header-list">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div id="header-list" class="collapse navbar-collapse">
        <ul class="navbar-nav">
          <!-- 開幕スタメン
          <li class="nav-item"><a href="/opening_starting_lineup/giants/2020" class="nav-link">Giants</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/tigers/2020" class="nav-link">Tigers</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/carp/2020" class="nav-link">Carp</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/baystars/2020" class="nav-link">Baystars</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/dragons/2020" class="nav-link">Dragons</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/swallows/2020" class="nav-link">Swallows</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/hawks/2020" class="nav-link">Hawks</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/fighters/2020" class="nav-link">Fighters</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/buffaloes/2020" class="nav-link">Buffaloes</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/marines/2020" class="nav-link">Marines</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/eagles/2020" class="nav-link">Eagles</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/lions/2020" class="nav-link">Lions</a></li>
          <li class="nav-item"><a href="/opening_starting_lineup/japan/2020" class="nav-link">Japan</a></li>
          -->

          <li class="nav-item"><a :href="header_href('giants')" class="nav-link">Giants</a></li>
          <li class="nav-item"><a :href="header_href('tigers')" class="nav-link">Tigers</a></li>
          <li class="nav-item"><a :href="header_href('carp')" class="nav-link">Carp</a></li>
          <li class="nav-item"><a :href="header_href('baystars')" class="nav-link">Baystars</a></li>
          <li class="nav-item"><a :href="header_href('dragons')" class="nav-link">Dragons</a></li>
          <li class="nav-item"><a :href="header_href('swallows')" class="nav-link">Swallows</a></li>
          <li class="nav-item"><a :href="header_href('hawks')" class="nav-link">Hawks</a></li>
          <li class="nav-item"><a :href="header_href('fighters')" class="nav-link">Fighters</a></li>
          <li class="nav-item"><a :href="header_href('buffaloes')" class="nav-link">Buffaloes</a></li>
          <li class="nav-item"><a :href="header_href('marines')" class="nav-link">Marines</a></li>
          <li class="nav-item"><a :href="header_href('eagles')" class="nav-link">Eagles</a></li>
          <li class="nav-item"><a :href="header_href('lions')" class="nav-link">Lions</a></li>
        </ul>
      </div>
    </nav>
  </header>
</template>

<script>
import axios from 'axios'

export default {
  methods: {
    header_href: function(name_en) {
      // 今日の日付で Date オブジェクトを作成
      var now = new Date();
      // 「年」「月」「日」「曜日」を Date オブジェクトから取り出してそれぞれに代入
      var y = now.getFullYear();
      var m = now.getMonth() + 1;
      var d = now.getDate();
      // 「月」と「日」で1桁だったときに頭に 0 をつける
      if (m < 10) {
        m = '0' + m;
      }
      if (d < 10) {
        d = '0' + d;
      }
      return `/game/${name_en}/${y}${m}${d}`
    }
  }
}
</script>

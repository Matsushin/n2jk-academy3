$ ->
  # Vue.config.debug = true

  window.app = new Vue
    el: '#vue-app'
    data:
      posts: []
      mode: 'home'
    events:
      'hook:created': ->
    methods:
      isDisplayingHome: ->
        @mode == 'home'
      setDisplayingMode: (mode) ->
        @mode = mode
$ ->
  # Vue.config.debug = true

  $('#post-form')
  .on 'ajax:success', (xhr, data, status) =>
    $('#post-form text-area').prop('value', '')
    $('#post-modal').modal('hide')
    app.setDisplayingPost()
  .on 'ajax:error', (xhr, status, error) =>
    alert error

  store =
    getUsers: ->
      $.ajax
        url: '/users'
        dataType: 'json'
    getPosts: ->
      $.ajax
        url: '/posts'
        dataType: 'json'

  Vue.component 'postsComponent',
    template: '#vue-posts'
    data: ->
      posts: []
    events:
      'hook:ready': ->
        @loadPosts()
    methods:
      loadPosts: ->
        store.getPosts().done (posts) =>
          @posts = posts
      selectPost: ->


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
      isDisplayingPost: ->
        @mode == 'post'
      isDisplayingAcademy: ->
        @mode == 'academy'
      isDisplayingPerformance: ->
        @mode == 'performance'
      setDisplayingPost: ->
        @setDisplayingMode('post')

      setDisplayingMode: (mode) ->
        @mode = mode
      loadPosts: ->
        store.getPosts().done (posts) =>
          @posts = posts
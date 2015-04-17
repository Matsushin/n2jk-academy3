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
    getPost: (userId, postId) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}",
        dataType: 'json'
    updatePost: (userId, postId, postBody) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}"
        type: 'PATCH'
        dataType: 'json'
        data: {post: {body: postBody}}
    deletePost: (userId, postId) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}"
        type: 'DELETE'
        dataType: 'json'

  global =
    loginUserId: $('#vue-app').data('login-user-id')

  Vue.component 'postsComponent',
    template: '#vue-posts'
    data: ->
      posts: []
      post: null
      list: true
      detail: false
      editing: false
    events:
      'hook:ready': ->
        @list = true
        @loadPosts()
    methods:
      ownerIsLoginUser: ->
        global.loginUserId == @post.user_id
      toggleEditing: ->
        @editing = !@editing
        @editingPost = if @editing then @post else null
      isList: ->
        @list
      isDetail: ->
        @detail
      selectPost: (userId, postId) ->
        @list = false
        @detail = true
        store.getPost(userId, postId).done (post) =>
          @post = post
      loadPosts: ->
        @list = true
        @detail = false
        store.getPosts().done (posts) =>
          @posts = posts
      updatePost: (e) ->
        e.preventDefault()
        store.updatePost(@editingPost.user_id, @editingPost.id, @editingPost.body).done =>
          @toggleEditing()
          @selectPost(@editingPost.user_id, @editingPost.id)
      deletePost: ->
        store.deletePost(@editingPost.user_id, @editingPost.id).done =>
          @toggleEditing()
          @loadPosts()

      addComment: (e) ->
        e.preventDefault()




  Vue.component 'usersComponent',
    template: '#vue-users'
    data: ->
      users: []
    events:
      'hook:ready': ->
        @loadUsers()
    methods:
      loadUsers: ->
        store.getUsers().done (users) =>
          @users = users
      selectUser: ->

  window.app = new Vue
    el: '#vue-app'
    data:
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
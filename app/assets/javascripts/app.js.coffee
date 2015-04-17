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
    getComments: (userId, postId) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}/comments"
        dataType: "json"
    createComment: (userId, postId, commentBody) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}/comments"
        type: 'POST'
        dataType: 'json'
        data: { comment: {body: commentBody}}
    updateComment: (userId, postId, commentId, commentBody) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}/comments/#{commentId}"
        type: 'PATCH'
        dataType: 'json'
        data: {comment: {body: commentBody}}
    deleteComment: (userId, postId, commentId) ->
      $.ajax
        url: "/users/#{userId}/posts/#{postId}/comments/#{commentId}"
        type: 'DELETE'
        dataType: 'json'

  global =
    loginUserId: $('#vue-app').data('login-user-id')

  markdownable =
    methods:
      marked: (text) ->
        marked(text)

  Vue.component 'postsComponent',
    template: '#vue-posts'
    mixins: [markdownable]
    data: ->
      posts: []
      comments: []
      post: null
      list: true
      detail: false
      editing: false
      newComment: ''
    events:
      'hook:ready': ->
        @list = true
        @loadPosts()
      'reloadComments': ->
      'reloadComments': ->
        @loadComments()
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
          @loadComments()
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
      loadComments: ->
        store.getComments(@post.user_id, @post.id).done (comments) =>
          @comments = comments
      addComment: (e) ->
        e.preventDefault()
        body = @newComment && @newComment.trim()
        return unless body
        store.createComment(@post.user_id, @post.id, body).done =>
          @loadComments()
          @newComment = ''

  Vue.component 'commentsComponent',
    template: '#vue-comments'
    mixins: [markdownable]
    data: ->
      comment: null
      editing: false
    events:
      'hook:ready': ->
    methods:
      ownerIsLoginUser: ->
        user_id = parseInt(@comment.user_id, 10)
        global.loginUserId == user_id
      toggleEditing: ->
        @editing = !@editing
        @editingComment = if @editing then @comment else null
      updateComment: (e) ->
        e.preventDefault()
        store.updateComment(@editingComment.user_id, @editingComment.post_id, @editingComment.id, @editingComment.body).done =>
          @toggleEditing()
          @$dispatch 'reloadComments'
      deleteComment: ->
        store.deleteComment(@editingComment.user_id, @editingComment.post_id, @editingComment.id).done =>
          @toggleEditing()
          @$dispatch 'reloadComments'


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
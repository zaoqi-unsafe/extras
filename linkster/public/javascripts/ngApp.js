var app = angular.module('links', ['ui.router'])

app.config(['$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider){
    $stateProvider
      .state('home', {
        url: '/home'
      , templateUrl: '/home.html'
      , controller: 'mainCtrl'
      , resolve: {
          postPromise: ['posts', function(posts){
            return posts.getAll()
          }]
        }
      })
      .state('posts', {
        url: '/posts/{id}'
      , templateUrl: '/posts.html'
      , controller: 'postCtrl'
      , resolve: {
          post: ['$stateParams', 'posts', function($stateParams, posts){
            return posts.get($stateParams.id)
          }]
        }
      })

    $urlRouterProvider
      .otherwise('home')
  }])

app.factory('posts', '$http', [function($http){
  var o = {
    post: []
  }

  o.getAll = function(){
    return $http.get('/posts').success(function(data){
      angular.copy(data, o.posts)
    })
  }

  o.get = function(id){
    return $http.get('/posts/' + id).then(function(res){
      return res.data
    })
  }

  o.create = function(post){
    return $http.post('/posts', post).success(function(data){
      o.posts.push(data)
    })
  }

  o.addComment = function(id, comment){
    return $http.post('/posts/' + id + '/comments', comment)
  }

  o.upvote = function(post){
    return $http.put('/posts/' + post._id + '/upvote').success(function(data){
      post.upvotes += 1
    })
  }

  o.upvoteComment = function(post, comment){
    return $http.put('/posts/' + post._id + '/comments/' + comment._id + '/upvote').success(function(data){
      comment.upvotes += 1
    })
  }

  return o
}])

app.controller('mainCtrl', ['$scope', 'posts',
  function($scope, posts){
    $scope.addPost = function(){
      if (!$scope.title || $scope.title === '') {return}
      post.create({
        title: $scope.title
      , link: $scope.link
      })
      $scope.title = ''
      , $scope.link = ''
    }

    $scope.incrementUpvotes = function(post){
      posts.upvote(post)
    }
    $scope.posts = posts.posts
  }
])

app.controller('postCtrl', ['$scope', 'posts', 'post',
  function($scope, posts, post){
    $scope.post = post
    $scope.addComment = function(){
      if ($scope.body === '') {return}
      posts.addComment(post._id, {
        body: $scope.body
      , author: 'user'
      }).success(function(comment){
        $scope.post.comments.push(comment)
      })
      $scope.body = ''
    }
    $scope.incrementUpvotes = function(comment){
      posts.upvoteComment(post, comment)
    }
  }
])
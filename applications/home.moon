import capture_errors, yield_error from require 'lapis.application'

lapis = require 'lapis'
_ = require 'underscore'
PostList = require 'models.postList'
config = require('lapis.config').get!

class HomeApplication extends lapis.Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: PostList[1].Slug

	[index: "/:slug"]: capture_errors =>

		@PostList = PostList
		@Post = _.find PostList, (post) ->
			return post.Slug == @params.slug

		unless @Post then @app\ThrowUp!
		
		@Title = @Post.Title
		@PostBody = @app\GetPostBodyByName @Post.FileName
		@URL = @req.built_url

		render: true, layout: 'layout'

	
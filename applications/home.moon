import respond_to from require 'lapis.application'
import to_json, encode_query_string from require 'lapis.util'
import cached from require 'lapis.cache'
import require_github_auth from require 'auth.github'

articleRepo = require 'repo.articleRepo'

class HomeApplication extends require('lapis').Application

	[loopback: '/']: =>
		redirect_to: @url_for 'index', slug: articleRepo.getLatestPostSlug!

	[index: "/:slug"]: respond_to {

		before: =>
			@PostList = articleRepo.getPostList!
			@Post = articleRepo.getArticleBySlug @params.slug

			unless @Post then @write status: 404, render: 'error', layout: 'layout'

		GET: =>
			@Title = @Post.title
			@URL = @req.built_url
			@Post.languages = to_json @Post.languages

			render: true, layout: 'layout'
	}

	[editor: '/:slug/edit']: respond_to {

		before: require_github_auth =>

		GET: =>
			@Post = articleRepo.getArticleBySlug @params.slug
			unless @Post then @write status: 404, render: 'error', layout: 'layout'
			@Title = @Post.title..' / Edit'

			render: 'home.editor', layout: 'layout'
	}

	
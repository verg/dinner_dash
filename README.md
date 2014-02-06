Rails resturant ordering platform, loosly based on the project idea from [Jumpstart Labs](http://tutorials.jumpstartlab.com/projects/dinner_dash.html).

Uses Sidekiq to send mail asynchronously. Start with:
`bundle exec sidekiq`

Require postgres as the db to take advantage of full text search.

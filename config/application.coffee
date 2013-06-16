# Exports an object that defines
#  all of the configuration needed by the projects'
#  depended-on grunt tasks.
#
# You can find the parent object in: node_modules/lineman/config/application.coffee
#


module.exports = require(process.env['LINEMAN_MAIN']).config.extend "application",

  # Use grunt-markdown-blog in lieu of Lineman's built-in homepage task
  prependTasks:
    common: "markdown:dev"
    dist: "markdown:dist"
  removeTasks:
    common: "homepage:dev"
    dist: "homepage:dist"

  markdown:
    options:
      author: "Justin Searls"
      title: "searls"
      description: "the software blog of @searls"
      url: "http://searls.testdouble.com"
      rssCount: 10 #<-- remove, comment, or set to zero to disable RSS generation
      #disqus: "agile" #<-- just remove or comment this line to disable disqus support
      layouts:
        wrapper: "app/templates/wrapper.us"
        index: "app/templates/index.us"
        post: "app/templates/post.us"
        archive: "app/templates/archive.us"
      paths:
        posts: "app/posts/*.md"
        index: "index.html"
        archive: "archive.html"
        rss: "index.xml"

    dev:
      dest: "generated"
      context:
        js: "../js/app.js"
        css: "../css/app.css"

    dist:
      dest: "dist"
      context:
        js: "../js/app.min.js"
        css: "../css/app.min.css"

  watch:
    markdown:
      files: ["app/posts/*.md", "app/templates/*.us"]
      tasks: ["markdown:dev"]

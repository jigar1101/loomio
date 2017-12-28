gulp     = require 'gulp'
paths    = require './tasks/paths'
sequence = require 'gulp-run-sequence'

angular  = require './tasks/angular'
vue      = require './tasks/vue'
extra    = require './tasks/extra'
watch    = require './tasks/watch'

gulp.task 'angular:vendor',          angular.vendor
gulp.task 'angular:core:haml',       angular.core.haml
gulp.task 'angular:core:scss',       angular.core.scss
gulp.task 'angular:plugin:haml',     angular.plugin.haml
gulp.task 'angular:plugin:scss',     angular.plugin.scss
gulp.task 'angular:minify:js',       angular.minify.js
gulp.task 'angular:minify:css',      angular.minify.css
gulp.task 'angular:bundle:dev',      angular.bundle.development
gulp.task 'angular:bundle:prod',     angular.bundle.production

gulp.task 'angular:fonts',           extra.fonts
gulp.task 'angular:emoji',           extra.emoji
gulp.task 'angular:moment_locales',  extra.moment_locales

gulp.task 'execjs:dev',              extra.execjs.development
gulp.task 'execjs:prod',             extra.execjs.production

gulp.task 'angular:external:dev', [
  'angular:fonts',
  'angular:core:haml',
  'angular:core:scss',
  'angular:plugin:haml',
  'angular:plugin:scss',
  'angular:vendor',
  'angular:emoji',
  'angular:moment_locales'
]
gulp.task 'angular:external:prod', (done) -> sequence('angular:external:dev', ['angular:minify:js', 'angular:minify:css'], -> done())

gulp.task 'vue:bundle:dev',  vue.bundle.development
gulp.task 'vue:bundle:prod', vue.bundle.production

gulp.task 'bundle:dev',  ['angular:external:dev', 'angular:bundle:dev', 'vue:bundle:dev', 'execjs:dev']
gulp.task 'bundle:prod', ['angular:bundle:prod', 'angular:external:prod', 'vue:bundle:prod', 'execjs:prod']

gulp.task 'dev',                    (done) -> sequence('bundle:dev', watch)
gulp.task 'compile',                (done) -> sequence('bundle:prod')

gulp.task 'protractor:core',    require('./tasks/protractor/core')
gulp.task 'protractor:plugins', require('./tasks/protractor/plugins')

gulp.task 'protractor',     -> sequence('angular:bundle:dev', 'protractor:now')
gulp.task 'protractor:now', -> sequence('protractor:core', 'protractor:plugins')

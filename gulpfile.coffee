gulp         = require 'gulp'

del          = require 'del'
sequence     = require 'run-sequence'

coffee       = require 'gulp-coffee'
jade         = require 'gulp-jade'
rev          = require 'gulp-rev'
revReplace   = require 'gulp-rev-replace'
sass         = require 'gulp-sass'

basePath = 'src/'
baseDestPath = 'public/'
paths =
  html:
    src:  basePath     + 'views/*.jade'
    dest: baseDestPath
  js:
    src:  basePath     + 'javascripts/**/*.coffee'
    dest: baseDestPath + 'assets/'
  css:
    src:  basePath     + 'stylesheets/**/*.sass'
    dest: baseDestPath + 'assets/'
  img:
    src:  basePath     + 'images/**/*'
    dest: baseDestPath + 'assets/'
  rev:
    src:  baseDestPath + 'assets/**/*.+(js|css|png|gif|jpg|jpeg|svg|woff|ico)'
    dest: baseDestPath + 'assets/'
    manifestFileName: 'hoge-manifest.json'
  rev_replace:
    src:  baseDestPath + '**/*.+(html|css|js)'
    dest: baseDestPath


gulp.task 'default', ['build']

gulp.task 'build', (cb) ->
  sequence 'clean', 'coffee', 'sass', 'image', 'jade', 'rev', 'rev:replace', cb

gulp.task 'clean', (cb) ->
  del(["#{baseDestPath}/*"], cb)

gulp.task 'coffee', (f) =>
  gulp.src paths.js.src
    .pipe coffee()
    .pipe gulp.dest paths.js.dest

gulp.task 'jade', (f) ->
  gulp.src paths.html.src
    .pipe jade()
    .pipe gulp.dest paths.html.dest

gulp.task 'image', (f) ->
  gulp.src paths.img.src
    .pipe gulp.dest paths.img.dest

gulp.task 'sass', (f) ->
  gulp.src paths.css.src
    .pipe sass()
    .pipe gulp.dest paths.css.dest

gulp.task 'rev', (f) ->
  gulp.src paths.rev.src
    .pipe rev()
    .pipe gulp.dest paths.rev.dest
    .pipe rev.manifest(paths.rev.manifestFileName)
    .pipe gulp.dest paths.rev.dest

gulp.task 'rev:replace', (f) ->
  manifest = gulp.src paths.rev.manifestFileName
  gulp.src paths.rev_replace.src
    .pipe revReplace manifest: manifest
    .pipe gulp.dest paths.rev_replace.dest

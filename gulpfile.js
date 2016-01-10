const gulp = require('gulp');
const imagemin = require('gulp-imagemin');
const pngquant = require('imagemin-pngquant');
var $ = require('gulp-load-plugins')();

var express = require('express');
var EXPRESS_PORT = 4000;
var EXPRESS_ROOT = '_site/';

gulp.task('responsive-images', function () {
    // Make configuration from existing HTML and CSS files
    var config = $.responsiveConfig([
        '_site/**/*.css',
        '_site/**/*.html'
    ]);

    return gulp.src('_assets/*.{png,jpg}')
        // Use configuration
        .pipe($.responsive(config, {
            errorOnEnlargement: false,
            quality: 80,
            withMetadata: false,
            compressionLevel: 7,
            max: true
        }))
        .pipe(gulp.dest('_site/images'));
});

gulp.task('minify-responsive-images', ['responsive-images'], function() {
    return gulp.src('_site/images/*')
        .pipe(imagemin({
            progressive: true,
            svgoPlugins: [{removeViewBox: false}],
            use: [pngquant()]
        }))
        .pipe(gulp.dest('_site/images'));
});

// Run static file server
gulp.task('serve', function () {
    var server = express();
    server.use(express.static(EXPRESS_ROOT));
    server.listen(EXPRESS_PORT);
});

gulp.task('default', ['minify-responsive-images']);
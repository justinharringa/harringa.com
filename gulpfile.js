const gulp = require('gulp');
const imagemin = require('gulp-imagemin');
const pngquant = require('imagemin-pngquant');
var $ = require('gulp-load-plugins')();

var express = require('express');
var EXPRESS_PORT = 4000;
var EXPRESS_ROOT = '_site/';

gulp.task('responsive-images', gulp.series(function () {
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
        .pipe(gulp.dest('images'));
}));

gulp.task('minify-responsive-images', gulp.series('responsive-images', function() {
    return gulp.src('images/*')
        .pipe(imagemin({
            progressive: true,
            svgoPlugins: [{removeViewBox: false}],
            use: [pngquant()]
        }))
        .pipe(gulp.dest('images'));
}));

// Run static file server
gulp.task('serve', gulp.series(function () {
    var server = express();
    server.use(express.static(EXPRESS_ROOT));
    server.listen(EXPRESS_PORT);
}));

gulp.task('default', gulp.series('minify-responsive-images'));

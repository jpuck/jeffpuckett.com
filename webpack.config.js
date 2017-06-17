var webpack = require('webpack');
var inProduction = (process.env.NODE_ENV === 'production');
var outdir = __dirname + '/docs';
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');
const glob = require('glob');
const PurifyCSSPlugin = require('purifycss-webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const HtmlWebpackExcludeAssetsPlugin = require('html-webpack-exclude-assets-plugin');

module.exports = {
    entry: {
        main: [
            './sass/main.scss',
            './js/google-analytics.js'
        ],
        cv: [
            './sass/cv.scss',
        ],
    },
    output: {
        path: outdir,
        filename: 'js/jp.[name].[chunkhash].js'
    },
    module: {
        rules: [
            {
                test: /\.s[ac]ss$/,
                use: ExtractTextPlugin.extract({
                    use: ['css-loader', 'sass-loader']
                })
            },
        ]
    },
    plugins: [
        new ExtractTextPlugin('css/jp.[name].[contenthash].css'),
        new PurifyCSSPlugin({
            // Give paths to parse for rules. These should be absolute!
            paths: glob.sync(path.join(__dirname, '/html/*.html')),
            minimize: inProduction
        }),
        new webpack.LoaderOptionsPlugin({
            minimize: inProduction
        }),
        new CleanWebpackPlugin([
            'docs/js',
            'docs/css',
            'docs/cv',
        ]),
        new HtmlWebpackPlugin({
            template: 'html/index.html',
            filename: 'index.html',
            chunks: ['main'],
            minify: {
                collapseWhitespace: inProduction,
                removeComments: inProduction
            }
        }),
        new HtmlWebpackPlugin({
            template: 'html/cv.html',
            filename: 'cv/index.html',
            minify: {
                collapseWhitespace: inProduction,
                removeComments: inProduction
            },
            excludeAssets: [
                /jp.main.*.css/,
                /jp.cv.*.js/,
            ],
        }),
        new HtmlWebpackExcludeAssetsPlugin(),
    ]
};

if (inProduction) {
    module.exports.plugins.push(
        new webpack.optimize.UglifyJsPlugin()
    );
}

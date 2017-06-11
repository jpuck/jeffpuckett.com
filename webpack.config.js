var webpack = require('webpack');
var inProduction = (process.env.NODE_ENV === 'production');
var outdir = __dirname + '/docs';
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');
const glob = require('glob');
const PurifyCSSPlugin = require('purifycss-webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: {
        jp: [
            './sass/main.scss',
            './js/google-analytics.js'
        ],
        cv: [
            './sass/resume.scss',
        ],
    },
    output: {
        path: outdir,
        filename: 'js/[name].[chunkhash].js'
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
        new ExtractTextPlugin('css/[name].[contenthash].css'),
        new PurifyCSSPlugin({
            // Give paths to parse for rules. These should be absolute!
            paths: glob.sync(path.join(__dirname, '/html/*.html')),
            minimize: inProduction
        }),
        new webpack.LoaderOptionsPlugin({
            minimize: inProduction
        }),
        new CleanWebpackPlugin(['docs/js', 'docs/css']),
        new HtmlWebpackPlugin({
            template: 'html/index.html',
            filename: 'index.html',
            chunks: ['jp'],
            minify: {
                collapseWhitespace: inProduction,
                removeComments: inProduction
            }
        }),
        new HtmlWebpackPlugin({
            template: 'html/resume.html',
            filename: 'resume/index.html',
            chunks: ['cv'],
            minify: {
                collapseWhitespace: inProduction,
                removeComments: inProduction
            }
        }),
    ]
};

if (inProduction) {
    module.exports.plugins.push(
        new webpack.optimize.UglifyJsPlugin()
    );
}

var webpack = require('webpack');
var inProduction = (process.env.NODE_ENV === 'production');
var outdir = __dirname + '/dist';
var css = '';
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');
const glob = require('glob');
const PurifyCSSPlugin = require('purifycss-webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
    entry: {
        jp: [
            './sass/main.scss',
            './index.html',
        ]
    },
    output: {
        path: outdir,
        filename: '[name].[chunkhash:8].js'
    },
    module: {
        rules: [
            {
                test: /\.html$/,
                use: [
                    {
                        loader: "file-loader",
                        options: {
                            name: "/[name]-dist.[ext]",
                        },
                    },
                    {
                        loader: 'string-replace-loader',
                        query: {
                            search: /\/dist\/jp.+css/,
                            replace: css
                        }
                    },
                    {
                        loader: "extract-loader",
                    },
                    {
                        loader: 'html-loader',
                        options: {
                            minimize: inProduction,
                            removeComments: inProduction,
                            collapseWhitespace: inProduction
                        }
                    }
                ]
            },
            {
                test: /\.s[ac]ss$/,
                use: ExtractTextPlugin.extract({
                    use: ['css-loader', 'sass-loader'],
                }),
            },
        ]
    },
    plugins: [
        new ExtractTextPlugin({
            filename:  (getPath) => {
                css = getPath('[name].[contenthash:8].css');
                return getPath('[name].[contenthash:8].css');
            }
        }),
        new PurifyCSSPlugin({
            // Give paths to parse for rules. These should be absolute!
            paths: glob.sync(path.join(__dirname, '*.html')),
            minimize: inProduction
        }),
        new webpack.LoaderOptionsPlugin({
            minimize: inProduction
        }),
        new CleanWebpackPlugin(outdir),
    ]
};

if (inProduction) {
    module.exports.plugins.push(
        new webpack.optimize.UglifyJsPlugin()
    );
}

var VERSION_CSS = '0.1.0';
var webpack = require('webpack');
var inProduction = (process.env.NODE_ENV === 'production');
var outdir = __dirname + '/dist';
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const path = require('path');
const glob = require('glob');
const PurifyCSSPlugin = require('purifycss-webpack');
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
    entry: {
        jp: [
            './sass/main.scss',
            './html/index.html',
        ]
    },
    output: {
        path: outdir,
        filename: '[name].[chunkhash:8].js'
    },
    module: {
        rules: [
            {
                test: /\.s[ac]ss$/,
                use: ExtractTextPlugin.extract({
                    use: ['css-loader', 'sass-loader']
                })
            },
            {
                test: /\.html$/,
                use: [
                    {
                        loader: "file-loader",
                        options: {
                            name: "[name].[ext]",
                        },
                    },
                    {
                        loader: 'string-replace-loader',
                        query: {
                            search: /\$VERSION_CSS/,
                            replace: '/dist/jp.'+VERSION_CSS+'.css'
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
            }
        ]
    },
    plugins: [
        new ExtractTextPlugin('jp.'+VERSION_CSS+'.css'),
        new PurifyCSSPlugin({
            // Give paths to parse for rules. These should be absolute!
            paths: glob.sync(path.join(__dirname, '/html/*.html')),
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

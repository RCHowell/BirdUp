const path = require('path');

module.exports = {
    target: 'web',
    node: {
        fs: false
    },
    entry: './src/index.js',
    output: {
        filename: 'main.js',
        path: path.resolve(__dirname, 'dist'),
    },
    mode: 'development',
};

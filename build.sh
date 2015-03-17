coffee -o ./lib ./src/index.coffee && browserify -r ./lib/index.js:evaluable-tag > ./browser/build.js

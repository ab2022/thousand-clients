
## Javascript "dashworld"

Very rough implementation of puppeteer controlling chrome to request the
`player_1.html` webpage which calls the `dash.all.min.js`
from the [qualabs repo](https://github.com/montevideo-tech/cmcd-analyzer/blob/feature/cmcd-v2-demuxed/analyzer-dashboard/public/dash.all.min.js)

`player_1.html` can be hosted anywhere, I used localhost.

`dashjs_world.js` uses a special chrome version, `@sparticuz/chromium`.
This is a smaller size chrome in case docker images will be made for AWS lambda in the future.

Running with node.js follows the usual process:
```
npm install
node dashjs_world.js
```

The Dockerfile buids the image,
```
docker build -t dashjs-world .
```
when the container is run it will exit after 1 minute due to the setTimeout() in `dashjs_world.js`. TODO: run for a longer time.
```
docker run -it --rm --name dashworldab --network host -d dashjs-world:latest
```




## Hosted player to use with puppeteer controlling chrome in javascript

Can be hosted on any web server, including localhost. Copy both files
to document root and point to `player_1.html` in `page.goto()` in `../js/dashjs_world.js`.

The player is currently configured to get the mpd
from `satpoc.com`, also known as the comcast Smart Origin&trade;,
and send CMCD data only in response mode and
in state-interval mode, not in request mode. The endpoint is a hard-coded ip address (35.92.255.26)
which for now is just an [HTTP logger](https://gist.github.com/mdonkers/63e115cc0c79b4f6b8b3a6b797e485c7A)
(not included in this repo) to see the requests coming in.

In the future, the endpoints of the data collection/analyzer will be used instead of the hard-coded ip.



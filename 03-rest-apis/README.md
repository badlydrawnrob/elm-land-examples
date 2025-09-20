# Rest APIs

> Built with [Elm Land](https://elm.land) 🌈

## Local development

```bash
# Requires Node.js v18+ (https://nodejs.org)
npx elm-land server
```

## Deploying to production

Elm Land projects are most commonly deployed as static websites.

Please visit [the "Deployment" guide](https://elm.land/guide/deploying) to learn more
about deploying your app for free using Netlify or Vercel.

### Testing (`elm-land build`)

> You can use Python with a default Mac setup

```terminal
# Copy `dist` files to a directory
cd path/to/dist

# Run the server
python3 -m http.server

# On a certain port
python3 -m http.server 5000
```

## Commands

```terminal
# View all routes
elm-land routes

# Add an element page
elm-land add page:element /

# Add an elm package
npx elm install elm/http
npx elm install elm/json

# Server (use separate terminal window)
DELAY=1000 npm start

# Build our app (remove `Debug` first)
npx elm-land build

# Add individual pages
elm-land add page:element /pokemon/:name
```

## Optimising

Using [Purge CSS]() minifies the styles to only what you're using (this is possible the _only_ good reason to use `class="inline-styles"`). I don't think you can do this with `elm-land build` javascript file output, only [with `js` modules](https://purgecss.com/getting-started.html).

So ideally, you'd want static html files to purge from. I'm currently using "inspect element" and copying html to `/static/compiled.html`. It's probably wiser to **create a design system document** with all your styling options. From that you could use an [online `html->elm`](https://html-to-elm.com/) [service](https://mbylstra.github.io/html-to-elm/).

Alternatively, use [UnCSS](https://purgecss.com/comparison.html).

```terminal
# Purge CSS (remove unused styles)
# But for now we'll copy and paste js output
npx purgecss -css ./static/bulma.css --content ./static/compiled.html --output ./static/purged/
```

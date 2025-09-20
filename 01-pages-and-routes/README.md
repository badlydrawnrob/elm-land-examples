# Pages and Routes

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

## Commands

```terminal
# View all routes
elm-land routes

# Add a page with view only
elm-land add page:view /sign-in

# Add a nested route
elm-land add page:view /settings/account

# Add a dynamic route
elm-land add page:view /:user

# You can nest dynamic routes
elm-land add page:view /:user/:repo

# Unknown number of dynamic patterns (catch-all route)
# Github's code explorer is a good example (wildcard)
elm-land add page:view '/:user/:repo/tree/:branch/*'
```

## Routes

1. Dynamic routes have a `_` trailing slash.

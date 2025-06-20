# user-auth
> Built with [Elm Land](https://elm.land) 🌈

See your `/Library/code/elm` folder for documentation (or Elm Land website). This project uses the "full force" of Elm Land, not just `:view`, `:sandbox`, or `:element` pages.

## Local development

```bash
# Requires Node.js v18+ (https://nodejs.org)
npx elm-land server
```

## The API server

> Whenever you're working with a REST API endpoint, we recommend creating a module that takes care of the details.

So ours is `/Api/SignIn.elm` that exposed a `POST` function to our `/api/sign-in` endpoint.

## Deploying to production

Elm Land projects are most commonly deployed as static websites.

Please visit [the "Deployment" guide](https://elm.land/guide/deploying) to learn more
about deploying your app for free using Netlify or Vercel.

## Commands

```terminal
# By default adds `Browser.application`
elm-land add page /sign-in

# Clone the API repo (without history)
npx degit elm-land/elm-land/examples/05-user-auth/api-server server

# Change the "shared" module
elm-land customize shared

# Edit the `Effect` module
elm-land customize effect
```

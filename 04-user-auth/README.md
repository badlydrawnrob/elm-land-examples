# user-auth
> Built with [Elm Land](https://elm.land) 🌈

See your `/Library/code/elm` folder for documentation (or Elm Land website). This project uses the "full force" of Elm Land, not just `:view`, `:sandbox`, or `:element` pages.

## Copilot AI Agent

> Consider also adding a `TODO` or Github issues plugin.

**Regarding prompt versioning**: There isn't a built-in versioning system for our conversation, but you could:
 
- Save different versions of files manually
- Use git commits to track changes
- Copy code snippets to separate files for comparison
- Use VS Code's timeline feature to see file history

## Local development

```bash
# Start the server for /api/sign-in
cd server
npm start
# Run the Elm-Land server (from root)
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

```bash
# By default adds `Browser.application`
elm-land add page /sign-in

# Clone the API repo (without history)
npx degit elm-land/elm-land/examples/05-user-auth/api-server server

# Change the "shared" module
elm-land customize shared

# Edit the `Effect` module
elm-land customize effect
```

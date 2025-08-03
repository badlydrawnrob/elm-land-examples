# user-auth
> Built with [Elm Land](https://elm.land) 🌈

**See `/sign-in` page for most notes.**

See your `/Library/code/elm` folder for documentation (or Elm Land website). This project uses the "full force" of Elm Land, not just `:view`, `:sandbox`, or `:element` pages.

We don't want our `/sign-in` page to be auth-only, or our users won't be able to access it when they are signed out.

## Copilot AI Agent

> Consider also adding a `TODO` or Github issues plugin.

**Regarding prompt versioning**: There isn't a built-in versioning system for our conversation, but you could:
 
- Save different versions of files manually
- Use git commits to track changes
- Copy code snippets to separate files for comparison
- Use VS Code's timeline feature to see file history

### Layout with CSS grid

> I've changed the layout from documentation

A slightly different UI but the same functionality. It's just to practice css grid, so keeping it simple!

#### Ai response

> Is it better to use `auto-fit` in my case?

Great question! For your specific layout, auto-fit isn't ideal because you want specific control over the responsive behavior (single column on mobile, two columns on desktop with repositioned elements).

Here's why `auto-fit` doesn't work well for your use case:

- Why `auto-fit` isn't suitable:
- `auto-fit` automatically creates columns based on content width
- You need semantic control over layout (nav repositioning)
- Grid areas give you precise control over element placement
- Mobile needs single column regardless of content width

When to use `auto-fit`:

- Card layouts that wrap based on content
- Gallery/catalog layouts
- When you want CSS to decide column count
- Your layout needs semantic structure and precise responsive behavior, making explicit grid areas the right choice


## Local development

```bash
# Start the server for /api/sign-in
cd server
npm start
# Run the Elm-Land server (from root)
npx elm-land server
```

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

## The API server

> Whenever you're working with a REST API endpoint, we recommend creating a module that takes care of the details.

So ours is `/Api/SignIn.elm` that exposed a `POST` function to our `/api/sign-in` endpoint.

## Elm Land "magic"

> ⚠️ In production you'd might want to ditch token, but store user details. Failing that, make sure they have the right permissions and only update _their_ content.

The `Auth` module is pretty neat. It handles most of what you'd need for authentication. We've also added a nice `localStorage` part that'll save our token.

## Deploying to production

Elm Land projects are most commonly deployed as static websites.

Please visit [the "Deployment" guide](https://elm.land/guide/deploying) to learn more
about deploying your app for free using Netlify or Vercel.



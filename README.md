# Elm Land

> ⚠️ Be warned. This has A LOT of dependencies and js gets stale at warp-speed.

This repo has some examples I've followed along with and slightly modified. Other examples can be [found here](https://github.com/elm-land/elm-land/tree/main/examples).

Elm Land is fine for quicker builds, but it's potentially "dependency hell" as it's already showing vulnerabilities needing an `audit fix` (it'll update to an out-of-date version). Remember the rules of [Simplicity](https://pragprog.com/titles/dtcode/simplicity/).

Fine for prototyping, reasonably stable, but keep things as simple as possible, and consider using stock Elm for safer maintenance.

## The good

1. Elm Land handles our routing for us![^1]
2. It comes with a [VS Code plugin](https://github.com/elm-land/vscode)

## The bad

1. Everything loads from a single `.js` file ...
    - A SPA [may not run as quickly](https://adamsilver.io/blog/the-problem-with-single-page-applications/) or have other issues
2. Directly accessing the routes may require [server configuration](https://elm.land/guide/deploying.html#understanding-the-output) to point to `/index.html`.
3. Without `.editorconfig`, `elm-format` complains of tabs (not spaces)

[^1]: The `Url` package is kind of a headache. You can see some of [the routing code](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm) you'd need to add if done manually. Alternatively there's @lydell's [`elm-app-url`](https://github.com/lydell/elm-app-url/) for simpler routing.

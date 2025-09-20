# Query Parameters

> Built with [Elm Land](https://elm.land) 🌈

Here we're sorting 100% with Elm Lang and not using an API (backed by SQL) to manage our sorting for us. With SQL, it's easy to sort, and much faster:

```sql
SELECT * FROM table
ORDER BY colour;
```

But it requires perhaps multiple calls to the server, which could get expensive. For small datasets, it might make sense to do this client-side; large datasets, however, should almost always be handled on the server as it's far more efficient.

- A user's fruit basket (small data set, optionally handle client-side)
- A supermarket's fruit stock (large data set, handle server-side)

Databases are purpose-built to handle sorting and filtering large data sets: you can also cache on the server, or create views for regularly accessed items. You always want to move the minimal amount of data from server to client!

Also consider how much work the browser will have to do (can their device and network handle it easily?) — sometimes my browser jams up with heavy js, especially when handling other tasks.


## Setup

1. Our `Fruit.Color` module is quite straightforward 
2. Our `Fruit.Column` module seems to be acting as an Excel/SQL table

## Query params

> You might want to check some of these out ...

1. [Fast API](https://fastapi.tiangolo.com/tutorial/query-params/) article
2. [Array and map parameters](https://tinyurl.com/query-array-and-map-params)
3. [Wikipedia](https://en.wikipedia.org/wiki/Query_string) query strings

Some things to think about are: "do I want this [result] shareable?", "how does this affect url length?", "how is the user/developer experience?" (would it be better to POST `/searches` endpoint, rather than in the url?)


## Local development

```bash
# Requires Node.js v18+ (https://nodejs.org)
npx elm-land server
```

## Deploying to production

Elm Land projects are most commonly deployed as static websites. 

Please visit [the "Deployment" guide](https://elm.land/guide/deploying) to learn more
about deploying your app for free using Netlify or Vercel.
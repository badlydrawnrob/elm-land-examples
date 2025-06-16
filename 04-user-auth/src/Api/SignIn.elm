module Api.SignIn exposing (Data, post)

import Effect exposing (Effect)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Encode as E


-- Types -----------------------------------------------------------------------

type alias Data =
    { token : String }


-- Decoders --------------------------------------------------------------------

decoder : Decoder Data
decoder =
    D.map Data
        (D.field "token" D.string)

-- Requests --------------------------------------------------------------------

endpoint : String
endpoint =
    "http://localhost:5000/api/sign-in"

{-| This creates a `Cmd msg` that converts to `Effect msg`

Elm's standard way of sending side-effects is `Cmd msg`. We'll need a final
`Effect.sendCmd` function to convert `Cmd msg` to `Effect msg` the sign-in page
is expecting!

Later in the guide we can use `Effect msg` for _more_ than just sending commands.

-}
post :
    { onResponse : Result Http.Error Data -> msg
    , email : String
    , password : String
    }
    -> Effect msg
post options =
    let
        body : E.Value
        body =
            E.object
                [ ( "email", E.string options.email )
                , ( "password", E.string options.password )
                ]

        -- A flexible `msg` type for our `onResponse` handler.
        cmd : Cmd msg
        cmd =
            Http.post
                { url = endpoint
                , body = Http.jsonBody body
                , expect = Http.expectJson options.onResponse decoder
                }
    in
    -- Converts any `Cmd msg` into an `Effect msg`
    Effect.sendCmd cmd
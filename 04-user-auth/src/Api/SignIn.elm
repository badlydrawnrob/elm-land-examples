module Api.SignIn exposing (Data, Error, post)

import Effect exposing (Effect)
import Http
import Json.Decode as D exposing (Decoder)
import Json.Encode as E



-- Types -----------------------------------------------------------------------


type alias Data =
    { token : String }


type alias Error =
    { message : String
    , field : Maybe String
    }



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


## Notes

1.  #! We've changed from `Http.expectJson` to `Http.expectStringResponse`
      - This is overkill for me, and doubt I'd use it ...
      - Although it allows you to inspect the `POST` response body more carefully ...
      - So you can handle any field errors returned by the Api.

-}
post :
    { onResponse : Result (List Error) Data -> msg
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
                , expect =
                    Http.expectStringResponse
                        options.onResponse
                        handleHttpResponse
                }
    in
    -- Converts any `Cmd msg` into an `Effect msg`
    Effect.sendCmd cmd


handleHttpResponse : Http.Response String -> Result (List Error) Data
handleHttpResponse response =
    case response of
        Http.BadUrl_ _ ->
            Err
                [ { message = "Unexpected URL format"
                  , field = Nothing
                  }
                ]

        Http.Timeout_ ->
            Err
                [ { message = "Request timed out, please try again"
                  , field = Nothing
                  }
                ]

        Http.NetworkError_ ->
            Err
                [ { message = "Could not connect, please try again"
                  , field = Nothing
                  }
                ]

        Http.BadStatus_ { statusCode } body ->
            case D.decodeString errorsDecoder body of
                Ok errors ->
                    Err errors

                Err _ ->
                    Err
                        [ { message = "Something unexpected happened"
                          , field = Nothing
                          }
                        ]

        Http.GoodStatus_ _ body ->
            case D.decodeString decoder body of
                Ok data ->
                    Ok data

                Err _ ->
                    Err
                        [ { message = "Something unexpected happened"
                          , field = Nothing
                          }
                        ]


errorsDecoder : D.Decoder (List Error)
errorsDecoder =
    D.field "errors" (D.list errorDecoder)


errorDecoder : D.Decoder Error
errorDecoder =
    D.map2 Error
        (D.field "message" D.string)
        (D.field "field" (D.maybe D.string))



-- #! Yuck, maybe (use `nullable`?)

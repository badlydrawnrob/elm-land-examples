module Shared exposing
    ( Flags, decoder
    , Model, Msg
    , init, update, subscriptions
    )

{-|

@docs Flags, decoder
@docs Model, Msg
@docs init, update, subscriptions

-}

import Dict
import Effect exposing (Effect)
import Json.Decode
import Route exposing (Route)
import Route.Path
import Shared.Model
import Shared.Msg



-- FLAGS


type alias Flags =
    { user : Maybe Shared.Model.User }


decoder : Json.Decode.Decoder Flags
decoder =
    Json.Decode.map Flags
        (Json.Decode.field "user" (Json.Decode.nullable userDecoder))


userDecoder : Json.Decode.Decoder Shared.Model.User
userDecoder =
    Json.Decode.map5 Shared.Model.User
        (Json.Decode.field "token" Json.Decode.string)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "profileImageUrl" Json.Decode.string)
        (Json.Decode.field "email" Json.Decode.string)



-- INIT


type alias Model =
    Shared.Model.Model


init : Result Json.Decode.Error Flags -> Route () -> ( Model, Effect Msg )
init flagsResult route =
    let
        flags : Flags
        flags =
            flagsResult
                |> Result.withDefault { user = Nothing }
    in
    ( { user = flags.user }
    , Effect.none
    )



-- UPDATE


type alias Msg =
    Shared.Msg.Msg


update : Route () -> Msg -> Model -> ( Model, Effect Msg )
update route msg model =
    case msg of
        Shared.Msg.SignIn user ->
            ( { model | user = Just user }
            , Effect.batch
                [ Effect.pushRoute
                    { path = Route.Path.Home_
                    , query = Dict.empty
                    , hash = Nothing
                    }
                , Effect.saveUser user
                ]
            )

        Shared.Msg.SignOut ->
            ( { model | user = Nothing }
            , Effect.clearUser
            )



-- SUBSCRIPTIONS


subscriptions : Route () -> Model -> Sub Msg
subscriptions route model =
    Sub.none

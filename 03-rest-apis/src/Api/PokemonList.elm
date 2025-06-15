module Api.PokemonList exposing (Pokemon, getFirst150)

{-| Lets grab 150 pokemon from the Api

> We're using "Teach me how to message" style

This means we pass in a `record.onResponse` field to our Api getter function.
This allows us to pass in a message type we'd create with our parent module.

-}

import Http
import Json.Decode as D exposing (Decoder)



-- Types -----------------------------------------------------------------------


type alias Pokemon =
    { name : String }



-- Http ------------------------------------------------------------------------


{-| Teach me how to message

> You'll need to pass in a `.onResponse` field for your `Msg` type

The message must be a container for the same type of value

-}
getFirst150 :
    { onResponse : Result Http.Error (List Pokemon) -> msg }
    -> Cmd msg
getFirst150 options =
    Http.get
        { url = "http://localhost:5000/api/v2/pokemon?limit=150"
        , expect = Http.expectJson options.onResponse decoder
        }



-- Decoder ---------------------------------------------------------------------


decoder : Decoder (List Pokemon)
decoder =
    D.field "results" (D.list decodePokemon)


decodePokemon : Decoder Pokemon
decodePokemon =
    D.map Pokemon
        (D.field "name" D.string)

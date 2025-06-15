module Api.PokemonDetail exposing (Pokemon, get)

import Http
import Json.Decode as D exposing (Decoder)



-- Types -----------------------------------------------------------------------


type alias Pokemon =
    { name : String
    , pokedexId : Int
    , spriteUrl : String
    , types : List String
    }



-- Http ------------------------------------------------------------------------


get :
    { name : String
    , onResponse : Result Http.Error Pokemon -> msg
    }
    -> Cmd msg
get options =
    Http.get
        { url = "http://localhost:5000/api/v2/pokemon/" ++ options.name
        , expect = Http.expectJson options.onResponse decoder
        }



-- Decoder ---------------------------------------------------------------------


{-| Nested decoders are messy. Use `.at` instead
-}
decoder : Decoder Pokemon
decoder =
    D.map4 Pokemon
        (D.field "name" D.string)
        (D.field "id" D.int)
        (D.at [ "sprites", "other", "official-artwork", "front_default" ] D.string)
        (D.field "types" (D.list pokemonTypeDecoder))


{-| We can change shape and get `List String` of types ...

Instead of our nested structure below

```json
{
  "types": [
    {
      "type": {
        "name": "grass"
      }
    },
    {
      "type": {
        "name": "poison"
      }
    }
  ]
}
```

-}
pokemonTypeDecoder : Decoder String
pokemonTypeDecoder =
    D.at [ "type", "name" ] D.string

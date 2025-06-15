module Pages.Home_ exposing (Model, Msg, page)

{-| Running our PokeAPI server

## Fair use policy

We're asked to cache resources whenever possible. For that reason we'll use a
tiny Node.js app that caches the API requests for us.

## Notes

1. Our `Route.href` function handles `Url` building

## Functions

A great way to add a feature in Elm is to pretend you have the function you need, and then let the compiler walk you through the process of making it work.

```elm
Api.PokemonList.getFirst150
    { onResponse = PokeApiResponded
    }
```

-}

import Api
import Api.PokemonList exposing (Pokemon)
import Html exposing (Html, a, div, figure, h1, h2, img, p, text)
import Html.Attributes exposing (alt, class, href, src)
import Http
import Page exposing (Page)
import Route.Path
import View exposing (View)


page : Page Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model -----------------------------------------------------------------------

{-| Note we're using `List ...` not `Maybe (List ...)` -}
type alias Model =
    { pokemonData : Api.Data (List Pokemon) }

init : ( Model, Cmd Msg )
init =
    ( { pokemonData = Api.Loading }
    , Api.PokemonList.getFirst150
        { onResponse = PokeApiResponded } -- #! "Teach me how to message"
    )



-- Update ----------------------------------------------------------------------


type Msg
    = PokeApiResponded (Result Http.Error (List Pokemon))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PokeApiResponded (Ok listOfPokemon) ->
            ( { model | pokemonData = Api.Success listOfPokemon }
            , Cmd.none
            )

        PokeApiResponded (Err httpError) ->
            ( { model | pokemonData = Api.Failure httpError }
            , Cmd.none
            )



-- Subs ------------------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View ------------------------------------------------------------------------


view : Model -> View Msg
view model =
    { title = "Pokemon"
    , body =
        [ div [ class "hero is-danger py-6 has-text-centered" ]
            [ h1 [ class "title is-1" ] [ text "Pokemon" ]
            , h2 [ class "subtitle is-4" ] [ text "Gotta fetch `em all!" ]
            ]
        , case model.pokemonData of
            Api.Loading ->
                div [ class "has-text-centered p-6" ]
                    [ text "Loading..." ]

            Api.Success pokemon ->
                viewPokemonList pokemon

            Api.Failure httpError ->
                div [ class "has-text-centered p-6" ]
                    [ text (Api.toUserFriendlyMessage httpError) ]
        ]
    }

viewPokemonList : List Pokemon -> Html Msg
viewPokemonList listOfPokemon =
    div [ class "container py-6 p-5" ]
        [ div [ class "columns is-multiline" ]
            (List.indexedMap viewPokemon listOfPokemon)
        ]

viewPokemon : Int -> Pokemon -> Html Msg
viewPokemon index pokemon =
    let
        pokedexNumber : Int
        pokedexNumber =
            index + 1

        pokemonImageUrl : String
        pokemonImageUrl =
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
            ++ String.fromInt pokedexNumber
            ++ ".png"

        -- #! (1) This is a bit janky
        pokemonDetailRoute : Route.Path.Path
        pokemonDetailRoute =
            Route.Path.Pokemon_Name_
                { name = pokemon.name }
    in
    div [ class "column is-4-desktop is-6-tablet" ]
        [ a [ Route.Path.href pokemonDetailRoute ]
            [ div [ class "card" ]
                [ div [ class "card-content" ]
                    [ div [ class "media" ]
                        [ div [ class "media-left" ]
                            [ figure [ class "image is-64x64" ]
                                [ img [ src pokemonImageUrl, alt pokemon.name ] []
                                ]
                            ]
                        , div [ class "media-content" ]
                            [ p [ class "title is-4" ] [ text pokemon.name ]
                            , p [ class "subtitle is-6" ] [ text ("No. " ++ String.fromInt pokedexNumber) ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

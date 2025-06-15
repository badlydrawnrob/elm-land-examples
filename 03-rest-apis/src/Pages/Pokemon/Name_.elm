module Pages.Pokemon.Name_ exposing (Model, Msg, page)

import Api
import Api.PokemonDetail exposing (Pokemon)
import Html exposing (Html, a, div, figure, h1, h2, img, p, span, text)
import Html.Attributes exposing (alt, class, src, style)
import Http
import Page exposing (Page)
import Route.Path
import View exposing (View)


page : { name : String } -> Page Model Msg
page params =
    Page.element
        { init = init params
        , update = update
        , subscriptions = subscriptions
        , view = view params
        }



-- Model -----------------------------------------------------------------------


type alias Model =
    { pokemonData : Api.Data Pokemon }


init : { name : String } -> ( Model, Cmd Msg )
init params =
    ( { pokemonData = Api.Loading }
    , Api.PokemonDetail.get
        { name = params.name
        , onResponse = PokeApiResponded
        }
    )



-- Update ----------------------------------------------------------------------


type Msg
    = PokeApiResponded (Result Http.Error Pokemon)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PokeApiResponded (Ok pokemon) ->
            ( { model | pokemonData = Api.Success pokemon }
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


view : { name : String } -> Model -> View Msg
view params model =
    { title = "Pages.Pokemon.Name_"
    , body =
        [ div [ class "hero is-danger py-6 has-text-centered" ]
            [ h1 [ class "title is-1" ] [ text params.name ]
            , h2 [ class "subtitle is-6 is-underlined" ]
                [ a [ Route.Path.href Route.Path.Home_ ]
                    [ text "Back to Pokemon" ]
                ]
            ]
        , case model.pokemonData of
            Api.Loading ->
                div [ class "has-text-centered p-6" ]
                    [ text "Loading..." ]

            Api.Success pokemon ->
                viewPokemon pokemon

            Api.Failure httpError ->
                div [ class "has-text-centered p-6" ]
                    [ text (Api.toUserFriendlyMessage httpError) ]
        ]
    }


viewPokemon : Pokemon -> Html msg
viewPokemon pokemon =
    div [ class "container p-6 has-text-centered" ]
        [ viewPokemonImage pokemon
        , p [] [ text ("Pokedex No. " ++ String.fromInt pokemon.pokedexId) ]
        , viewPokemonTypes pokemon.types
        ]


viewPokemonImage : Pokemon -> Html msg
viewPokemonImage pokemon =
    figure
        [ class "image my-5 mx-auto"
        , style "width" "256px"
        , style "height" "256px"
        ]
        [ img [ src pokemon.spriteUrl, alt pokemon.name ] []
        ]


viewPokemonTypes : List String -> Html msg
viewPokemonTypes pokemonTypes =
    div [ class "tags is-centered py-4" ]
        (List.map viewPokemonType pokemonTypes)


viewPokemonType : String -> Html msg
viewPokemonType pokemonType =
    span [ class "tag" ] [ text pokemonType ]

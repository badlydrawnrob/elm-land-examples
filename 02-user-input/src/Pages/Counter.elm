module Pages.Counter exposing (Model, Msg, page)

{-| A simple counter

> Elm automatically calls `update` for us whenever `view` sends a `Msg`

Unlike a JS framework, we don't call the `update` function manually.

-}

import Components.Nav exposing (viewNav)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Page exposing (Page)
import View exposing (View)


page : Page Model Msg
page =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- Model -----------------------------------------------------------------------


type alias Model =
    { counter : Int }


init : Model
init =
    { counter = 0 }



-- Update ----------------------------------------------------------------------


type Msg
    = NoOp
    | Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Increment ->
            { model | counter = model.counter + 1 }

        Decrement ->
            { model | counter = model.counter - 1 }



-- View ------------------------------------------------------------------------


view : Model -> View Msg
view model =
    { title = "Counter"
    , body =
        [ Html.div [ Html.Attributes.class "layout" ]
            [ viewNav
            , Html.div [ Html.Attributes.class "page" ]
                [ Html.button
                    [ Html.Events.onClick Increment ]
                    [ Html.text "+" ]
                , Html.div []
                    [ Html.text (String.fromInt model.counter) ]
                , Html.button
                    [ Html.Events.onClick Decrement ]
                    [ Html.text "-" ]
                ]
            ]
        ]
    }

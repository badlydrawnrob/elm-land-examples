module Pages.SignIn exposing (Model, Msg, page)

import Effect exposing (Effect)
import Route exposing (Route)
import Html
import Page exposing (Page)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model -----------------------------------------------------------------------


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init () =
    ( {}
    , Effect.none
    )



-- Update ----------------------------------------------------------------------


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Effect.none
            )



-- Subscriptions ---------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View ------------------------------------------------------------------------


view : Model -> View Msg
view model =
    { title = "Pages.SignIn"
    , body = [ Html.text "/sign-in" ]
    }

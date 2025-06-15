module Pages.SignIn exposing (Model, Msg, page)

import Effect exposing (Effect)
import Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
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
    { email : String
    , password : String
    , isSubmittingForm : Bool
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { email = ""
      , password = ""
      , isSubmittingForm = False
      }
    , Effect.none
    )



-- Update ----------------------------------------------------------------------


type Msg
    = UserUpdatedInput Field String
    | UserSubmittedForm

type Field
    = Email
    | Password


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        UserUpdatedInput Email value ->
            ( { model | email = value }
            , Effect.none
            )
        
        UserUpdatedInput Password value ->
            ( { model | password = value }
            , Effect.none
            )
        
        UserSubmittedForm ->
            ( { model | isSubmittingForm = True }
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
    , body = 
        [ viewPage model
        ]
    }

viewPage : Model -> Html Msg
viewPage model =
    Html.div [ Attr.class "columns is-mobile is-centered" ]
        [ Html.div [ Attr.class "column is-narrow" ]
            [ Html.div [ Attr.class "section" ]
                [ Html.h1 [ Attr.class "title" ] [ Html.text "Sign in" ]
                , viewForm model
                ]
            ]
        ]

viewForm : Model -> Html Msg
viewForm model =
    Html.form [ Attr.class "box", Html.Events.onSubmit UserSubmittedForm ]
        [ viewFormInput
            { field = Email
            , value = model.email
            }
        , viewFormInput
            { field = Password
            , value = model.password
            }
        , viewFormControls model
        ]

viewFormInput : { field : Field, value : String } -> Html Msg
viewFormInput options =
    Html.div [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text (fromFieldToLabel options.field) ]
        , Html.div [ Attr.class "control" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.type_ (fromFieldToInputType options.field)
                , Attr.value options.value
                , Html.Events.onInput (UserUpdatedInput options.field)
                ]
                []
            ]
        ]

fromFieldToLabel : Field -> String
fromFieldToLabel field =
    case field of
        Email ->
            "Email address"
        
        Password ->
            "Password"

fromFieldToInputType : Field -> String
fromFieldToInputType field =
    case field of
        Email ->
            "email"
        
        Password ->
            "password"

viewFormControls : Model -> Html Msg
viewFormControls model =
    Html.div [ Attr.class "field is-grouped is-grouped-right" ]
        [ Html.div
            [ Attr.class "control" ]
            [ Html.button
                [ Attr.class "button is-link"
                , Attr.disabled model.isSubmittingForm
                , Attr.classList [ ("is-loading", model.isSubmittingForm) ]
                ]
                [ Html.text "Sign in" ]
            ]
        ]
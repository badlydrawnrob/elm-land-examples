module Pages.SignIn exposing (Model, Msg, page)

{-| We've got some new imports in this page


## Elm Land specific imports

1.  What's an `Effect Msg`?
      - Allows us to perform side-effects (similar to `Cmd Msg`)
      - We use `Effect.sendCmd cmd` rather than plain `Cmd Msg`
      - We create a custom `Effect msg` to hold the token in `src/Effect.elm`
      - Allows us to signin and signout users
2.  Why use `Field` types?
      - He uses an interesting method of `case`ing on the `Field`s
      - We can specifiy `Attr.type_` and `Html.label` ...
      - Although it's not much better than a simple `String`.
3.  What's the `Shared.Model` etc?
      - @ <https://elm.land/concepts/shared>
4.  `MeApiResponded` is a curried function I haven't seen before
      - It's a `Msg` that takes a `String` ...
      - But `Api.Me.get` only expects a `Result`
      - We want `token` to be available (we don't have to lift it out again)


## Error messages

> ⚠️ I don't like the fancier error messages we're using ... they seem
> an unecessary amount of work (to receive errors from server) rather than
> simply validating in Elm.

We're relying on our Api to return a granular list of errors. You should ALWAYS
check errors in both client-side and server-side, but I don't think it's necessary
for Elm to know about server-side type errors. This method also isn't a silver
bullet, as I don't expect server-side to display all errors at once.

`Http.Response` type returns `json` field errors (`Http.Error` doesn't)

  - Gives us access to the raw `json` body our Api returns
  - This particular server _still_ returns errors one at a time sometimes ...
  - So it's not that big of an improvement.

Email error checking is weak:

  - It's only using HTML `type="email"` to validate.


### Just use Elm to check errors and validate forms!

> Check your types and data with Elm and respond to server errors:

  - `BadBody String` (something went wrong with request)
  - `BadBody String` decoder fails


## See the build in stages

1.  <https://tinyurl.com/6d4f2c4-api-server-skeleton> (view / post to Api)
2.  <https://tinyurl.com/ede98b3-shared-model-effect> (redirect on success)
3.  <https://tinyurl.com/0e64d20-json-error-response> (fancier error messages)
4.  <https://tinyurl.com/365fefa-add-to-local-storage> (ports login/logout)
5.  <https://tinyurl.com/a4ddfd4-auth-only-pages> (auth-only pages)
6.  <https://tinyurl.com/049854c-get-and-save-user> (get user after signing in)

-}

import Api.Me
import Api.SignIn
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Http
import Page exposing (Page)
import Route exposing (Route)
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
    , errors : List Api.SignIn.Error
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { email = ""
      , password = ""
      , isSubmittingForm = False
      , errors = []
      }
    , Effect.none
    )



-- Update ----------------------------------------------------------------------


type Msg
    = UserUpdatedInput Field String
    | UserSubmittedForm
    | SignInApiResponded (Result (List Api.SignIn.Error) Api.SignIn.Data)
    | MeApiResponded String (Result Http.Error Api.Me.User)


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
            ( { model
                | isSubmittingForm = True
                , errors = []
              }
            , Api.SignIn.post
                { onResponse = SignInApiResponded
                , email = model.email
                , password = model.password
                }
            )

        SignInApiResponded (Ok { token }) ->
            ( model
            , Api.Me.get
                { token = token
                , onResponse = MeApiResponded token
                }
            )

        SignInApiResponded (Err errors) ->
            ( { model
                | isSubmittingForm = False
                , errors = errors
              }
            , Effect.none
            )

        MeApiResponded token (Ok user) ->
            ( { model | isSubmittingForm = False }
            , Effect.signIn
                { id = user.id
                , name = user.name
                , profileImageUrl = user.profileImageUrl
                , email = user.email
                , token = token
                }
            )

        MeApiResponded _ (Err httpError) ->
            let
                error : Api.SignIn.Error
                error =
                    { field = Nothing
                    , message = "User couldn't be found"
                    }
            in
            ( { model
                | isSubmittingForm = False
                , errors = [ error ]
              }
            , Effect.signOut
            )



-- Subscriptions ---------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
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
    Html.div [ Attr.class "page" ]
        [ Html.div [ Attr.class "page-layout has-text-light" ]
            [ Html.nav [ Attr.class "page-nav" ]
                [ Html.ul []
                    [ Html.li [] [ Html.a [ Attr.class "has-text-light" ] [ Html.text "Home" ] ]
                    , Html.li [] [ Html.a [ Attr.class "has-text-light" ] [ Html.text "Sign in" ] ]
                    , Html.li [] [ Html.a [ Attr.class "has-text-light" ] [ Html.text "Other" ] ]
                    ]
                ]
            , Html.header [ Attr.class "page-header" ]
                [ Html.h1 [ Attr.class "title has-text-light" ]
                    [ Html.text "Sign in" ]
                ]
            , Html.section [ Attr.class "page-intro" ]
                [ Html.p [] [ Html.text "introduction" ]
                ]
            , Html.main_ [ Attr.class "page-main" ]
                [ Html.div [ Attr.class "form-wrapper" ]
                    [ viewForm model ]
                , Html.div [ Attr.class "span-full" ]
                    [ Html.p []
                        [ Html.text "This is a full-width span." ]
                    ]
                ]
            ]
        , Html.footer [ Attr.class "page-footer has-text-light" ]
            [ Html.p [] [ Html.text "Footer content here" ] ]
        ]


viewForm : Model -> Html Msg
viewForm model =
    Html.form [ Attr.class "box has-background-dark has-text-light form-dark-theme", Html.Events.onSubmit UserSubmittedForm ]
        [ viewFormInput
            { field = Email
            , value = model.email
            , error = findFieldError "email" model
            }
        , viewFormInput
            { field = Password
            , value = model.password
            , error = findFieldError "password" model
            }
        , viewFormControls model
        ]


viewFormInput :
    { field : Field
    , value : String
    , error : Maybe Api.SignIn.Error
    }
    -> Html Msg
viewFormInput options =
    Html.div [ Attr.class "field" ]
        [ Html.label [ Attr.class "label" ] [ Html.text (fromFieldToLabel options.field) ]
        , Html.div [ Attr.class "control" ]
            [ Html.input
                [ Attr.class "input"
                , Attr.classList
                    [ ( "is-danger", options.error /= Nothing )
                    ]
                , Attr.type_ (fromFieldToInputType options.field)
                , Attr.value options.value
                , Html.Events.onInput (UserUpdatedInput options.field)
                ]
                []
            ]
        , case options.error of
            Just error ->
                Html.p
                    [ Attr.class "help is-danger" ]
                    [ Html.text error.message ]

            Nothing ->
                Html.text ""
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
    Html.div []
        [ Html.div [ Attr.class "field is-grouped is-grouped-right" ]
            [ Html.div
                [ Attr.class "control" ]
                [ Html.button
                    [ Attr.class "button is-danger"
                    , Attr.disabled model.isSubmittingForm
                    , Attr.classList [ ( "is-loading", model.isSubmittingForm ) ]
                    ]
                    [ Html.text "Sign in" ]
                ]
            ]
        , case findFormError model of
            Just error ->
                Html.p
                    [ Attr.class "help content is-danger" ]
                    [ Html.text error.message ]

            Nothing ->
                Html.text ""
        ]



-- Errors ----------------------------------------------------------------------


findFieldError : String -> Model -> Maybe Api.SignIn.Error
findFieldError field model =
    let
        hasMatchingField : Api.SignIn.Error -> Bool
        hasMatchingField error =
            error.field == Just field
    in
    model.errors
        |> List.filter hasMatchingField
        |> List.head


findFormError : Model -> Maybe Api.SignIn.Error
findFormError model =
    let
        doesntHaveField : Api.SignIn.Error -> Bool
        doesntHaveField error =
            error.field == Nothing
    in
    model.errors
        |> List.filter doesntHaveField
        |> List.head

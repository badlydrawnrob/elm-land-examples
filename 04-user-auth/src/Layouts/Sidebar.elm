module Layouts.Sidebar exposing (Model, Msg, Props, layout)

{-| Customising our layout

> I'm not sure I like this model of layout, rather the `view` should
> be on the `Page` and group components around types. Perhaps a master
> grid layout is okay, but most page-level layout should live elsewhere.

Every page can opt-in to using a layout using the `Page.withLayout` function.


## We can pass in props to our component

> Each page can send in layout "props" to customise the layout.
> Our layout will ask each page to provide the `props` fields.

1.  We want the title at the top of each page
2.  We want a nav to direct us to each page
3.  We want the `user` details to display

## We can also pass in `route` to our view

These can be forwarded to any function. For example, we can highlight
the current page in the sidebar.


## Our `Shared.Model` can also be exposed

Useful if we need a light/dark mode, or other metadata.


## Need route in your `init` function?

We can use this same strategy as the `view` function (in `layout`) to pass in
data to `init`, `update`, or `subscriptions`.


## Understanding the role of "contentMsg"

> #! For simplicity sake, you could AVOID using messages in your layout.

Instead of a normal `View Msg` being returned, it's a `View contentMsg`.
One of the contstraints of Elm is that _lists cannot return items of different
types_.

If we want out HTML to send layout messages _and_ page messages, we're going to
need to convert them into ONE common type `contentMsg`.

For that reason we'd need to use `Html.map toContentMsg` whenever we use a
`Html Msg` within a layout file.

-}

import Auth
import Effect exposing (Effect)
import Html exposing (Html)
import Html.Attributes exposing (alt, class, classList, src, style)
import Html.Events
import Json.Decode exposing (string)
import Layout exposing (Layout)
import Route exposing (Route)
import Route.Path
import Shared
import View exposing (View)


type alias Props =
    { title : String
    , user : Auth.User
    }


layout : Props -> Shared.Model -> Route () -> Layout () Model Msg contentMsg
layout props shared route =
    Layout.new
        { init = init -- `init route` if you need it
        , update = update
        , view = view props route
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = UserClickedSignOut


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        UserClickedSignOut ->
            ( model
            , Effect.signOut
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    Props
    -> Route ()
    ->
        { toContentMsg : Msg -> contentMsg
        , content : View contentMsg
        , model : Model
        }
    -> View contentMsg
view props route { toContentMsg, model, content } =
    { title = content.title ++ " | My Cool App"
    , body =
        [ Html.div [ class "is-flex", style "height" "100vh" ]
            [ viewSidebar
                { user = props.user
                , route = route
                }
                |> Html.map toContentMsg
            , viewMainContent
                { title = props.title
                , content = content
                }
            ]
        ]
    }


viewSidebar : { user : Auth.User, route : Route () } -> Html Msg
viewSidebar { user, route } =
    Html.aside
        [ class "is-flex is-flex-direction-column p-2"
        , style "min-width" "200px"
        , style "border-right" "solid 1px #eee"
        ]
        [ viewAppNameAndLogo
        , viewSidebarLinks route
        , viewSignOutButton user
        ]


viewAppNameAndLogo : Html msg
viewAppNameAndLogo =
    Html.div [ class "is-flex p-3" ]
        [ Html.figure []
            [ Html.img
                [ src "https://placehold.co/24x24"
                , alt "My Cool App's logo"
                ]
                []
            ]
        , Html.span [ class "has-text-weight-bold has-text-light pl-2" ]
            [ Html.text "My Cool App" ]
        ]


viewSidebarLinks : Route () -> Html msg
viewSidebarLinks route =
    let
        viewSidebarLink : ( String, Route.Path.Path ) -> Html msg
        viewSidebarLink ( label, path ) =
            Html.li []
                [ Html.a
                    [ Route.Path.href path
                    , classList
                        [ ( "is-active", route.path == path )
                        , ( "has-text-light", True )
                        ]
                    ]
                    [ Html.text label ]
                ]
    in
    Html.div [ class "menu is-flex-grow-1" ]
        [ Html.ul [ class "menu-list" ]
            (List.map viewSidebarLink
                [ ( "Dashboard", Route.Path.Home_ )
                , ( "Settings", Route.Path.Settings )
                , ( "Profile", Route.Path.Profile_Me )
                ]
            )
        ]


viewSignOutButton : Auth.User -> Html Msg
viewSignOutButton user =
    Html.button
        [ class "button is-text is-fullwidth"
        , Html.Events.onClick UserClickedSignOut
        ]
        [ Html.div [ class "is-flex has-text-light is-align-items-center" ]
            [ Html.figure [ class "image is-24x24" ]
                [ Html.img
                    [ class "is-rounded"
                    , src user.profileImageUrl
                    , alt user.name
                    ]
                    []
                ]
            , Html.span [ class "pl-2" ] [ Html.text "Sign out" ]
            ]
        ]


viewMainContent : { title : String, content : View msg } -> Html msg
viewMainContent { title, content } =
    Html.main_ [ class "is-flex is-flex-direction-column is-flex-grow-1" ]
        [ Html.section [ class "hero is-info" ]
            [ Html.div [ class "hero-body" ]
                [ Html.h1 [ class "title" ] [ Html.text title ]
                ]
            ]
        , Html.div [ class "p-4" ] content.body
        ]

module Components.Sidebar exposing (..)

{-| Navigating between pages

> The sidebar for our pages

Some of these package imports are Elm Land specific, such as `View`.
To make it easy to reuse, we'll accept the entire page as the input to
the UI component.


## Notes

1.  `props` -> `{ title, body }`
      - Instead of `props.title` we use `{ title }`
      - The guide directly places `List (Html msg) in the`body\`
2.  For some reason we have to use `List (Html msg)` not `Html msg`
      - This is the same as `Browser.document` docs

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import View exposing (View)


view : { title : String, body : List (Html msg) } -> View msg
view { title, body } =
    { title = title
    , body = viewBody body
    }


viewBody : List (Html msg) -> List (Html msg)
viewBody body =
    [ div [ class "layout" ]
        [ aside [ class "sidebar" ]
            [ a [ href "/" ] [ text "Home" ]
            , a [ href "/elm-land" ] [ text "User" ]
            , a [ href "/elm-land/vscode" ] [ text "Repo" ]
            , a [ href "/settings/account" ] [ text "Settings" ]
            ]
        , div [ class "page" ] body
        ]
    ]

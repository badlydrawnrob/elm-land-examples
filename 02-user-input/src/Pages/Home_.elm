module Pages.Home_ exposing (page)

import Components.Nav exposing (viewNav)
import Html
import Html.Attributes
import View exposing (View)


page : View msg
page =
    { title = "Homepage"
    , body =
        [ Html.div [ Html.Attributes.class "layout" ]
            [ viewNav
            , Html.text "Hello, world!"
            ]
        ]
    }

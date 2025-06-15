module Components.Nav exposing (viewNav)

import Html exposing (Html)
import Html.Attributes


viewNav : Html msg
viewNav =
    Html.aside [ Html.Attributes.class "sidebar" ]
        [ Html.a [ Html.Attributes.href "/" ] [ Html.text "Home" ]
        , Html.a [ Html.Attributes.href "/counter" ] [ Html.text "Counter" ]
        ]

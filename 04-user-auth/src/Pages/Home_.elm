module Pages.Home_ exposing (page)

import Html
import View exposing (View)

{-| Everything is in the `SignIn` module
-}

page : View msg
page =
    { title = "Homepage"
    , body = [ Html.text "Hello, world!" ]
    }

module Pages.Home_ exposing (page)

{-| Opt in to which pages use the sidebar component

You can import the module for any pages you like. We pass in the entire page
to the sidebar component (both the title and the body)

-}

import Components.Sidebar
import Html
import View exposing (View)


page : View msg
page =
    Components.Sidebar.view
        { title = "Homepage"
        , body = [ Html.text "Hello, world!" ]
        }

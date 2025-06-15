module Pages.Settings.Account exposing (page)

import Components.Sidebar
import Html exposing (Html)
import View exposing (View)


page : View msg
page =
    Components.Sidebar.view
        { title = "Pages.Settings.Account"
        , body = [ Html.text "/settings/account" ]
        }

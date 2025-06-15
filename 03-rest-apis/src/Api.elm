module Api exposing (Data(..), toUserFriendlyMessage)

import Http

type Data value
    = Loading
    | Success value
    | Failure Http.Error

{-| You could use `Debug` here if needed

You'd need to replicate the users steps and check what `httpError` message
was saying. See also "4. Timeout & bad status" on this page for logging options:

- @ https://elm.land/guide/rest-apis.html#:~:text=4.%20Timeout%20&%20bad%20status

-}
toUserFriendlyMessage : Http.Error -> String
toUserFriendlyMessage httpError =
    case httpError of
        Http.BadUrl _ ->
            -- URL malformed, probably a typo
            "This page requested a bad URL"

        Http.Timeout ->
            -- Happens after
            "Request took too long to respond"

        Http.NetworkError ->
            -- User is offline or API isn't online
            "Could not connect to the API"

        Http.BadStatus code ->
            -- Connected to API but something went wrong
            if code == 404 then
                "Item not found"

            else
                "API returned an error code"

        Http.BadBody _ ->
            -- Our JSON decoder didn't match what the API sent
            "Unexpected response from the API"

export const flags = ({ env }) => {
    // Called before our Elm app starts
    return {
        user: JSON.parse(window.localStorage.user || null)
    }

}

export const onReady = ({ app, env }) => {
    // Called after our Elm app starts
    if (app.ports && app.ports.sendToLocalStorage) {
        app.ports.sendToLocalStorage.subscribe(({ key, value }) => {
            window.localStorage[key] = JSON.stringify(value)
        })
    }
}
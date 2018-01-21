case "start_login":
    console.log('Try SSO Login');
    var xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    xhr.open('POST', 'get_user_token.php', true);
    xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    var thisobject = this;

    xhr.onload = function () {
        // do something to response
        console.log(this.response);

        if ((xhr.status == '200') && this.response.accessToken) {
            H.setLoggedIn(this.response);
            thisobject.setStateForNewView({
                view: unnamed_object.LOGGING_IN
            });
        } else {
            console.log('SSO login failled, php page returned ' + xhr.status + ' error or returned an empty accessToken');
            thisobject.setStateForNewView({
                view: unnamed_object.LOGIN
            }), thisobject.notifyNewScreen("login");
        }
    };
    xhr.send(JSON.stringify({ 'devicename' : this.props.defaultDeviceDisplayName }));
    break;
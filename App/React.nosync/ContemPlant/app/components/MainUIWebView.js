import React, { Component } from 'react';
import { WebView } from 'react-native';

import {ServerConstants} from "../config/Constants"
import { storeLogin, removeLogin, getLogin } from "../lib/loginStore"

export default class MainUIWebView extends Component {
    constructor(props) {
        super(props);
        this.state = {login: null}
    }

    onMessage(event) {
        const data = event.nativeEvent.data.split("|")
        
        //NEVER JUST PRINT/console.log THE EVENT, THIS DOES NOT WORK AND NOBODY KNOWS WHY...
        if (data.length !== 2) {
            return
        }

        const eventType = data[0]
        const eventDataRaw = data[1]
        const eventParamsRaw = eventDataRaw.split(",")

        const eventData = {}
        eventParamsRaw.map(x => x.split(":")).forEach(x => eventData[x[0]] = x[1])
        console.log(eventData)

        switch (eventType) {
            case "login": 
                if (eventParamsRaw.length !== 3) {
                    return
                }
        
                const email = eventData["email"]
                const username = eventData["username"]
                const jwt = eventData["jwt"]

                //save login data
                storeLogin(username, email, jwt)

                this.props.onLogin({jwt: jwt, username: username, email: email})

                break; //IMPORTANT!!!
            case "loadOnArdu":
                const plantID = eventData["plantID"]
                const plantName = eventData["plantName"]

                this.props.onArduLoad(plantID, plantName)
                break;
            case "logout":
                removeLogin()
                this.updateLoginState()
                break
            default:
                return
        }
    }

    async updateLoginState() {
        try {
            const loginCred = await getLogin()
            this.setState({login: loginCred})
        } catch (e) {
            console.log("no login credentials", e)
        }
    }

    async componentDidMount() {
        await this.updateLoginState()
    }

    setupWebviewJS() {
        if (this.state.login) {
            const keys = ["jwt", "email", "username"]
            const jss = keys.map( (key) => `sessionStorage.setItem("${key}", "${this.state.login[key]}")`)

            console.log("js string: ", jss.join(";"))
            return `if(!sessionStorage.getItem("jwt")){${jss.join(",")};location.reload()}`
        }
        return "" //no special setup
    }

    render() {
        return (
        <WebView
            source={{uri: this.state.login ? ServerConstants.overviewURL : ServerConstants.loginURL}}
            style={{marginTop: 0}}
            javaScriptEnabled={true}
            onMessage={this.onMessage.bind(this)}
            injectedJavaScript={this.setupWebviewJS()}
        />
        );
  }
}

import React, { Component } from 'react';
import { WebView } from 'react-native';

import {ServerConstants} from "../config/Constants"

export default class MainUIWebView extends Component {
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

                this.props.onLogin({jwt: jwt, username: username, email: email})

                break; //IMPORTANT!!!
            case "loadOnArdu":
                const plantID = eventData["plantID"]
                const plantName = eventData["plantName"]

                this.props.onArduLoad(plantID, plantName)
                break;
            default:
                return
        }
    }

    render() {
        return (
        <WebView
            source={{uri: ServerConstants.loginURL}}
            style={{marginTop: 20}}
            javaScriptEnabled={true}
            onMessage={this.onMessage.bind(this)}
        />
        );
  }
}
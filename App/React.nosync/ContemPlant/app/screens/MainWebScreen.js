import React, { Component } from 'react';
import MainUIWebView from '../components/MainUIWebView';

export default class MainWebScreen extends Component {
    static navigationOptions = {
        title: 'ContemPlant',
    };

    render() {
        const { navigate } = this.props.navigation;

        return (
            <MainUIWebView style={{flex: 1}} 
                onLogin={(params) => this.setState(params)} 
                onArduLoad={(plantID, plantName) => navigate("ArduLoader", {plantID: plantID, plantName: plantName, jwt: this.state.jwt})}
            />
        );
    }
}
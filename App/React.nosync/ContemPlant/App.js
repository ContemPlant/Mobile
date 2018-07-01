/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import LoadPlantScreen from './app/components/LoadPlantScreen';
import MainUIWebView from './app/components/MainUIWebView';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  render() {
    const jsCode = "window.postMessage(document.getElementById('gb-main').innerHTML)"
    return (
      <View style={{flex: 1}}>
        <View style={{flex: 1}}> 
          <MainUIWebView style={{flex: 1}} 
              onLogin={(params) => console.log("LOOOOO", params)} 
              onArduLoad={(params) => console.log("ARDUUUU", params)}
          /> 
        </View>
        <View style={{flex: 0}}> <LoadPlantScreen style={{flex: 0}} /> </View>
      </View>
    );
  }
}
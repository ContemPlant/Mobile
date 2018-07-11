
import React, { Component } from 'react';
import { Platform } from 'react-native';

import { createStackNavigator } from 'react-navigation';
import { LoadPlantScreen, MainWebScreen, PlantLoadedScreen } from './app/screens';


const MainNavigator = createStackNavigator({
  MainUIWebView: { screen: MainWebScreen },
  ArduLoader: { screen: LoadPlantScreen },
  PlantLoadedScreen: { screen: PlantLoadedScreen }
});


export default class App extends React.Component {
  render() {
    return <MainNavigator/>;
  }
}
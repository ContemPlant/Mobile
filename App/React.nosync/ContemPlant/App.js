/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { HttpLink } from 'apollo-link-http';
import { ApolloClient } from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';

import {
  Platform,
} from 'react-native';
import { createStackNavigator } from 'react-navigation';

import { ServerConstants } from "./app/config/Constants"
import { LoadPlantScreen, MainWebScreen } from './app/screens';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});


const MainNavigator = createStackNavigator({
  MainUIWebView: { screen: MainWebScreen },
  ArduLoader: { screen: LoadPlantScreen },
}, client);

const client = new ApolloClient({
  link: new HttpLink({uri: ServerConstants.graphQLURL}),
  cache: new InMemoryCache()
})

export default class App extends React.Component {
  render() {
    return <ApolloProvider client={client}>
              <MainNavigator screenProps={{client: client}}/>;
            </ApolloProvider>
  }
}
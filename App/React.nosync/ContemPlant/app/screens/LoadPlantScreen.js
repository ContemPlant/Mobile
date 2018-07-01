'use strict';

import React, { Component } from 'react';

import {
  StyleSheet,
  Text,
  View
} from 'react-native';

import { ApolloClient } from 'apollo-client';
import { ApolloLink } from 'apollo-link';
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
import gql from 'graphql-tag'

import ArduQRCodeScanner from "../components/ArduQRCodeScanner"
import { ServerConstants } from '../config/Constants';


export default class LoadPlantScreen extends Component {
  constructor(props){
    super(props);

    const token = this.props.navigation.state.params.jwt

    const AuthLink = (operation, forward) => {
      const token = this.props.navigation.state.params.jwt;
    
      operation.setContext(context => ({
        ...context,
        headers: {
          ...context.headers,
          authorization: `Bearer ${token}`,
        },
      }));
    
      return forward(operation);
    };

    const client = new ApolloClient({
      link: ApolloLink.from([AuthLink, (new HttpLink({uri: ServerConstants.graphQLURL}))]),
      cache: new InMemoryCache()
    })

    this.state = {
        plantID: this.props.navigation.state.params.plantID,
        plantName: this.props.navigation.state.params.plantName,
        jwt: this.props.navigation.state.params.jwt,
        client: client
    }
    
  }

  static navigationOptions = ({ navigation }) => ({
    title: navigation.state.params.plantName
  })



  async loadPlantOnArdu(arduID) {
    console.log("Found ardu ID: ", arduID, "should loaded on ", this.state.plantID)
    // console.log("client", this.props.screenProps.client)
    const client = this.state.client

    if (!client) return

    const plantID = this.state.plantID
    
    client.mutate({
      mutation: gql`
              mutation LoadPlant {
                loadPlantOnArdu(arduId: "${arduID}" plantId: "${plantID}") {
                  arduId
                }
              }
            `
    }).then(res => console.log("RESP: ", res))
  }

  render() {
    return (
      <View style={styles.whiteBackground}>
        <Text style={styles.centerText}>
          Bitte schiebe das Smartphone in die Box!
        </Text>
        <ArduQRCodeScanner 
          style={styles.hidden}
          onArduIDRead={(arduID) => this.loadPlantOnArdu(arduID)}
          isCameraScreenHidden={true}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  whiteBackground: {
    backgroundColor: "#fff",
    position: "absolute", 
    top: 0,
    bottom: 0, 
    left: 0, 
    right: 0
  },
  hidden: {
    flex:0,
    height:0
  },
  centerText: {
    flex: 10,
    fontSize: 49,
    padding: 32,
    color: '#777',
    fontWeight: '500',
    textAlign: "center",
    textAlignVertical: "center"
  }
});

const loadPlantOnArduQuery = (arduId, plantID) => {
  return `loadPlantOnArdu(
  arduId: "${arduId}"
  plantId: "${plantID}"
  ){ arduId } `
}
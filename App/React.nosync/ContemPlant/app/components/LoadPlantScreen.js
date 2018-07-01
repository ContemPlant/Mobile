'use strict';

import React, { Component } from 'react';

import {
  AppRegistry,
  StyleSheet,
  Text,
  TouchableOpacity,
  Linking,
  Dimensions,
} from 'react-native';

import ArduQRCodeScanner from "./ArduQRCodeScanner"

export default class LoadPlantScreen extends Component {
  render() {
    return (
      <ArduQRCodeScanner
        onArduIDRead={(arduID) => console.log("Found ardu ID: ", arduID)}
        isCameraScreenHidden={true}
      />
    );
  }
}

const styles = StyleSheet.create({
  fullScreenCamera: {
    flex: 0,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent',
    height: Dimensions.get('window').height,
    width: Dimensions.get('window').width
  },
  centerText: {
    flex: 1,
    fontSize: 18,
    padding: 32,
    color: '#777',
  },
  textBold: {
    fontWeight: '500',
    color: '#000',
  },
  buttonText: {
    fontSize: 21,
    color: 'rgb(0,122,255)',
  },
  buttonTouchable: {
    padding: 16,
  },
});
'use strict';

import React, { Component } from 'react';

import {
  StyleSheet,
  Dimensions,
} from 'react-native';

import QRCodeScanner from 'react-native-qrcode-scanner';

import { consistsOfDigitsOnly } from '../lib/string';

export default class ArduQRCodeScanner extends Component {
  onSuccess(e) {
    const arduID = e.data
    if (consistsOfDigitsOnly(arduID)) {
        //success
        this.props.onArduIDRead(arduID)
    }
  }

  render() {
    return (
      <QRCodeScanner
        reactivate={true}
        onRead={this.onSuccess.bind(this)}
        cameraStyle={this.props.isCameraScreenHidden ? styles.hideCamera : styles.fullScreenCamera}
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
  hideCamera: {
      flex: 0,
      width: 0,
      height: 0
  }
});
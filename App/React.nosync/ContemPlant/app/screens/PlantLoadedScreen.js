import React, {Component} from 'react';
import {StyleSheet, Modal, Text, Button, View} from 'react-native';

import gql from 'graphql-tag'

export default class PlantLoadedScreen extends Component {
    constructor(props) {
        super();
        let modalVisible = false;
        if (props.navigation && props.navigation.state && props.navigation.state.params ) {
          modalVisible = props.navigation.state.params.modalVisible;
        }
    
        this.state = {
          modalVisible: modalVisible,
        };
      }

    state = {
        modalVisible: false,
    };

    closeModal() {
        this.setState({ modalVisible:false });
        if (this.props.navigation) {
          this.props.navigation.goBack();
        }
    }

    render() {
        return (
            <Modal
            animationType="slide"
            transparent={false}
            visible={this.state.modalVisible}
            onRequestClose={ () => this.closeModal() }
            >
            <View style={{marginTop: 0}}>
                <View>
                <Text style={styles.centerText}>Hello World!</Text>

                <Button
                    onPress={() => {
                    this.unloadPlantFromArdu()
                    }} 
                    title="Lernen beenden!"
                />
                </View>
            </View>
            </Modal>
        );
    }

    async unloadPlantFromArdu() {
        const client = this.props.navigation.state.params.client
    
        if (!client) return
    
        const plantID = this.props.navigation.state.params.plantID
        
        client.mutate({
          mutation: gql`
                  mutation UnloadPlant {
                    unloadPlant(plantId: "${plantID}") {
                        arduId
                        loadedPlant {id}
                    }
                  }
                `
        }).then(res => {
          console.log("RESP: ", res)
          this.closeModal()
        }).catch(e => {
          console.log(e);
        })
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
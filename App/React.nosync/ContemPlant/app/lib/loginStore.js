import { AsyncStorage } from 'react-native';

const StoreKeys = {
    LoginKeys: {
        username: "@Login:username",
        email: "@Login:email",
        jwt: "@Login:jwt"
    }
}

export const storeLogin = async (username, email, jwt) => {
    try {
        await AsyncStorage.setItem(StoreKeys.LoginKeys.email, email)
        await AsyncStorage.setItem(StoreKeys.LoginKeys.username, username)
        await AsyncStorage.setItem(StoreKeys.LoginKeys.jwt, jwt)
        console.log("stored login...")
    } catch (error) {
      // Error saving data
      console.log("error saving login credentials", error)
    }
  }

export const removeLogin = async () => {
      try {
          await AsyncStorage.removeItem(StoreKeys.LoginKeys.email)
          await AsyncStorage.removeItem(StoreKeys.LoginKeys.username)
          await AsyncStorage.removeItem(StoreKeys.LoginKeys.jwt)
          console.log("removed login...")
      } catch (error) {
          console.log("error removing login credentials!", error)
      }
  }

export const getLogin = async () => {
    try {
      const email = await AsyncStorage.getItem(StoreKeys.LoginKeys.email)
      const username = await AsyncStorage.getItem(StoreKeys.LoginKeys.username)
      const jwt = await AsyncStorage.getItem(StoreKeys.LoginKeys.jwt)

      console.log("got login...", email, username, jwt)
      if (jwt) {
        // We have data!!
        return {
            jwt: jwt,
            email: email,
            username: username
        }
      }
      else {
          throw "Not found any login credentials"
      }
     } catch (error) {
       // Error retrieving data
       throw error
     }
  }
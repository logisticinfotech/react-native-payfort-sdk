/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

// import payFort from './src/Component/PayFort/PayFort';
import { NativeModules, Platform, PermissionsAndroid } from "react-native";
const { PayFort } = NativeModules;

export const RNPayFort = async parameter => {
  if (Platform.OS === "android") {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        return new Promise(async (resolve, reject) => {
          if (
            parameter.command &&
            parameter.access_code &&
            parameter.merchant_identifier &&
            parameter.sha_request_phrase &&
            parameter.email &&
            parameter.language &&
            parameter.amount &&
            parameter.currencyType &&
            parameter.testing
          ) {
            await PayFort.Pay(
              JSON.stringify(parameter),
              successResponseData => {
                resolve(JSON.parse(successResponseData));
              },
              errorResponseData => {
                reject(JSON.parse(errorResponseData));
              }
            );
          } else {
            reject({
              response_code: "MissingParameter",
              response_message: "Please enter all required Parameter."
            });
          }
        });
      } else {
        console.log("Read phone state permission denied");
        return new Promise(async (resolve, reject) => {
          reject({
            response_code: "PermissionRequired",
            response_message: "Grant permission for Read phone state."
          });
        });
      }
    } catch (err) {
      console.warn(err);
    }
  }
  if (Platform.OS === "ios") {
    return new Promise(async (resolve, reject) => {
      if (
        parameter.command &&
        parameter.access_code &&
        parameter.merchant_identifier &&
        parameter.sha_request_phrase &&
        parameter.email &&
        parameter.language &&
        parameter.amount &&
        parameter.currencyType &&
        parameter.testing
      ) {
        await PayFort.Pay(
          JSON.stringify(parameter),
          successResponseData => {
            console.log('successResponseData',successResponseData)
            resolve(successResponseData);
          },
          errorResponseData => {
            reject(errorResponseData);
          }
        );
      } else {
        reject({
          response_code: "MissingParameter",
          response_message: "Please enter all required Parameter."
        });
      }
    });
  }
};

export const applePayViaPayfort = async (parameter) => { 
  if (Platform.OS === "ios") {

    console.log('parameter====>test=>', parameter)
    return new Promise(async (resolve, reject) => {
      if (
        parameter.command &&
        parameter.access_code &&
        parameter.merchant_identifier &&
        parameter.sha_request_phrase &&
        parameter.email &&
        parameter.language &&
        parameter.amount &&
        parameter.currencyType &&
        parameter.testing
      ) {
        await PayFort.PayWithApplePay(
          JSON.stringify(parameter),
          successResponseData => {
            console.log('successResponseData',successResponseData)
            resolve(successResponseData);
          },
          errorResponseData => {
            reject(errorResponseData);
          }
        );
      } else {
        reject({
          response_code: "MissingParameter",
          response_message: "Please enter all required Parameter."
        });
      }
    });
  }
};


export const getPayFortDeviceId = async () => {
  if (Platform.OS === "android") {
    try {
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.READ_PHONE_STATE
      );
      if (granted === PermissionsAndroid.RESULTS.GRANTED) {
        return new Promise(async (resolve, reject) => {
          console.log("sdk_token from web");
          await PayFort.getDeviceId(async successResponseData => {
            resolve(successResponseData);
          });
        });
      } else {
        return new Promise(async (resolve, reject) => {
          reject({
            response_code: "PermissionRequired",
            response_message: "Grant permission for Read phone state."
          });
        });
      }
    } catch (err) {
      return new Promise(async (resolve, reject) => {
        reject({
          response_code: "UnknownError",
          response_message: err
        });
      });
    }
  } else {
    return new Promise(async (resolve, reject) => {
      console.log("sdk_token from web");
      await PayFort.getDeviceId(async successResponseData => {
        resolve(successResponseData);
      });
    });
  }
};

export default { RNPayFort, getPayFortDeviceId, applePayViaPayfort };

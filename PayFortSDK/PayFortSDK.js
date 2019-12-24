/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

// import payFort from './src/Component/PayFort/PayFort';
import {NativeModules, Platform} from 'react-native';
const { RNPayfortSdk } = NativeModules;

const RNPayFort = async parameter => {
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
      await RNPayfortSdk.Pay(
        JSON.stringify(parameter),
        successResponseData => {
          resolve(
            Platform.OS === 'android'
              ? JSON.parse(successResponseData)
              : successResponseData,
          );
        },
        errorResponseData => {
          reject(
            Platform.OS === 'android'
              ? JSON.parse(errorResponseData)
              : errorResponseData,
          );
        },
      );
    } else {
      reject({
        response_code: 'MissingParameter',
        response_message: 'Please enter all required Parameter.',
      });
    }
  });
};

export default RNPayFort;

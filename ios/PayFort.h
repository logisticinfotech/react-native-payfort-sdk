#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/RCTLog.h>
#include <CommonCrypto/CommonDigest.h>

#import <PayFortSDK.framework/Versions/A/Headers/PayFortSDK.h>
@interface PayFort : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>

@end

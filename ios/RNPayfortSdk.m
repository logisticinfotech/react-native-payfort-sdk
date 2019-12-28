
#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTConvert.h"
#import <PayFortSDK/PayFortView.h>

@interface RCT_EXTERN_MODULE(PayFortSDK, NSObject)

RCT_EXTERN_METHOD(Pay:(NSString *)dataDict successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
@end

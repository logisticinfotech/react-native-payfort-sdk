#import "PayFort.h"


@implementation PayFort


NSString *sdk_token;
NSMutableData *webDataglobal;
NSString *_merchant_reference;
NSDictionary *applePayRequestDict;
RCTResponseSenderBlock successCallbackApplePay;
RCTResponseSenderBlock errorCallbackApplePay;
RCTResponseSenderBlock successCallbackPayfort;
RCTResponseSenderBlock errorCallbackPayfort;
BOOL isApplePaymentDidPayment = FALSE;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getDeviceId:(RCTResponseSenderBlock)successCallback){
    PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentProduction];
    //    NSString *UUID = [[NSUUID UUID] UUIDString];
    successCallback(@[PayFort.getUDID]);
}

RCT_EXPORT_METHOD(Pay:(NSString *)strData successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
{
    NSDictionary *input = [self convertToDictonary:strData];
    _merchant_reference = [input objectForKey:@"merchant_reference"];

    sdk_token = [input objectForKey:@"sdk_token"];
    NSLog(@"sdk_token: %@",sdk_token);
    
    if (_merchant_reference == nil)
    {
        _merchant_reference = [NSString stringWithFormat:@"%d",arc4random()];
    }
    
    successCallbackPayfort = successCallback;
    errorCallbackPayfort = errorCallback;
    
    if (sdk_token == nil || sdk_token == (id)[NSNull null]) {
        
        [self getSDKToken:input completionHandler:^(bool Success) {
            if (Success)
            {
                [self payWithPayfort:input];
            }
            
        }];
    } else {
        [self payWithPayfort:input];
    }
}

RCT_EXPORT_METHOD(PayWithApplePay:(NSString *)strData successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        applePayRequestDict = [self convertToDictonary:strData];
        _merchant_reference = [applePayRequestDict objectForKey:@"merchant_reference"];
        
        sdk_token = [applePayRequestDict objectForKey:@"sdk_token"];
        NSLog(@"sdk_token: %@",sdk_token);
        
        if (_merchant_reference == nil)
        {
            _merchant_reference = [NSString stringWithFormat:@"%d",arc4random()];
        }
        
        if (sdk_token == nil || sdk_token == (id)[NSNull null]) {
            
            [self getSDKToken:applePayRequestDict completionHandler:^(bool Success) {
                if (Success)
                {
                    [self applePayWithPayfort:errorCallback andSuccessCallbackApplePay:successCallback];
                }
                
            }];
        } else {
            [self applePayWithPayfort:errorCallback andSuccessCallbackApplePay:successCallback];
        }
    });
}

- (void)getSDKToken:(NSDictionary *)input completionHandler:(void (^)(bool  Success))completionHandler
{
    NSNumber *isLive = [input objectForKey:@"isLive"];
    NSString *access_code = [input objectForKey:@"access_code"];
    NSString *merchant_identifier = [input objectForKey:@"merchant_identifier"];
    _merchant_reference = [input objectForKey:@"merchant_reference"];
    NSString *language = [input objectForKey:@"language"];
    NSString *shaPhrase = [input objectForKey:@"sha_request_phrase"];
    
    PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:[isLive boolValue] ? KPayFortEnviromentProduction : KPayFortEnviromentSandBox];

    NSMutableString *post = [NSMutableString string];
    [post appendFormat:@"%@access_code=%@",shaPhrase, access_code];
    [post appendFormat:@"device_id=%@",  PayFort.getUDID];
    [post appendFormat:@"language=%@", language];
    [post appendFormat:@"merchant_identifier=%@", merchant_identifier];
    NSString *token = [NSString stringWithFormat:@"SDK_TOKEN%@",shaPhrase];
    [post appendFormat:@"service_command=%@", token];
    NSLog(@"%@", post);
    NSDictionary* tmp = @{ @"service_command": @"SDK_TOKEN",
                           @"merchant_identifier": merchant_identifier,
                           @"access_code": access_code,
                           @"signature": [self sha1Encode:post],
                           @"language": language,
                           @"device_id": PayFort.getUDID};
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    NSString *BaseDomain = @"https://sbpaymentservices.payfort.com/FortAPI/paymentApi";
    NSString *urlString = [NSString stringWithFormat:@"%@",BaseDomain];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postdata length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postdata];
    
    NSLog(@"url string %@",urlString);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSError *error = nil;
            id object = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:0
                         error:&error];
            NSLog(@"object Data %@",object);
            if(error) {
                NSLog(@"Error %@",error);
                return;
            }
            sdk_token = object[@"sdk_token"];
            completionHandler(true);
        }
        else
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [task resume];
    completionHandler(false);
}


- (void)payWithPayfort:(NSDictionary *)input
{
    NSNumber *isLive = [input objectForKey:@"isLive"];
    _merchant_reference = [input objectForKey:@"merchant_reference"];
    NSString *language = [input objectForKey:@"language"];
    NSString *token_name = [input objectForKey:@"token_name"];
    
    NSString *command = [input objectForKey:@"command"];
    NSString *merchant_extra = [input objectForKey:@"merchant_extra"];
    NSString *merchant_extra1 = [input objectForKey:@"merchant_extra1"];
    NSString *merchant_extra2 = [input objectForKey:@"merchant_extra2"];
    NSString *merchant_extra3 = [input objectForKey:@"merchant_extra3"];
    NSString *merchant_extra4 = [input objectForKey:@"merchant_extra4"];
    NSString *customer_name = [input objectForKey:@"customer_name"];
    NSString *customer_email = [input objectForKey:@"email"];
    NSString *phone_number = [input objectForKey:@"phone_number"];
    NSString *payment_option = [input objectForKey:@"payment_option"];
    //            NSString *language = [input objectForKey:@"language"];
    NSString *currency = [input objectForKey:@"currencyType"];
    NSString *amount = [input objectForKey:@"amount"];
    NSString *eci = [input objectForKey:@"eci"];
    NSString *order_description = [input objectForKey:@"order_description"];
    
    PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:[isLive boolValue] ? KPayFortEnviromentProduction : KPayFortEnviromentSandBox ];
    [PayFort setPayFortCustomViewNib:@"PayFortView2"];
    
    NSMutableDictionary *request = [[NSMutableDictionary alloc]init];
    [request setValue:command forKey:@"command"];
    [request setValue:sdk_token forKey:@"sdk_token"];
    [request setValue:token_name forKey:@"token_name"];
    [request setValue:_merchant_reference forKey:@"merchant_reference"];
    [request setValue:merchant_extra forKey:@"merchant_extra"];
    [request setValue:merchant_extra1 forKey:@"merchant_extra1"];
    [request setValue:merchant_extra2 forKey:@"merchant_extra2"];
    [request setValue:merchant_extra3 forKey:@"merchant_extra3"];
    [request setValue:merchant_extra4 forKey:@"merchant_extra4"];
    [request setValue:customer_name forKey:@"customer_name"];
    [request setValue:customer_email forKey:@"customer_email"];
    [request setValue:phone_number forKey:@"phone_number"];
    [request setValue:payment_option forKey:@"payment_option"];
    [request setValue:language forKey:@"language"];
    [request setValue:currency forKey:@"currency"];
    [request setValue:amount forKey:@"amount"];
    [request setValue:eci forKey:@"eci"];
    [request setValue:order_description forKey:@"order_description"];
    
    //[PayFort setPayFortCustomViewNib:@"PayFortView2"];
    PayFort.IsShowResponsePage = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *nav =  (UIViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [PayFort callPayFortWithRequest:request currentViewController:nav
                                Success:^(NSDictionary *requestDic, NSDictionary *responeDic) {
            NSLog(@"Success");
            NSLog(@"responeDic=%@",responeDic);
            successCallbackPayfort(@[responeDic]);
        }
                               Canceled:^(NSDictionary *requestDic, NSDictionary *responeDic) {
            NSLog(@"Canceled");
            NSLog(@"responeDic=%@",responeDic);
            errorCallbackPayfort(@[responeDic]);
            
        }
                                  Faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
            NSLog(@"Faild");
            NSLog(@"responeDic=%@",responeDic);
            errorCallbackPayfort(@[responeDic]);
        }];
    });
}

- (void)applePayWithPayfort:(RCTResponseSenderBlock )errorCallback andSuccessCallbackApplePay:(RCTResponseSenderBlock )successCallback
{
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = [applePayRequestDict objectForKey:@"apple_pay_merchant_identifier"];
    if (@available(iOS 12.1.1, *)) {
        request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkMada];
    } else {
        request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    }
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    request.countryCode = @"SA";
    request.currencyCode =  [applePayRequestDict objectForKey:@"currencyType"];
            
    NSMutableArray *arrSummaryItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *objItem in [applePayRequestDict objectForKey:@"arrItem"])
    {

        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithMantissa:strtoull([[objItem valueForKey:@"price"] UTF8String], NULL, 0) exponent:-2 isNegative:NO];
        
        
        [arrSummaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:[objItem valueForKey:@"productName"] amount:price]];
    }
    
    request.paymentSummaryItems = [arrSummaryItems copy];
    PKPaymentAuthorizationViewController *applePayController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    applePayController.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *nav =  (UIViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        [nav presentViewController:applePayController animated:YES completion:nil];        
    });
    
    successCallbackApplePay = successCallback;
    errorCallbackApplePay = errorCallback;
}

-(NSDictionary *) convertToDictonary:(NSString *)strData
{
    NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

- (NSString*)sha1Encode:(NSString*)input {
    
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier backgroundTask;
    backgroundTask =
    [application beginBackgroundTaskWithExpirationHandler: ^ {
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid; }];
}

- (void)getModuleInfo:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *info = @{
        @"name" : @"react-native-payfort",
        @"description" : @"A React Native bridge module for interacting with Payfort SDK",
        @"className" : @"RCTPayfort",
        @"author": @"Hazem El-Sisy",
    };
    callback(@[[NSNull null], info]);
}


#pragma mark - PKPaymentAuthorizationViewControllerDelegate


-(void)paymentAuthorizationViewController:
(PKPaymentAuthorizationViewController *)controller
                      didAuthorizePayment:(PKPayment *)payment
                               completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    BOOL asyncSuccessful = payment.token.paymentData.length != 0;
    NSLog(@"%@", payment);
//    completion(PKPaymentAuthorizationStatusSuccess);

    if(asyncSuccessful) {
        
        NSString *command = [applePayRequestDict objectForKey:@"command"];
        NSString *merchant_extra = [applePayRequestDict objectForKey:@"merchant_extra"];
        NSString *merchant_extra1 = [applePayRequestDict objectForKey:@"merchant_extra1"];
        NSString *merchant_extra2 = [applePayRequestDict objectForKey:@"merchant_extra2"];
        NSString *merchant_extra3 = [applePayRequestDict objectForKey:@"merchant_extra3"];
        NSString *merchant_extra4 = [applePayRequestDict objectForKey:@"merchant_extra4"];
        NSString *customer_name = [applePayRequestDict objectForKey:@"customer_name"];
        NSString *customer_email = [applePayRequestDict objectForKey:@"email"];
        NSString *phone_number = [applePayRequestDict objectForKey:@"phone_number"];
        NSString *payment_option = [applePayRequestDict objectForKey:@"payment_option"];
        NSString *amount = [applePayRequestDict objectForKey:@"amount"];
        NSString *eci = [applePayRequestDict objectForKey:@"eci"];
        NSNumber *isLive = [applePayRequestDict objectForKey:@"isLive"];
        NSString *token_name = [applePayRequestDict objectForKey:@"token_name"];
        _merchant_reference = [applePayRequestDict objectForKey:@"merchant_reference"];
        NSString *language = [applePayRequestDict objectForKey:@"language"];
        NSString *currency = [applePayRequestDict objectForKey:@"currencyType"];
        NSString *order_description = [applePayRequestDict objectForKey:@"order_description"];
        
        PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:[isLive boolValue] ? KPayFortEnviromentProduction : KPayFortEnviromentSandBox ];
        [PayFort setPayFortCustomViewNib:@"PayFortView2"];
        
        NSMutableDictionary *request = [[NSMutableDictionary alloc]init];
        [request setValue:command forKey:@"command"];
        [request setValue:[applePayRequestDict objectForKey:@"sdk_token"] forKey:@"sdk_token"];
        [request setValue:token_name forKey:@"token_name"];
        [request setValue:_merchant_reference forKey:@"merchant_reference"];
        [request setValue:merchant_extra forKey:@"merchant_extra"];
        [request setValue:merchant_extra1 forKey:@"merchant_extra1"];
        [request setValue:merchant_extra2 forKey:@"merchant_extra2"];
        [request setValue:merchant_extra3 forKey:@"merchant_extra3"];
        [request setValue:merchant_extra4 forKey:@"merchant_extra4"];
        [request setValue:customer_name forKey:@"customer_name"];
        [request setValue:customer_email forKey:@"customer_email"];
        [request setValue:phone_number forKey:@"phone_number"];
        [request setValue:payment_option forKey:@"payment_option"];
        [request setValue:language forKey:@"language"];
        [request setValue:currency forKey:@"currency"];
        [request setValue:amount forKey:@"amount"];
        [request setValue:eci forKey:@"eci"];
        [request setValue:order_description forKey:@"order_description"];
        [request setValue:command forKey:@"command"];
        [request setValue:@"APPLE_PAY" forKey:@"digital_wallet"];

        NSLog(@"request-applePay%@", request);
        PayFort.IsShowResponsePage = YES;
        
        UIViewController *nav =  (UIViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;

        [PayFort callPayFortForApplePayWithRequest:request
                                   applePayPayment:payment
                             currentViewController:nav
                                           Success:^(NSDictionary *requestDic, NSDictionary *responeDic) {
            isApplePaymentDidPayment = TRUE;
            successCallbackApplePay(@[responeDic]);
            completion(PKPaymentAuthorizationStatusSuccess);
        }
                                             Faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
            isApplePaymentDidPayment = TRUE;
            errorCallbackApplePay(@[responeDic]);
            completion(PKPaymentAuthorizationStatusFailure);
        }];
    } else {
        isApplePaymentDidPayment = TRUE;
        errorCallbackApplePay(@[]);
        completion(PKPaymentAuthorizationStatusFailure);        
    }
}


-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    if(!isApplePaymentDidPayment)
    {
        errorCallbackApplePay(@[applePayRequestDict]);
    }
    [controller dismissViewControllerAnimated:true completion:nil];
}


@end

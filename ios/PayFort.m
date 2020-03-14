#import "PayFort.h"


@implementation PayFort


NSString *sdk_token;
NSMutableData *webDataglobal;
NSString *_merchant_reference;


RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getDeviceId:(RCTResponseSenderBlock)successCallback){
     PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentSandBox];
//    NSString *UUID = [[NSUUID UUID] UUIDString];
    successCallback(@[PayFort.getUDID]);
}

RCT_EXPORT_METHOD(Pay:(NSString *)strData successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback)
{
    NSDictionary *input = [self convertToDictonary:strData];
    NSNumber *isLive = [input objectForKey:@"isLive"];
    NSString *access_code = [input objectForKey:@"access_code"];
    NSString *merchant_identifier = [input objectForKey:@"merchant_identifier"];
    _merchant_reference = [input objectForKey:@"merchant_reference"];
    NSString *language = [input objectForKey:@"language"];
    NSString *shaPhrase = [input objectForKey:@"sha_request_phrase"];
    NSString *token_name = [input objectForKey:@"token_name"];
    sdk_token = [input objectForKey:@"sdk_token"];
    NSLog(@"sdk_token: %@",sdk_token);
    
    
    if (_merchant_reference == nil)
    {
        _merchant_reference = [NSString stringWithFormat:@"%d",arc4random()];
    }
        
    if (sdk_token == nil || sdk_token == (id)[NSNull null]) {
        PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentSandBox];
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
        //51c177660e62066006326f8eb5b731da31881a870b3cc1029fed72766faf2c04
        NSString *BaseDomain = @"https://sbpaymentservices.payfort.com/FortAPI/paymentApi";
        NSString *urlString = [NSString stringWithFormat:@"%@",BaseDomain];
        NSString *postLength = [NSString stringWithFormat:@"%ld",[postdata length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postdata];
        
        NSLog(@"url string %@",urlString);
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data,
                                                                                         NSURLResponse *response,
                                                                                         NSError *error)
                                      {
            if (!error)
        {
                NSError *error = nil;
                id object = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:0
                             error:&error];
                //webDataglobal = [NSMutableData data];
                NSLog(@"object Data %@",object);
                
                if(error) {
                    NSLog(@"Error %@",error);
                    return;
                }
                sdk_token = object[@"sdk_token"];
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
                        
                        PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentSandBox];
                        [PayFort setPayFortCustomViewNib:@"PayFortView2"];
                        
                        
                        //PayFort.delegate = self;
                        
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
                                successCallback(@[responeDic]);
                            }
                                                   Canceled:^(NSDictionary *requestDic, NSDictionary *responeDic) {
                                NSLog(@"Canceled");
                                NSLog(@"responeDic=%@",responeDic);
                                errorCallback(@[responeDic]);

                            }
                                                      Faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
                                NSLog(@"Faild");
                                NSLog(@"responeDic=%@",responeDic);
                                errorCallback(@[responeDic]);
                            }];
                        });
            }
                else
                {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
            }];
            [task resume];
    } else {
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
                    
                    PayFortController *PayFort = [[PayFortController alloc]initWithEnviroment:KPayFortEnviromentSandBox];
                    [PayFort setPayFortCustomViewNib:@"PayFortView2"];
                    
                    
                    //PayFort.delegate = self;
                    
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
                            successCallback(@[responeDic]);
                        }
                                               Canceled:^(NSDictionary *requestDic, NSDictionary *responeDic) {
                            NSLog(@"Canceled");
                            NSLog(@"responeDic=%@",responeDic);
                            errorCallback(@[responeDic]);

                        }
                                                  Faild:^(NSDictionary *requestDic, NSDictionary *responeDic, NSString *message) {
                            NSLog(@"Faild");
                            NSLog(@"responeDic=%@",responeDic);
                            errorCallback(@[responeDic]);
                        }];
                    });
    }    
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

@end

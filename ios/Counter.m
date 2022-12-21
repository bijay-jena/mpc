//
//  Counter.m
//  mpc1
//
//  Created by Bijay Jena on 14/12/22.
//

#import <Foundation/Foundation.h>

#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(Counter,RCTEventEmitter)

RCT_EXTERN_METHOD(increment:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(decrement:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(setUpDevice:(NSString *) name)
RCT_EXTERN_METHOD(host)
RCT_EXTERN_METHOD(join)
RCT_EXTERN_METHOD(sendMsg:(NSString *) msg)

@end

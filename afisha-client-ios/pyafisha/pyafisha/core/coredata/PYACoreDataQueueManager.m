//
//  PYACoreDataQueueManager.m
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import "PYACoreDataQueueManager.h"

@implementation PYACoreDataQueueManager

static dispatch_queue_t sharedInst;

+ (dispatch_queue_t)coreDataOperationsSerialQueue {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInst = dispatch_queue_create("com.epgData.serialQueue", 0);
    });
    
    return sharedInst;
}
@end

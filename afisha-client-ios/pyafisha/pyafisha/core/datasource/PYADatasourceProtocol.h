//
//  PYADatasourceProtocol.h
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PYADatasourceFetchResultType : NSUInteger {
    
    PYADatasourceFetchResultFromNormal   = 1,
    PYADatasourceFetchResultFromCache  = 2
    
} PYADatasourceFetchResultType;

//typedef void(^PYADatasourceFetchCallback)(NSError *error, NSArray *result, PYADatasourceFetchResultType fetchResultType);


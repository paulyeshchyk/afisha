//
//  PYAApplicationFunctions.h
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

static inline NSString *documentsDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
}

static inline NSString *cachesDirectory(){
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
}

static inline NSString *tempDirectory(){
    
    return NSTemporaryDirectory();
    
}


static inline NSString *applicationVersionNumber(){
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *applicationVersionString =  [NSString stringWithFormat:@"%@", [bundleInfo objectForKey:@"CFBundleShortVersionString"]];
    
    NSCharacterSet *versionNumberCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    NSCharacterSet *notVersionNumberCharacters = [versionNumberCharacters invertedSet];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:applicationVersionString];
    
    NSString *applicationVersionNumberString;
    
    [scanner scanUpToCharactersFromSet:notVersionNumberCharacters intoString:&applicationVersionNumberString];
    
    return applicationVersionNumberString;
    
}

static inline NSString *applicationVersionAndBuildNumber(){
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *applicationVersionAndBuildNumberString = [NSString stringWithFormat:@"%@ (%@)", applicationVersionNumber(), [bundleInfo objectForKey:@"CFBundleVersion"]];
    
    return applicationVersionAndBuildNumberString;
    
}


void dispatchOnMainQueue(dispatch_block_t block);
void dispatchOnBackgroundQueue(dispatch_block_t block);
void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block);
void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block);
float nanosecondsWithSeconds(float seconds);
dispatch_time_t dispatchTimeFromNow(float seconds);
//
//  PYACoreDataProvider.h
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYACoreDataProvider : NSObject

+ (PYACoreDataProvider *)sharedInstance;
+ (NSManagedObjectContext *)workingContext;
+ (NSManagedObjectContext *)mainManagedObjectContext;
+ (BOOL)saveWorkingContext:(NSManagedObjectContext *)workingContext error:(NSError **)error;

- (NSManagedObjectContext *)managedObjectContext;

@end

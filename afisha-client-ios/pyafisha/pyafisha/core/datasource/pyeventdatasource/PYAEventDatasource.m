//
//  PYAEventDatasource.m
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import "PYAEventDatasource.h"
#import "PYACoreDataProvider.h"
#import "PYCoreDataEvent.h"
#import "PYACoreDataQueueManager.h"

@implementation PYAEventDatasource

#pragma mark -
#pragma mark PYADatasourceProtocol

- (Class) coreDataClass {
    
    return [PYCoreDataEvent class];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    return [[PYACoreDataProvider sharedInstance] managedObjectContext];
}

- (NSString *)sectionNameKeyPath {
    
    return self.sectionNamePath;
}

- (BOOL)performFetch:(NSError *__autoreleasing *)error {

    self.fetchRequest.predicate = self.predicate;
    self.fetchRequest.sortDescriptors = self.sortDescriptors;
    self.fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(self.coreDataClass) inManagedObjectContext:self.managedObjectContext];
    return [super performFetch:error];
}


- (void)addEventWithName:(NSString *)eventName {
    
    dispatch_async([PYACoreDataQueueManager coreDataOperationsSerialQueue], ^{
        
        NSManagedObjectContext *workingContext = [PYACoreDataProvider workingContext];
        
        PYCoreDataEvent *event = (PYCoreDataEvent *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PYCoreDataEvent class]) inManagedObjectContext:workingContext];
        [event setName:eventName];
        
        NSError *error = nil;

        [PYACoreDataProvider saveWorkingContext:workingContext error:&error];
        
    });
    
}

@end

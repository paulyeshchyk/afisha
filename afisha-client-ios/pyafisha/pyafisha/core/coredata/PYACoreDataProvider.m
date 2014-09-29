//
//  PYACoreDataProvider.m
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import "PYACoreDataProvider.h"
#import <CoreData/CoreData.h>

@interface PYACoreDataProvider ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation PYACoreDataProvider

static PYACoreDataProvider *coreDataContextProvider = nil;

+ (PYACoreDataProvider *)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        coreDataContextProvider = [[PYACoreDataProvider alloc] init];
    });
    
    return coreDataContextProvider;
}

+ (NSManagedObjectContext *)workingContext {

    NSManagedObjectContext *newWorkingContext = [[NSManagedObjectContext alloc] init];
    
    [newWorkingContext setPersistentStoreCoordinator:[self sharedInstance].persistentStoreCoordinator];
    
    newWorkingContext.undoManager = nil;
    
    return newWorkingContext;
}

+ (NSManagedObjectContext *)mainManagedObjectContext {
    
    return [[self sharedInstance] managedObjectContext];
}

+ (BOOL)saveWorkingContext:(NSManagedObjectContext *)workingContext error:(NSError **)error {
    
    BOOL result = NO;
    if ([workingContext hasChanges]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]  selector:@selector(workingContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:workingContext];
        
        [workingContext save:error];
        result = (error == nil);
        [[NSNotificationCenter defaultCenter]  removeObserver:[self sharedInstance] name:NSManagedObjectContextDidSaveNotification object:workingContext];
    }
    return result;
}


- (void)workingContextDidSave:(NSNotification *)notification {
    
    [self performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                           withObject:notification waitUntilDone:YES];
}


- (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)notification {
    
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel == nil) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PYAfisha" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator == nil) {
        
        NSString *storePath = [cachesDirectory() stringByAppendingPathComponent:@"PYAfisha.sqlite"];
        
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:NULL];
            
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                
//                debugLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    
    return _persistentStoreCoordinator;
}
@end

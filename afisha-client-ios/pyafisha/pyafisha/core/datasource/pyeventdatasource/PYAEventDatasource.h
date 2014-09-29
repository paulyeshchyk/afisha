//
//  PYAEventDatasource.h
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

@interface PYAEventDatasource : NSFetchedResultsController

@property (nonatomic, strong)NSPredicate *predicate;
@property (nonatomic, assign)NSInteger fetchLimit;
@property (nonatomic, assign)NSInteger fetchOffset;
@property (nonatomic, readonly)Class coreDataClass;
@property (nonatomic, copy)NSArray *sortDescriptors;
@property (nonatomic, copy)NSString *sectionNamePath;

- (void)addEventWithName:(NSString *)eventName;

@end

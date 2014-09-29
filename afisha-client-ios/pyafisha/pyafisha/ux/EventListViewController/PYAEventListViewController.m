//
//  PYAEventListViewController.m
//  pyafisha
//
//  Created by Pavel Yeshchyk on 9/29/14.
//  Copyright (c) 2014 py. All rights reserved.
//

#import "PYAEventListViewController.h"
#import "PYACoreDataProvider.h"
#import "PYAEventListTableViewCell.h"
#import "PYCoreDataEvent.h"
#import "PYACoreDataQueueManager.h"

@interface PYAEventListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultController;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *reorderModeButton;
@property (nonatomic, assign) BOOL editingMode;
@end

@implementation PYAEventListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    self.fetchedResultController.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.editingMode = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PYAEventListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PYAEventListTableViewCell"];
    // Override point for customization after application launch.

    NSManagedObjectContext *context = [PYACoreDataProvider mainManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PYCoreDataEvent"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultController.delegate = self;
    [self.fetchedResultController performFetch:NULL];
    

}

- (void)setEditingMode:(BOOL)editingMode {
    
    _editingMode = editingMode;
    [self.reorderModeButton setTitle:_editingMode?@"normal":@"reorder"];
    [self.tableView setEditing:_editingMode animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)reorderMode:(id)sender {

    self.editingMode = !self.editingMode;
}



- (IBAction)onAddClicked:(id)sender {
    
    dispatch_async([PYACoreDataQueueManager coreDataOperationsSerialQueue], ^{
        
        NSManagedObjectContext *workingContext = [PYACoreDataProvider workingContext];
        
        PYCoreDataEvent *event = (PYCoreDataEvent *)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PYCoreDataEvent class]) inManagedObjectContext:workingContext];
        [event setName:@"ztest 234"];
        
        NSError *error = nil;
        
        [PYACoreDataProvider saveWorkingContext:workingContext error:&error];
       
    });
}


#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self.fetchedResultController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultController sections] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:@"PYAEventListTableViewCell"];
    [self configureCell:result atIndexPath:indexPath];
    
    return result;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_async([PYACoreDataQueueManager coreDataOperationsSerialQueue], ^(){
        
        id obj = [self.fetchedResultController objectAtIndexPath:indexPath];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            dispatch_async([PYACoreDataQueueManager coreDataOperationsSerialQueue], ^{
            
                NSManagedObjectContext *workingContext = [PYACoreDataProvider workingContext];
                id objToDelete = [workingContext objectWithID:[obj objectID]];
                [workingContext deleteObject:objToDelete];
                [PYACoreDataProvider saveWorkingContext:workingContext error:NULL];
            });
        }
    });
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    PYAEventListTableViewCell *result = (PYAEventListTableViewCell *)cell;
    PYCoreDataEvent* obj = (PYCoreDataEvent *)[self.fetchedResultController objectAtIndexPath:indexPath];
    result.name = obj.name;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert: {
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {

            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {

            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove: {
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}
@end

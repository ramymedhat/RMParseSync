//
//  TKMasterViewController.h
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-06.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

//
//  TKDetailViewController.h
//  ParseSyncExample
//
//  Created by Ramy Medhat on 2014-04-06.
//  Copyright (c) 2014 Inovaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

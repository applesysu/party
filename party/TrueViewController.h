//
//  TrueViewController.h
//  party
//
//  Created by Lancy on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrueViewController;

@protocol TrueViewControllerDelegate
- (void)TrueViewControllerDidFinish:(TrueViewController *)controller;
@end


@interface TrueViewController : UIViewController
{
    NSDictionary *_theTrueOne;
}

@property (assign, nonatomic) IBOutlet id <TrueViewControllerDelegate> delegate;

@property (retain, nonatomic) NSDictionary* theTrueOne;
@property (retain, nonatomic) IBOutlet UIImageView *trueOneHead;

- (IBAction)finish:(id)sender;
@end

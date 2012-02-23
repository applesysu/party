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


@interface TrueViewController : UIViewController <RenrenDelegate>
{
    Renren *_renren;
    NSDictionary *_theTrueOne;
}

@property (retain, nonatomic) Renren *renren;

@property (assign, nonatomic) IBOutlet id <TrueViewControllerDelegate> delegate;

@property (retain, nonatomic) NSDictionary* theTrueOne;
@property (retain, nonatomic) IBOutlet UIImageView *trueOneHead;
@property (retain, nonatomic) IBOutlet UILabel *trueOneNameLabel;

- (IBAction)pressShareButton:(id)sender;

- (IBAction)finish:(id)sender;
@end

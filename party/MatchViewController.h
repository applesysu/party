//
//  MatchViewController.h
//  party
//
//  Created by Lancy on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrueViewController.h"

@class MatchViewController;

@protocol MatchViewControllerDelegate
- (void)matchViewControllerDidFinish:(MatchViewController *)controller;
@end



@interface MatchViewController : UIViewController <RenrenDelegate, TrueViewControllerDelegate>
{
    Renren *_renren;
    ROUserResponseItem *_userItem;
    NSDictionary *_maleMatchOne;
    NSDictionary *_femaleMatchOne;
}

@property (assign, nonatomic) IBOutlet id <MatchViewControllerDelegate> delegate;

@property (retain, nonatomic) Renren *renren;
@property (retain, nonatomic) ROUserResponseItem *userItem;
@property (retain, nonatomic) NSDictionary *maleMatchOne;
@property (retain, nonatomic) NSDictionary *femaleMatchOne;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headPic;


- (IBAction)pressShareButton:(id)sender;
- (IBAction)pressBackButton:(id)sender;

- (IBAction)pressTureButton:(id)sender;
@end

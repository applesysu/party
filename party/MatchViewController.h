//
//  MatchViewController.h
//  party
//
//  Created by Lancy on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TrueViewController.h"

@interface MatchViewController : UIViewController <RenrenDelegate, TrueViewControllerDelegate>
{
    Renren *_renren;
    ROUserResponseItem *_userItem;
    NSDictionary *_maleMatchOne;
    NSDictionary *_femaleMatchOne;
}

@property (retain, nonatomic) Renren *renren;
@property (retain, nonatomic) ROUserResponseItem *userItem;
@property (retain, nonatomic) NSDictionary *maleMatchOne;
@property (retain, nonatomic) NSDictionary *femaleMatchOne;

@property (retain, nonatomic) IBOutlet UILabel *testLabel;
@property (retain, nonatomic) IBOutlet UIImageView *maleHead;
@property (retain, nonatomic) IBOutlet UIImageView *femaleHead;

- (IBAction)pressShareButton:(id)sender;

- (IBAction)pressTureButton:(id)sender;
@end

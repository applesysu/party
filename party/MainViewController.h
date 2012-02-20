//
//  MainViewController.h
//  party
//
//  Created by Lancy on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <RenrenDelegate>
{
    Renren *_renren;
    ROUserResponseItem *_userItem;
}

@property (retain, nonatomic) Renren *renren;
@property (retain, nonatomic) ROUserResponseItem *userItem;
@property (retain, nonatomic) IBOutlet UILabel *welcome;
- (IBAction)pressLoginButton:(id)sender;
- (IBAction)showMatchView:(id)sender;

@end

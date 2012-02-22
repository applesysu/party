//
//  MainViewController.m
//  party
//
//  Created by Lancy on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
- (void)getUserInfo;
- (void)letLoginViewHidden:(BOOL)toggle;
@end

@implementation MainViewController

@synthesize renren = _renren;
@synthesize userItem = _userItem;
@synthesize welcome = _welcome;
@synthesize loginImage = _loginImage;
@synthesize loginButton = _loginButton;
@synthesize logoutButton = _logoutButton;
@synthesize matchButton = _matchButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_welcome release];
    self.renren = nil;
    [_loginImage release];
    [_loginButton release];
    [_logoutButton release];
    [_matchButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.renren = [Renren sharedRenren];
    if ([self.renren isSessionValid])
    {
        [self getUserInfo];
    } else
    {
        [self letLoginViewHidden:NO];
    }
    
}

- (void)viewDidUnload
{
    [self setWelcome:nil];
    [self setLoginImage:nil];
    [self setLoginButton:nil];
    [self setLogoutButton:nil];
    [self setMatchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - RENREN login and logout methods

- (IBAction)pressLogoutButton:(id)sender {
    [[Renren sharedRenren] logout:self];
    [self letLoginViewHidden:NO];
}

- (void)pressLoginButton:(id)sender
{
    if (![self.renren isSessionValid]) {
		NSArray *permissions = [NSArray arrayWithObjects:@"read_user_album",@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",nil];
		[self.renren authorizationWithPermisson:permissions andDelegate:self];
	} else {
        NSLog(@"already login");
        [self getUserInfo];
	}
    
}

-(void)renrenDidLogin:(Renren *)renren{
    [self getUserInfo];
    NSLog(@"got the user info");

}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
}

#pragma mark - RENREN get user info methods
- (void)getUserInfo
{
    ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
	requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
	
	[self.renren getUsersInfo:requestParam andDelegate:self];
    
}


/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
	NSArray *usersInfo = (NSArray *)(response.rootObject);
//	NSString *outText = [NSString stringWithFormat:@""];
//	
	for (ROUserResponseItem *item in usersInfo) {
        self.userItem = item;
//		outText = [outText stringByAppendingFormat:@"UserID:%@\n Name:%@\n Sex:%@\n Birthday:%@\n HeadURL:%@\n",item.userId,item.name,item.sex,item.brithday,item.headUrl];
	}
    NSLog(@"%@", self.userItem.name);
    [self.welcome setText:[NSString stringWithFormat:@"Welcome, %@",_userItem.name]];
    [self letLoginViewHidden:YES];
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"error_msg"]];
	UIAlertView *alertView =[[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] autorelease];
	[alertView show];
}

#pragma mark - Show Match View and MatchViewControllerDelegate

- (IBAction)showMatchView:(id)sender {
    MatchViewController *matchVC = [[[MatchViewController alloc] initWithNibName:@"MatchViewController" bundle:nil] autorelease];
    matchVC.userItem = self.userItem;
    matchVC.renren = self.renren;
    matchVC.delegate = self;
    matchVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:matchVC animated:YES];
}

- (void)matchViewControllerDidFinish:(MatchViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - login view
- (void)letLoginViewHidden:(BOOL)hidden
{
    [self.loginImage setHidden:hidden];
    [self.loginButton setHidden:hidden];
    
    BOOL reversal = (hidden == NO? YES: NO);
    
    [self.logoutButton setHidden:reversal];
    [self.matchButton setHidden:reversal];
}

@end

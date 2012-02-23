//
//  TrueViewController.m
//  party
//
//  Created by Lancy on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrueViewController.h"

@interface TrueViewController()
- (void)shareToRenren;
@end

@implementation TrueViewController

@synthesize renren = _renren;
@synthesize delegate =_delegate;
@synthesize theTrueOne = _theTrueOne;
@synthesize trueOneHead = _trueOneHead;
@synthesize trueOneNameLabel = _trueOneNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    NSString *url = [self.theTrueOne objectForKey:@"headurl"];
    NSData *fetchImageData = [[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
    UIImage *trueImage = [[[UIImage alloc]initWithData:fetchImageData] autorelease];
    [self.trueOneHead setImage:trueImage];
    [self.trueOneNameLabel setText:[NSString stringWithFormat:@"%@", [_theTrueOne objectForKey:@"name"]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTrueOneHead:nil];
    [self setTrueOneNameLabel:nil];
    [super viewDidUnload];
    [self setTheTrueOne:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - share image methods
- (void)shareToRenren
{
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    
    //get screen
    CGImageRef screen = UIGetScreenImage();
    UIImage* image = [UIImage imageWithCGImage:screen];
    
    param.imageFile = image;
    param.caption = @"nothing happened";
    [self.renren publishPhoto:param andDelegate:self];
    [param release];
}

- (IBAction)pressShareButton:(id)sender {
    [self shareToRenren];
}


#pragma mark - RENREN response

/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    if ([response.rootObject isKindOfClass:[ROPublishPhotoResponseItem class]]) {
        //        ROPublishPhotoResponseItem *result = (ROPublishPhotoResponseItem*)response.rootObject;
        NSString *title = [[NSString alloc] initWithFormat:@"Share Success"];
        NSString *description = [[NSString alloc] initWithFormat:@"Your date will see it soon!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [title release];
        [description release];
    }   
    else{
    }
	
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

#pragma mark - finish view
- (IBAction)finish:(id)sender {
    [self.delegate TrueViewControllerDidFinish:self];
}
- (void)dealloc {
    [_trueOneHead release];
    [_trueOneNameLabel release];
    [super dealloc];
}
@end

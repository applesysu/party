//
//  MatchViewController.m
//  party
//
//  Created by Lancy on 12-2-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MatchViewController.h"

@interface MatchViewController ()
- (void)getFriends;
- (void)getMatch:(NSArray *)friendsArray;
- (void)setHeadImageAndNameLabel;
- (void)shareToRenren;
- (void)letLoadingViewHidden:(BOOL)toggle;
@end

@implementation MatchViewController

@synthesize delegate = _delegate;
@synthesize renren = _renren;
@synthesize userItem = _userItem;
@synthesize maleMatchOne = _maleMatchOne;
@synthesize femaleMatchOne = _femaleMatchOne;
@synthesize nameLabel = _nameLabel;
@synthesize headPic = _headPic;
@synthesize loadingImage = _loadingImage;
@synthesize backButton = _backButton;
@synthesize shareButton = _shareButton;
@synthesize otherButton = _otherButton;

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
    [self.maleMatchOne release];
    [self.femaleMatchOne release];
    [self.userItem release];
    [_nameLabel release];
    [_headPic release];
    [_loadingImage release];
    [_backButton release];
    [_shareButton release];
    [_otherButton release];
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
    [self letLoadingViewHidden:NO];
    [self getFriends];
}

- (void)viewDidUnload
{

    [self setNameLabel:nil];
    [self setHeadPic:nil];
    [self setLoadingImage:nil];
    [self setBackButton:nil];
    [self setShareButton:nil];
    [self setOtherButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setUserItem:nil];
    [self setMaleMatchOne:nil];
    [self setFemaleMatchOne:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - back to login view
- (IBAction)pressBackButton:(id)sender {
    [self.delegate matchViewControllerDidFinish:self];
}


#pragma mark - RENREN get friends methods
- (void)getFriends
{
	ROGetFriendsInfoRequestParam *requestParam = [[[ROGetFriendsInfoRequestParam alloc] init] autorelease];
	requestParam.page = @"1";
	requestParam.count = @"500";
    requestParam.fields = @"name, sex, headurl";
	
	[self.renren getFriendsInfo:requestParam andDelegate:self];
    
}

#pragma mark - RENREN response

/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    if ([response.rootObject isKindOfClass:[ROPublishPhotoResponseItem class]]) {
//        ROPublishPhotoResponseItem *result = (ROPublishPhotoResponseItem*)response.rootObject;
    }   
    else{
        NSArray *friendsInfo = (NSArray *)(response.rootObject);
        [self getMatch:friendsInfo];
        [self letLoadingViewHidden:YES];
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

#pragma mark - get match methods
- (void)getMatch:(NSArray *)friendsArray
{
    int count = [friendsArray count];
    NSDictionary *askMale = [[friendsArray objectAtIndex:(arc4random() % count)] responseDictionary]; 
    while ([[askMale objectForKey:@"sex"] isEqualToString:@"0"])
    {
        askMale = [[friendsArray objectAtIndex:arc4random() % count] responseDictionary];
        NSLog(@"%@", askMale);
    }
    if ([[askMale objectForKey:@"sex"] isEqualToString:@"1"])
    {
        self.maleMatchOne = askMale;
    }
    
    NSDictionary *askFemale = [[friendsArray objectAtIndex:(arc4random() % count)] responseDictionary]; 
    while ([[askFemale objectForKey:@"sex"] isEqualToString:@"1"])
    {
        askFemale = [[friendsArray objectAtIndex:arc4random() % count] responseDictionary];
    }
    if ([[askFemale objectForKey:@"sex"] isEqualToString:@"0"])
    {
        self.femaleMatchOne= askFemale;
    }
    
    [self setHeadImageAndNameLabel];
}

- (void)setHeadImageAndNameLabel
{
    if (_userItem.sex == @"0")
    {
        NSString *url = [self.maleMatchOne objectForKey:@"headurl"];
        NSData *fetchImageData = [[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        UIImage *maleImage = [[[UIImage alloc]initWithData:fetchImageData] autorelease];
        [self.headPic setImage:maleImage];
        [self.nameLabel setText:[NSString stringWithFormat:@"%@", [_maleMatchOne objectForKey:@"name"]]];
    } 
    else
    {
        NSString *url = [self.femaleMatchOne objectForKey:@"headurl"];
        NSData *fetchFemaleImageData = [[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        UIImage *femaleImage = [[[UIImage alloc]initWithData:fetchFemaleImageData] autorelease];
        [self.headPic setImage:femaleImage];
        [self.nameLabel setText:[NSString stringWithFormat:@"%@", [_femaleMatchOne objectForKey:@"name"]]];
    }
}

- (void)letLoadingViewHidden:(BOOL)toggle
{
    if (toggle == YES)
    {
        [UIView animateWithDuration:1.0 
                              delay:1.0 
                            options:UIViewAnimationOptionCurveEaseInOut 
                         animations:^{
                             [self.loadingImage setAlpha:0.0];
                         }
                         completion:^(BOOL finish){
                             [self.loadingImage setHidden:toggle];
                             [self.loadingImage setAlpha:1.0];
//                             BOOL reversal = (toggle == NO? YES: NO);
                             
                             [self.backButton setEnabled:toggle];
                             [self.shareButton setEnabled:toggle];
                             [self.otherButton setEnabled:toggle];
                         }];

    } else
    {
        [self.loadingImage setHidden:toggle];
//        BOOL reversal = (toggle == NO? YES: NO);
        
        [self.backButton setEnabled:toggle];
        [self.shareButton setEnabled:toggle];
        [self.otherButton setEnabled:toggle];
    }
    

    
    
}


#pragma mark - share image methods
- (void)shareToRenren
{
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.imageFile = _headPic.image;
    param.caption = @"nothing happened";
    [self.renren publishPhoto:param andDelegate:self];
    [param release];
}

- (IBAction)pressShareButton:(id)sender {
    [self shareToRenren];
}


#pragma mark - TureViewController Delegate and Methods

- (void)TrueViewControllerDidFinish:(id)controller 
{
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)pressTureButton:(id)sender {
    TrueViewController *controller = [[[TrueViewController alloc]initWithNibName:@"TrueViewController" bundle:nil]autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    if (_userItem.sex == @"1")
    {
        controller.theTrueOne = _femaleMatchOne;
    }
    else
    {
        controller.theTrueOne = _maleMatchOne;
    }
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - UIImage Functions
//Combine two UIImages
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {  
    UIGraphicsBeginImageContext(image1.size);  
    
    // Draw image1  
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];  
    
    // Draw image2  
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];  
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    
    UIGraphicsEndImageContext();  
    
    return resultingImage;  
}  

//Create a UIImage from a part of another UIImage
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {  
    CGImageRef sourceImageRef = [image CGImage];  
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);  
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];  
    CGImageRelease(newImageRef);  
    return newImage;  
}  


//Save UIImage to Photo Album

//just one line
//UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), context); 

//And to know if the save was successful
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
    NSString *message;  
    NSString *title;  
    if (!error) {  
        title = NSLocalizedString(@"SaveSuccessTitle", @"");  
        message = NSLocalizedString(@"SaveSuccessMessage", @"");  
    } else {  
        title = NSLocalizedString(@"SaveFailedTitle", @"");  
        message = [error description];  
    }  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message  
                                                   delegate:nil  
                                          cancelButtonTitle:NSLocalizedString(@"ButtonOK", @"")  
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release];  
}  

@end

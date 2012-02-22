//
//  TrueViewController.m
//  party
//
//  Created by Lancy on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrueViewController.h"

@implementation TrueViewController

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

- (IBAction)finish:(id)sender {
    [self.delegate TrueViewControllerDidFinish:self];
}
- (void)dealloc {
    [_trueOneHead release];
    [_trueOneNameLabel release];
    [super dealloc];
}
@end

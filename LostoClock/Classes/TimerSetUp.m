//
//  TimerSetUp.m
//  LostoClock
//
//  Created by BUDDAx2 on 26.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimerSetUp.h"
#import "LostoClockViewController.h"
#import "TimerClockView.h"


@implementation TimerSetUp

- (IBAction)backToMain{
	LostoClockViewController * viewController = [[LostoClockViewController alloc] initWithNibName:nil bundle:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	[self presentModalViewController:viewController animated:NO];	
}

- (IBAction)goToTimer{
	TimerClockView * TimerViewController = [[TimerClockView alloc] initWithNibName:nil bundle:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	[self presentModalViewController:TimerViewController animated:NO];	
}

- (IBAction)getDate{
	
	NSDateFormatter *hTimeFormat = [[NSDateFormatter alloc] init];
	[hTimeFormat setDateFormat:@"HH"];
	NSString *date2 = [hTimeFormat stringFromDate:dp.date];
	[hTimeFormat setDateFormat:@"mm"];
	NSString *date1 = [hTimeFormat stringFromDate:dp.date];
	
	
	timerHour = [date2 integerValue];
	timerMinute = [date1 integerValue];
	if (timerHour==0) {
		timerSecond = timerMinute * 60;
	}
	else {
		timerSecond = (timerHour * 60 + timerMinute) * 60;
	}	
	
	[hTimeFormat release];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];	
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
	
	for (UIView * subview in dp.subviews) {
        subview.frame = dp.bounds;
    }	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

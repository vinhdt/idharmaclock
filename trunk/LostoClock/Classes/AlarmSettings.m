//
//  AlarmSettings.m
//  LostoClock
//
//  Created by BUDDAx2 on 22.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmSettings.h"
#import "LostoClockViewController.h"

BOOL isAlarm;
int alarmHour;
int alarmMinute;

@implementation AlarmSettings

- (IBAction)backToMain{
	LostoClockViewController * viewController = [[LostoClockViewController alloc] initWithNibName:nil bundle:nil];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	[self presentModalViewController:viewController animated:NO];
}

- (IBAction)setAlarmSwitch{
	if (setAlarm.on) {
		isAlarm = YES;
	}
	else {
		isAlarm = NO;
	}
//	UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Alert's title" message:@"This is an alert's message." delegate:self cancelButtonTitle:@"and the" otherButtonTitles:@"buttons",nil];
//	[simpleAlert show];
//	[simpleAlert release];	
}

- (IBAction)getDate{
	
	NSDateFormatter *hTimeFormat = [[NSDateFormatter alloc] init];
	[hTimeFormat setDateFormat:@"HH"];
	NSString *date2 = [hTimeFormat stringFromDate:dp.date];
	[hTimeFormat setDateFormat:@"mm"];
	NSString *date1 = [hTimeFormat stringFromDate:dp.date];
		
	
	alarmHour = [date2 integerValue];
	alarmMinute = [date1 integerValue];
	
//	UIAlertView *simpleAlert = [[UIAlertView alloc] initWithTitle:@"Alert's title" message:alarmHour delegate:self cancelButtonTitle:@"and the" otherButtonTitles:@"buttons",nil];
//	[simpleAlert show];
//	[simpleAlert release];

//	time.text = [NSString stringWithFormat:@"Будильник установлен на %d:%d",alarmHour,alarmMinute]; 
	
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
	if (isAlarm) {
		setAlarm.on = YES;
	}
	for (UIView * subview in dp.subviews) {
        subview.frame = dp.bounds;
    }
	
	if (isAlarm) {
		NSString *alarmStringTime = [NSString stringWithFormat:@"%d:%d",alarmHour, alarmMinute];
		
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"HH:mm"];
		
		NSDate *formatterDate = [inputFormatter dateFromString:alarmStringTime];
		
		dp.date = formatterDate;
		[inputFormatter release];
	}
	if (!alarmHour || !alarmMinute || !isAlarm) {
//		NSString *alarmStringTime = [NSString stringWithFormat:@"%d:%d",0, 0];
		
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"HH:mm"];
		NSDate *now = [[NSDate alloc] init];
		NSString *alarmStringTime = [inputFormatter stringFromDate:now];
		[now release];
		
		NSDate *formatterDate = [inputFormatter dateFromString:alarmStringTime];
		
		dp.date = formatterDate;
		[inputFormatter release];
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

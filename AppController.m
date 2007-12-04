//
//  AppController.m
//  TimeConverter
//
//  Created by wolf on 11/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "TimeConverterWindowController.h"

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[TimeConverterWindowController alloc] init];
}

- (IBAction)newDocument:(id)sender {
	[[TimeConverterWindowController alloc] init];
}

@end
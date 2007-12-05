//
//  TimeConverterWindowController.h
//  TimeConverter
//
//  Created by Victoria Wang on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TimeConverterWindowController : NSWindowController {
	NSDate		*theirTime;
	NSTimeZone	*theirTimeZoneObj;
	NSTextField	*eventTitle;
}

- (NSString*)theirTimeZoneString;
- (void)setTheirTimeZoneString:(NSString*)tz_;

- (NSCalendarDate*)myTime;

- (NSArray*)knownAbbreviations;
- (NSArray*)knownNames;
- (NSArray*)timeZones;
- (NSDictionary*)cityDictionary;

- (IBAction)addToIcal:(id)sender;

@end

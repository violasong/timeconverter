//
//  AppController.h
//  TimeConverter
//
//  Created by wolf on 11/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	NSDate		*theirTime;
	NSTimeZone	*theirTimeZoneObj;
}

- (NSString*)theirTimeZoneString;
- (void)setTheirTimeZoneString:(NSString*)tz_;

- (NSCalendarDate*)myTime;

- (NSArray*)knownAbbreviations;
- (NSArray*)knownNames;
- (NSArray*)timeZones;
- (NSDictionary*)cityDictionary;

@end

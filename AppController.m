//
//  AppController.m
//  TimeConverter
//
//  Created by wolf on 11/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

@implementation AppController

+ (void)initialize {
    [self setKeys:[NSArray arrayWithObjects:@"theirTime",@"theirTimeZoneString",nil] triggerChangeNotificationsForDependentKey:@"myTime"];
}

- (id)init {
	self = [super init];
	if (self) {
		theirTime = [[NSDate alloc] init];
		theirTimeZoneObj = [NSTimeZone localTimeZone];
	}
	return self;
}

- (NSString*)theirTimeZoneString {
	return [theirTimeZoneObj abbreviation]; // default drop down
}

-(void)setTheirTimeZoneString:(NSString*)tz_ {
	if ([[self knownAbbreviations] containsObject:[tz_ uppercaseString]]) {
		theirTimeZoneObj = [NSTimeZone timeZoneWithAbbreviation:[tz_ uppercaseString]];
	}
	if ([[self knownNames] containsObject:tz_]) {
		theirTimeZoneObj = [NSTimeZone timeZoneWithName:tz_];
	}
}

- (NSCalendarDate*)myTime {
	NSCalendarDate *theirTimeCalDate = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate:[theirTime timeIntervalSinceReferenceDate]];
	NSCalendarDate *result = [NSCalendarDate dateWithYear:[theirTimeCalDate yearOfCommonEra]
													month:[theirTimeCalDate monthOfYear]
													  day:[theirTimeCalDate dayOfMonth]
													 hour:[theirTimeCalDate hourOfDay]
												   minute:[theirTimeCalDate minuteOfHour]
												   second:[theirTimeCalDate secondOfMinute]
												 timeZone:theirTimeZoneObj];
	[result setTimeZone:[NSTimeZone localTimeZone]];
	return result;
}

- (NSArray*)knownAbbreviations {
	return [[[NSTimeZone abbreviationDictionary] allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray*)knownNames {
	return [[NSTimeZone knownTimeZoneNames] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray*)timeZones {
	return [[self knownAbbreviations] arrayByAddingObjectsFromArray:[self knownNames]];
}

@end

//
//  AppController.m
//  TimeConverter
//
//  Created by wolf on 11/30/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import <CalendarStore/CalendarStore.h>

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

- (void)setTheirTimeZoneString:(NSString*)tz_ {
	if ([[self knownAbbreviations] containsObject:[tz_ uppercaseString]]) {
		theirTimeZoneObj = [NSTimeZone timeZoneWithAbbreviation:[tz_ uppercaseString]];
	}
	if ([[self knownNames] containsObject:[tz_ capitalizedString]]) {
		theirTimeZoneObj = [NSTimeZone timeZoneWithName:[[self cityDictionary] objectForKey:[tz_ capitalizedString]]];
	}
}

- (NSCalendarDate*)theirTime {
	NSCalendarDate *theirTimeCalDate = [NSCalendarDate dateWithTimeIntervalSinceReferenceDate:[theirTime timeIntervalSinceReferenceDate]];
	NSCalendarDate *result = [NSCalendarDate dateWithYear:[theirTimeCalDate yearOfCommonEra]
													month:[theirTimeCalDate monthOfYear]
													  day:[theirTimeCalDate dayOfMonth]
													 hour:[theirTimeCalDate hourOfDay]
												   minute:[theirTimeCalDate minuteOfHour]
												   second:[theirTimeCalDate secondOfMinute]
												 timeZone:theirTimeZoneObj];
	return result;
}

- (NSCalendarDate*)myTime {
	NSCalendarDate *result = [self theirTime];
	[result setTimeZone:[NSTimeZone localTimeZone]];
	return result;
}

- (NSArray*)knownAbbreviations {
	return [[NSTimeZone abbreviationDictionary] allKeys];
}

- (NSArray*)knownNames {
	return [[self cityDictionary] allKeys];
}

- (NSArray*)timeZones {
	return [[[self knownAbbreviations] arrayByAddingObjectsFromArray:[self knownNames]] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSDictionary*)cityDictionary {
	int i;
	int namesCount = [[NSTimeZone knownTimeZoneNames] count];
	NSMutableArray *cities = [NSMutableArray arrayWithCapacity:namesCount];
	for (i=0; i<namesCount; i++) {
		[cities addObject:[[[[NSTimeZone knownTimeZoneNames] objectAtIndex:i] lastPathComponent] stringByReplacingOccurrencesOfString:@"_"
																														   withString:@" "]];
	}
	return [NSDictionary dictionaryWithObjects:[NSTimeZone knownTimeZoneNames]
												 forKeys:cities];
}

- (IBAction)addToIcal:(id)sender
{
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	CalCalendar *targetCalendar = nil;
	
	for (CalCalendar *calendar in [store calendars]) {
		if ([calendar.title isEqualToString:@"Work"]) {
			targetCalendar = calendar;
		}
	}
	if (!targetCalendar) {
		targetCalendar = [[store calendars] objectAtIndex:0];
	}
	
	CalEvent *event = [CalEvent event];
	event.calendar = targetCalendar;
	event.title = @"TimeConverter!!";
	event.startDate = [self theirTime];
	event.endDate = [[self theirTime] dateByAddingYears:0
											  months:0
												days:0
											   hours:1
											 minutes:0
											 seconds:0];
	NSError *error = nil;
	[store saveEvent:event span:CalSpanThisEvent error:&error];	
	
	if (error) {
		[NSApp presentError:error];
	}
}


@end

//
//  TimeConverterWindowController.m
//  TimeConverter
//
//  Created by Victoria Wang on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TimeConverterWindowController.h"
#import <CalendarStore/CalendarStore.h>

@implementation TimeConverterWindowController

+ (void)initialize {
    [self setKeys:[NSArray arrayWithObjects:@"theirTime",@"theirTimeZoneString",nil] triggerChangeNotificationsForDependentKey:@"myTime"];
}

- (id)init {
	self = [super initWithWindowNibName:@"TimeConverterWindow"];
	if (self) {
		NSCalendarDate *theirTimeCalDate = [NSCalendarDate calendarDate];
		theirTime = [[NSDate alloc] initWithString:[[NSCalendarDate dateWithYear:[theirTimeCalDate yearOfCommonEra]
																		   month:[theirTimeCalDate monthOfYear]
																			 day:[theirTimeCalDate dayOfMonth]
																			hour:[theirTimeCalDate hourOfDay]
																		  minute:0
																		  second:0
																		timeZone:theirTimeZoneObj] description]];
		theirTimeZoneObj = [NSTimeZone localTimeZone];
		[[self window] makeKeyAndOrderFront:nil];
	}
	return self;
}

- (NSString*)theirTimeZoneString {
	return [theirTimeZoneObj abbreviation];
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
	
	NSString *title = [eventTitle stringValue];
	if ([title length] > 0) {
		event.title = title;
	}
	else {
		event.title = @"New Event";
	}
	
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
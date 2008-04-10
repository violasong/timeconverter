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

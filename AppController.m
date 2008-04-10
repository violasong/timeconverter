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
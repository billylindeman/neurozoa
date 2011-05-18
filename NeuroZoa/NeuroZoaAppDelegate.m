//
//  NeuroZoaAppDelegate.m
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NeuroZoaAppDelegate.h"
#import "MutableNeuralNet.h"
#import "NNTrainer.h"


@implementation NeuroZoaAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
	
	nn = [[MutableNeuralNet alloc] initWithInputs:2 hidden:3 outputs:1];
	
	[nn writeToFile:@"/tmp/netstart.plist"];
	
	//xor
	NSString *xor_file = [[NSBundle mainBundle] pathForResource:@"xor_train" ofType:@"plist"];
	NSArray *trainingSet = [[NSArray alloc] initWithContentsOfFile:xor_file];
	
	NNTrainer *trainer = [[NNTrainer alloc] initWithNetwork:nn];
	
	[trainer setMaxEpochs:500];
	[trainer setDesiredAccuracy:99.999];
	
	[trainer trainNetwork:trainingSet];

	
	NSArray *xor = [NSArray arrayWithObjects:[NSNumber numberWithInt:1.0],[NSNumber numberWithInt:1.0],nil];
	[nn feedForward:xor];
	NSLog(@"xor(1,1) =");
	[nn dumpOutput];
	
	xor = [NSArray arrayWithObjects:[NSNumber numberWithInt:1.0],[NSNumber numberWithInt:-1.0],nil];
	[nn feedForward:xor];
	NSLog(@"xor(1,-1) =");
	[nn dumpOutput];
	
	xor = [NSArray arrayWithObjects:[NSNumber numberWithInt:-1.0],[NSNumber numberWithInt:1.0],nil];
	[nn feedForward:xor];
	NSLog(@"xor(-1,1) =");
	[nn dumpOutput];
	
	xor = [NSArray arrayWithObjects:[NSNumber numberWithInt:-1.0],[NSNumber numberWithInt:-1.0],nil];
	[nn feedForward:xor];
	NSLog(@"xor(-1,-1) =");
	[nn dumpOutput];

	[nn writeToFile:@"/tmp/netend.plist"];
	
}

@end

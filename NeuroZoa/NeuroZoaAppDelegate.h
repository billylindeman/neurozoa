//
//  NeuroZoaAppDelegate.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MutableNeuralNet;

@interface NeuroZoaAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;

	MutableNeuralNet *nn;
}

@property (assign) IBOutlet NSWindow *window;

@end

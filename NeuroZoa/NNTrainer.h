//
//  NNTrainer.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/17/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MutableNeuralNet;

@interface NNTrainer : NSObject {
	MutableNeuralNet *m_nerualNet;
		
	double generalizationSetAccuracy;
	double generalizationSetMSE;
	
	double desiredAccuracy;
	
	int epoch, maxEpochs;
	

}
@property (nonatomic, retain) MutableNeuralNet *m_nerualNet;

@property (nonatomic, assign) double desiredAccuracy;
@property (nonatomic, assign) int maxEpochs;

@end

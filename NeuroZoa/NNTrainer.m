//
//  NNTrainer.m
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/17/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import "NNTrainer.h"
#import "MutableNeuralNet.h"

@implementation NNTrainer

@synthesize m_nerualNet;
@synthesize desiredAccuracy, maxEpochs;

-(id)initWithNetwork:(MutableNeuralNet*)nn {

	if((self = [super init])) {
		//custom init
		m_nerualNet = [nn retain];
		
		
	
		return self;
	}
	return nil;
}

-(void)trainNetwork:(NSArray*)trainingSet {

	epoch = 0;
	
	while (	(generalizationSetAccuracy < desiredAccuracy ) && epoch < maxEpochs )				
	{					
		[m_nerualNet epochWithData:trainingSet];
		
		generalizationSetAccuracy = [m_nerualNet getAccuracyForSet:trainingSet];
		generalizationSetMSE = [m_nerualNet getMSEForSet:trainingSet];
		
		NSLog(@"[NNTrainer] [Epoch %i] %f, %f", epoch, generalizationSetAccuracy, generalizationSetMSE);
		
		//once training set is complete increment epoch
		epoch++;

	}
	

	
}

-(void)dealloc {
	[m_nerualNet release];
	
}

@end

//
//  MutableNeuralNet.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/18/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuralNet.h"

@interface MutableNeuralNet : NeuralNet {
	double** m_ihDelta;
	double** m_hoDelta;
	
	double*  m_hError;
	double*  m_oError;
	
	double m_learningRate;
	
}


-(id)initWithInputs:(int)nInput hidden:(int)nHidden outputs:(int)nOutput;
-(void)randomizeWeights;
-(void)epochWithData:(NSArray*)trainingData;

-(double)getOutputErrorForTarget:(double)desiredValue withOutput:(double) outputValue;
-(double)getHiddenErrorGradient:(int) j;
-(double)getAccuracyForSet:(NSArray*)set;
-(double)getMSEForSet:(NSArray*)set;


-(void)backpropogate:(NSArray*)target;
-(void)applyWeightDeltas;

@end

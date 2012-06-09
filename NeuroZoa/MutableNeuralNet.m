//
//  MutableNeuralNet.m
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/18/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import "MutableNeuralNet.h"
#import "time.h"

#define kLearningRate .1

@implementation MutableNeuralNet

int clampOutput( double x )
{
	if ( x < 0.1 ) return 0;
	else if ( x > 0.9 ) return 1;
	else return -1;
}

-(id)initWithInputs:(int)nInput hidden:(int)nHidden outputs:(int)nOutput {
	if((self=[super init])) {
		m_nInput = nInput+1; m_nHidden = nHidden+1; m_nOutput = nOutput;
		
		m_learningRate = kLearningRate;
		
		//initialize neuron arrays
		m_inputNeurons = malloc(sizeof(double)*(m_nInput));	
		m_hiddenNeurons = malloc(sizeof(double)*(m_nHidden));
		m_outputNeurons = malloc(sizeof(double)*m_nOutput);
		
		//set bias
		m_inputNeurons[nInput] = 1;
		m_hiddenNeurons[nHidden] = 1;
		
		//hold error gradients
		m_hError = malloc(sizeof(double)*(m_nHidden));
		m_oError = malloc(sizeof(double)*(m_nOutput));
		
		
		//initialize weight arrays (and deltas)
		m_ihWeights = malloc(sizeof(double*)*m_nInput);
		m_ihDelta = malloc(sizeof(double*)*m_nInput);
		
		for(int i=0; i<m_nInput; i++) {
			m_ihWeights[i] = malloc(sizeof(double)*(m_nHidden-1));
			m_ihDelta[i] = malloc(sizeof(double)*(m_nHidden-1));
		}
		
        //initialize weight arrays (and deltas)
		m_hoWeights = malloc(sizeof(double*)*m_nHidden);
		m_hoDelta = malloc(sizeof(double*)*m_nHidden);
		for(int i=0; i<m_nHidden; i++) {
			m_hoWeights[i] = malloc(sizeof(double)*m_nOutput);
			m_hoDelta[i] = malloc(sizeof(double)*m_nOutput);
		}
		
		
		[self randomizeWeights];
		
	}	
	
	
	return self;
}

-(void)randomizeWeights {
    srand ( time(NULL) );

	double rangeHidden = 1/sqrt( (double) m_nInput);
	for(int i = 0; i < m_nInput; i++){
		for(int j = 0; j < (m_nHidden-1); j++){
			m_ihWeights[i][j] = (((double)(rand()%100)+1)/100*2*rangeHidden)-rangeHidden;			
		}
	}
	
	double rangeOutput = 1/sqrt( (double) m_nHidden);
	for(int i = 0; i < m_nHidden; i++){
		for(int j = 0; j < m_nOutput; j++){
			m_hoWeights[i][j] = (((double)(rand()%100)+1)/100*2*rangeOutput)-rangeOutput;			
		}
	}
	
}

-(void)epochWithData:(NSArray*)trainingData {
	//loop through each pattern/target pair in the training set
	for(NSDictionary *set in trainingData) {
		//load
		NSArray *pattern = [set objectForKey:@"pattern"];
		NSArray *target = [set objectForKey:@"target"];
		
		[self feedForward:pattern];
		[self backpropogate:target];
		
	}
	
}

-(double)getOutputErrorForTarget:(double)desiredValue withOutput:(double) outputValue {
	//return error gradient
	return outputValue * ( 1 - outputValue ) * ( desiredValue - outputValue );
}

-(double)getHiddenErrorGradient:(int) j {
	//get sum of hidden->output weights * output error gradients
	double weightedSum = 0;
	for( int k = 0; k < m_nOutput; k++ ) weightedSum += m_hoWeights[j][k] * m_oError[k];
	
	//return error gradient
	return m_hiddenNeurons[j] * ( 1 - m_hiddenNeurons[j] ) * weightedSum;
}


-(double)getAccuracyForSet:(NSArray*)set {
	double incorrectResults = 0;
	for (NSDictionary *entry in set)
	{						
		NSArray *pattern = [entry objectForKey:@"pattern"];
		NSArray *target = [entry objectForKey:@"target"];
		
		[self feedForward:pattern];
		bool correctResult = true;
		
		for ( int k = 0; k < m_nOutput; k++ ) {					
			if ( clampOutput(m_outputNeurons[k]) != [[target objectAtIndex:k] doubleValue] ) correctResult = false;
		}
		if ( !correctResult ) incorrectResults++;	
		
	}
	//calculate error and return as percentage
	return 100 - (incorrectResults/([set count]) * 100);
}


-(double)getMSEForSet:(NSArray*)set {
	double mse = 0;
	
	for (NSDictionary *entry in set){
		
		NSArray *pattern = [entry objectForKey:@"pattern"];
		NSArray *target = [entry objectForKey:@"target"];
		
		[self feedForward:pattern];
		
		for ( int k = 0; k < m_nOutput; k++ ) {					
			mse += pow((m_outputNeurons[k] - [[target objectAtIndex:k] doubleValue]), 2);
		}		
		
	}
	
	return mse/(m_nOutput * [set count]);
}

-(void)backpropogate:(NSArray*)target {
	for (int k = 0; k < m_nOutput; k++) {
		m_oError[k] = [self getOutputErrorForTarget:[[target objectAtIndex:k] doubleValue]  withOutput:m_outputNeurons[k] ];

		for (int j = 0; j < m_nHidden; j++) {				
			m_hoDelta[j][k] += m_learningRate * m_hiddenNeurons[j] * m_oError[k];
		}
		
	}
	for (int j = 0; j < m_nHidden; j++) {
		m_hError[j] = [self getHiddenErrorGradient:j];
		
		for (int i = 0; i < m_nInput; i++) {
			m_ihDelta[i][j] += m_learningRate * m_inputNeurons[i] * m_hError[j]; 
			
		}
	}
	
	[self applyWeightDeltas];	
}

-(void)applyWeightDeltas {
	for (int i = 0; i < m_nInput; i++) {
		for (int j = 0; j < m_nHidden; j++) {
			m_ihWeights[i][j] += m_ihDelta[i][j];			
		}
	}
	for (int i = 0; i < m_nHidden; i++) {
		for (int j = 0; j < m_nOutput; j++) {
			m_hoWeights[i][j] += m_hoDelta[i][j];			
		}
	}
}

-(void)dealloc {
	//free error gradients
	free(m_hError);
	free(m_oError);
	
	//free weight-delta matrix
	for(int i=0; i<m_nInput; i++) {
		free(m_ihDelta[i]);
	}
	free(m_ihDelta);
	for(int i=0; i<m_nHidden; i++) {
		free(m_hoDelta[i]);
	}
	free(m_hoDelta);
	
    [super dealloc];
}

@end

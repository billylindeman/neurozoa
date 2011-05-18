//
//  NeuralNet.m
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/17/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import "NeuralNet.h"
#import <math.h>

@implementation NeuralNet

double activationFunction(double x)
{
	return 1/(1+exp(-x));
}

-(id)initFromDict:(NSDictionary*)dict {
	if((self = [super init])) {
		
		//grab arrays
		NSArray *inputNeurons = [dict objectForKey:@"m_inputNeurons"];
		NSArray *hiddenNeurons  = [dict objectForKey:@"m_hiddenNeurons"];
		NSArray *outputNeurons = [dict objectForKey:@"m_outputNeurons"];
		NSArray *inputHiddenWeights = [dict objectForKey:@"m_ihWeights"];
		NSArray *hiddenOuputWeights = [dict objectForKey:@"m_hoWeights"];
		
		m_nInput = [inputNeurons count];
		m_nHidden = [hiddenNeurons count];
		m_nOutput = [outputNeurons count];
		
		//allocate c-arrays
		m_inputNeurons = malloc(sizeof(double)*m_nInput);
		m_hiddenNeurons = malloc(sizeof(double)*m_nHidden);
		m_outputNeurons = malloc(sizeof(double)*m_nOutput);
		
		//load input neurons into array
		for(int i=0; i<m_nInput; i++) {
			m_inputNeurons[i] = [[inputNeurons objectAtIndex:i] doubleValue];		
		}
		//load hidden neurons into array
		for(int i=0; i<m_nHidden; i++) {
			m_hiddenNeurons[i] = [[hiddenNeurons objectAtIndex:i] doubleValue];		
		}
		//load output neurons into array
		for(int i=0; i<m_nOutput; i++) {
			m_outputNeurons[i] = [[outputNeurons objectAtIndex:i] doubleValue];		
		}
		
		//allocate weight array (2d)
		m_ihWeights = malloc(sizeof(double*)*m_nInput);
		//loop thorugh and initilaize 2d array and set values
		for(int i=0; i<m_nInput; i++) {
			//create 2nd array
			m_ihWeights[i] = malloc(sizeof(double)*m_nHidden);
			for(int j=0; j<m_nHidden; j++){ 
				m_ihWeights[i][j] = [[[inputHiddenWeights objectAtIndex:i] objectAtIndex:j] doubleValue];
			}	
		}
		
		//allocate weight array (2d)
		m_hoWeights = malloc(sizeof(double*)*m_nHidden);
		//loop thorugh and initilaize 2d array and set values
		for(int i=0; i<m_nHidden; i++) {
			//create 2nd array
			m_hoWeights[i] = malloc(sizeof(double)*m_nOutput);
			for(int j=0; j<m_nOutput; j++){ 
				m_hoWeights[i][j] = [[[hiddenOuputWeights objectAtIndex:i] objectAtIndex:j] doubleValue];
			}	
		}
		
	}
	
	return self;
}


-(id)initFromFile:(NSString*)filePath {
	//initialize from file
	NSDictionary *dict = [[NSDictionary alloc] initFromFile:filePath];
	if((self = [self initFromDict:dict])){
		//release dict
		[dict release], dict=nil;
		return self;

	}
	
	return nil;
}

-(void)writeToFile:(NSString*)filePath {
	
	//create top level object
	NSMutableDictionary *file = [[NSMutableDictionary alloc] init];
	
	//save input neuron values
	NSMutableArray *inputNeurons = [[NSMutableArray alloc] init];
	for(int i=0; i<m_nInput; i++) {
		[inputNeurons addObject:[NSNumber numberWithDouble:m_inputNeurons[i]]];
	}
	//add to file
	[file setObject:inputNeurons forKey:@"m_inputNeurons"];
	
	
	//save hidden neuron values
	NSMutableArray *hiddenNeurons = [[NSMutableArray alloc] init];
	for(int i=0; i<m_nHidden; i++) {
		[hiddenNeurons addObject:[NSNumber numberWithDouble:m_hiddenNeurons[i]]];
	}
	//add to file
	[file setObject:hiddenNeurons forKey:@"m_hiddenNeurons"];

	//save hidden neuron values
	NSMutableArray *outputNeurons = [[NSMutableArray alloc] init];
	for(int i=0; i<m_nOutput; i++) {
		[hiddenNeurons addObject:[NSNumber numberWithDouble:m_outputNeurons[i]]];
	}
	//add to file
	[file setObject:outputNeurons forKey:@"m_outputNeurons"];
	
	//save out input-hidden weight matrix
	NSMutableArray *inputHiddenWeights = [[NSMutableArray alloc] init];
	for(int i=0; i<m_nInput; i++) {
		
		//add weight as nsnumber
		NSMutableArray *hidden = [[NSMutableArray alloc] init];
		for(int j=0; j<m_nHidden; j++) {
			[hidden addObject:[NSNumber numberWithDouble:m_ihWeights[i][j]]];
		}
		[inputHiddenWeights addObject:hidden];
	}
	[file setObject:inputHiddenWeights forKey:@"m_ihWeights"];
	
	
	//save out hidden-output weight matrix
	NSMutableArray *hiddenOutputWeights = [[NSMutableArray alloc] init];
	for(int i=0; i<m_nInput; i++) {
		
		//add weight as nsnumber
		NSMutableArray *output = [[NSMutableArray alloc] init];
		for(int j=0; j<m_nHidden; j++) {
			[output addObject:[NSNumber numberWithDouble:m_hoWeights[i][j]]];
		}
		[hiddenOutputWeights addObject:output];
	}
	[file setObject:hiddenOutputWeights forKey:@"m_hoWeights"];
	
	//write file
	[file writeToFile:filePath atomically:NO];
}

-(void)feedForward:(NSArray*)inputPattern {
	
	//the inputpattern should match the number of inputs
	if([inputPattern count] != (m_nInput-1)) {
		NSLog(@"[NeuralNet] Error: inputPattern mismatch");
	}
	
	//load in the values for the inputPattern
	for(int i = 0; i < (m_nInput-1); i++) m_inputNeurons[i] = [[inputPattern objectAtIndex:i] doubleValue];

	//feed to the hidden layer
	for(int j=0; j < (m_nHidden-1); j++) {
		//clear hidden neuron value
		m_hiddenNeurons[j] = 0;				
		
		//get weighted sum of pattern and bias neuron
		for( int i=0; i < m_nInput; i++ ) m_hiddenNeurons[j] += m_inputNeurons[i] * m_ihWeights[i][j];
		
		//set to result of sigmoid
		m_hiddenNeurons[j] = activationFunction( m_hiddenNeurons[j] );			
	}

	//feed to the output layer
	for(int k=0; k < m_nOutput; k++)
	{
		//clear value
		m_outputNeurons[k] = 0;				
		
		//get weighted sum of pattern and bias neuron
		for( int j=0; j < m_nHidden; j++ ) m_outputNeurons[k] += m_hiddenNeurons[j] * m_hoWeights[j][k];
		
		//set to result of sigmoid
		m_outputNeurons[k] = activationFunction( m_outputNeurons[k] );
	
	}
	
}
-(void)dumpOutput {
	for(int k =0; k<m_nOutput; k++) {
		NSLog(@"out[%i]: %f", k, m_outputNeurons[k]);	
	}	
}
-(void)dealloc {
	//free neurons
	free(m_inputNeurons);
	free(m_hiddenNeurons);
	free(m_outputNeurons);
	
	
	//free weight arrays
	for(int i=0; i< m_nInput; i++) {
		free(m_ihWeights[i]);
	}
	free(m_ihWeights);
	for(int i=0; i< m_nHidden; i++) {
		free(m_hoWeights[i]);
	}
	free(m_hoWeights);
	
}

@end

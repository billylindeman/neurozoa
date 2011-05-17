//
//  NeuralNet.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/17/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NeuralNet : NSObject {
	double m_nInput;
	double m_nHidden;
	double m_nOutput;
	
	double *m_inputNeurons;
	double *m_hiddenNeurons;
	double *m_outputNeurons;
	
	double **m_ihWeights;
	double **m_hoWeights;
}

-(id)initFromFile:(NSString*)filePath;
-(void)writeToFile:(NSString*)filePath;
-(id)initWithInputs:(int)nInput hidden:(int)nHidden outputs:(int)nOutput;
-(void)randomizeWeights;


-(void)feedForward:(NSArray*)inputPattern;
	
@end

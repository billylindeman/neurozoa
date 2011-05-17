//
//  ZoaNeuralNet.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/2/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//


#include <vector>


namespace Zoa {
    
    class NeuralNet {
        double *m_inputNeurons;
        double *m_hiddenNeurons;
        double *m_outputNeurons;
        
        double **m_ihWeights;
        double **m_hoWeights;
        
        int numInput,numHidden,numOutput;
        
        
        NeuralNet(std::string& networkFile);
        NeuralNet(int input, int hidden, int output);
        
        void randomizeWeights();
        double activationFunction(double a);
        void feedForward(double *inputSet);
        
        ~NeuralNet();
    };

    
}
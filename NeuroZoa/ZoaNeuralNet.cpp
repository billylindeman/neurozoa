//
//  ZoaNeuralNet.cpp
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/2/11.
//  Copyright 2011 Protozoa, LLC. All rights reserved.
//

#include "ZoaNeuralNet.h"
#include <math.h>
#include <iostream>

namespace Zoa {
    
    
    
    NeuralNet::NeuralNet(std::string& networkFile){
        std::cout << "[NeuralNet] TODO: load network from file" << std::endl;
        
    }

    //new network constructor
    NeuralNet::NeuralNet(int input, int hidden, int output)
    {
        //set net sizes
        numInput = input; numHidden = hidden; numOutput = output;
        
        //initialize neurons
        m_inputNeurons = new double[numInput + 1];
        for ( int i=0; i < numInput; i++ ) m_inputNeurons[i] = 0;

        m_hiddenNeurons = new double[numHidden + 1];
        for ( int i=0; i < numHidden; i++ ) m_hiddenNeurons[i] = 0;

        m_outputNeurons = new double[numOutput + 1];
        for ( int i=0; i < numOutput; i++ ) m_outputNeurons[i] = 0;

        
        //initialize weights
        m_ihWeights = new double*[numInput + 1];
        for (int i=0; i <= numInput; i++) {
            m_ihWeights[i] = new double[numHidden];
            for (int j=0; j < numHidden; j++) m_ihWeights[i][j] = 0;
        }
        
        m_hoWeights = new double*[numHidden + 1];
        for (int i=0; i <= numHidden; i++) {
            m_hoWeights[i] = new double[numOutput];
            for (int j=0; j < numOutput; j++) m_hoWeights[i][j] = 0;
        }
        
        randomizeWeights();
    }
    
    void NeuralNet::randomizeWeights() {
        double rangeHidden = 1/sqrt( (double) numInput);
        for(int i = 0; i <= numInput; i++){
            for(int j = 0; j < numHidden; j++){
                m_ihWeights[i][j] = (((double)(rand()%100)+1)/100*2*rangeHidden)-rangeHidden;			
            }
        }
        
        double rangeOutput = 1/sqrt( (double) numHidden);
        for(int i = 0; i <= numHidden; i++){
            for(int j = 0; j < numOutput; j++){
                m_hoWeights[i][j] = (((double)(rand()%100)+1)/100*2*rangeOutput)-rangeOutput;			
            }
        }
        
    }
    
    double NeuralNet::activationFunction(double a) {
        return 1/(1+exp(-a));
    }
    
    void NeuralNet::feedForward(double *inputSet) {
        for(int i=0; i<numInput; i++) m_inputNeurons[i] = inputSet[i];
        
        
    }
    
    
    //destructor
    NeuralNet::~NeuralNet() {
        //remove neurons
        delete [] m_inputNeurons;
        delete [] m_hiddenNeurons;
        delete [] m_outputNeurons;
        
        for (int i=0; i <= numInput; i++) delete[] m_ihWeights[i];
        delete[] m_ihWeights;
        
        for (int i=0; i <= numHidden; i++) delete[] m_hoWeights[i];
        delete[] m_hoWeights;
    
    }

}
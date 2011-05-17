//
//  ZoaNeuron.h
//  NeuroZoa
//
//  Created by Billy Lindeman on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <vector>

namespace Zoa {
    
    class Neuron {
        float output;
        
        std::vector<Neuron*> m_inputs;
        
        
        
    };
    
}
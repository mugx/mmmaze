//
//  TNMazeGenerator.hpp
//  mmmaze
//
//  Created by mugx on 27/04/16.
//  Copyright © 2016 mugx. All rights reserved.
//

#ifndef TNMazeGenerator_hpp
#define TNMazeGenerator_hpp

#include <stdio.h>

typedef enum {
    MTWall,
    MTPath,
    MTStart,
    MTEnd
} MazeTyleType;

class TNMazeGenerator {
public:
    MazeTyleType** calculateMaze(int startX, int startY, int width, int height);
};

#endif

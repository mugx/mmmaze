//
//  MazeGenerator.hpp
//  mmmaze
//
//  Created by mugx on 27/04/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#ifndef MazeGenerator_hpp
#define MazeGenerator_hpp

#include <stdio.h>

typedef enum {
	MTWall,
	MTPath,
	MTStart,
	MTEnd
} MazeTyleType;

class MazeGenerator {
public:
	MazeTyleType** calculateMaze(int startX, int startY, int width, int height);
};

#endif

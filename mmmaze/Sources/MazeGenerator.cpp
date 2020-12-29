//
//  MazeGenerator.cpp
//  mmmaze
//
//  Created by mugx on 27/04/16.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

#include "MazeGenerator.hpp"
#include <stdlib.h>
#include <iostream>
#include <list>
#include <vector>
#include <map>

struct Tile {
	unsigned int x;
	unsigned int y;
	unsigned long steps;
	
	Tile(unsigned int x = 0, unsigned int y = 0, unsigned long steps = 0) {
		this->x = x;
		this->y = y;
		this->steps = steps;
	}
};

MazeTyleType** MazeGenerator::calculateMaze(int posX, int posY, int width, int height) {
	//--- init maze ---//
	MazeTyleType **maze = (MazeTyleType **)calloc(height, sizeof(MazeTyleType *));
	for (int i = 0; i < height;++i) {
		maze[i] = (MazeTyleType *)calloc(width, sizeof(MazeTyleType));
	}
	
	//--- taking start tile ---//
	maze[posX][posY] = MTStart;
	std::list<Tile> visitedTiles;
	std::list<Tile> currentPath = { Tile(posX, posY) };
	
	while (currentPath.size()) {
		std::vector<char> possibleDirections;
		if ((posX - 2 >= 0) && (maze[posX - 2][posY] == MTWall)) {
			possibleDirections.push_back('n');
		}
		
		if ((posX + 2 < height) && (maze[posX + 2][posY] == MTWall)) {
			possibleDirections.push_back('s');
		}
		
		if ((posY + 2 < width) && (maze[posX][posY + 2] == MTWall)) {
			possibleDirections.push_back('e');
		}
		
		if ((posY - 2 >= 0) && (maze[posX][posY - 2] == MTWall)) {
			possibleDirections.push_back('w');
		}
		
		if (possibleDirections.size() > 0) {  // forward
			char direMTion = possibleDirections[arc4random() % possibleDirections.size()];
			switch (direMTion)  {
				case 'n': {
					maze[posX - 2][posY] = MTPath;
					maze[posX - 1][posY] = MTPath;
					posX -= 2;
					break;
				}
				case 's': {
					maze[posX + 2][posY] = MTPath;
					maze[posX + 1][posY] = MTPath;
					posX += 2;
					break;
				}
				case 'e': {
					maze[posX][posY + 2] = MTPath;
					maze[posX][posY + 1] = MTPath;
					posY += 2;
					break;
				}
				case 'w': {
					maze[posX][posY - 2] = MTPath;
					maze[posX][posY - 1] = MTPath;
					posY -= 2;
					break;
				}
			}
			Tile tile(posX, posY, currentPath.size() * 2);
			currentPath.push_back(tile);
			visitedTiles.push_back(tile);
		}
		else { //backtracking
			Tile back = currentPath.back();
			posX = back.x;
			posY = back.y;
			currentPath.pop_back();
		}
	}
	
	//--- taking end tile ---//
	Tile end;
	for (Tile tile : visitedTiles) {
		if (tile.steps >= end.steps) {
			end = tile;
		}
	}
	maze[end.x][end.y] = MTEnd;
	return maze;
}

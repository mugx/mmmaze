//
//  MazeGenerator.swift
//  mmmaze
//
//  Created by mugx on 01/01/21.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class MazeGenerator {
	private typealias Visited = (pos: Position, stepsFromStart: Int)
	private let maze: Maze
	private let start: Position
	private let dimension: Int
	private var path = [Position]()
	private var visited = [Visited]()

	init(start: Position, dimension: Int) {
		self.maze = Maze(dimension: dimension, start: start)
		self.start = start
		self.dimension = dimension
	}

	func make() -> Maze {
		path.append(start)

		while !path.isEmpty {
			let currPos = path.last!
			if let next = nextDirection(for: currPos) {
				makePath(direction: next, pos: currPos)
			} else {
				path.removeLast()
			}
		}

		makeGoal()
		makeKey()

		return maze
	}

	// MARK: - Private

	private func nextDirection(for pos: Position) -> Direction? {
		var directions = [Direction]()
		maze.hasWall(at: pos.move(.up, 2)) ? directions.append(.up) : ()
		maze.hasWall(at: pos.move(.down, 2)) ? directions.append(.down) : ()
		maze.hasWall(at: pos.move(.left, 2)) ? directions.append(.left) : ()
		maze.hasWall(at: pos.move(.right, 2)) ? directions.append(.right) : ()

		if !directions.isEmpty {
			return directions.randomElement()
		} else {
			return nil
		}
	}

	private func makePath(direction: Direction, pos: Position) {
		let currTile = maze.digPath(direction, at: pos)
		path.append(currTile)
		visited.append(Visited(currTile, path.count * 2))
	}

	private func makeGoal() {
		let endPos = visited.max(by: { $0.stepsFromStart <= $1.stepsFromStart })!.pos
		maze[endPos]?.type = .goal
	}

	private func makeKey() {
		maze[maze.getFreePosition()]?.type = .key
		maze.removeFreePositions()
	}
}

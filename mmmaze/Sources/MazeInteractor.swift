//
//  MazeInteractor.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class MazeInteractor {
	private var itemWeights: [Float: BaseEntityType] {
		[
			0.99: .hearth,
			0.98: .time,
			0.9: .rotator,
			0.85: .bomb,
			0.5: .coin
		]
	}

	private var walls: Set<BaseEntity> = []
	private var items: Set<BaseEntity> = []
	private var entities: Set<BaseEntity> = []
	private var maze: Maze?
	private var dimension: Int = 0
	private unowned let mazeView: UIView
	private static let BASE_MAZE_DIMENSION: Int = 9

	deinit {
		mazeView.removeFromSuperview()
	}

	init(gameView: UIView, levelNumber: UInt) {
		let mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)

		self.mazeView = mazeView
		self.dimension = (Self.BASE_MAZE_DIMENSION + Int(levelNumber) * 2) % 30

		makeMaze()
	}

	// MARK: - Public

	func add(_ entity: BaseEntity) {
		if entity.type != .wall {
			entities.insert(entity)
		}
		mazeView.addSubview(entity.imageView!)
	}

	func remove(_ entity: BaseEntity) {
		entity.visible = false
		items.remove(entity)
		walls.remove(entity)
		entities.remove(entity)
	}

	func follow(_ entity: BaseEntity) {
		mazeView.follow(entity)
	}

	func checkWallCollision(_ frame: Frame) -> Bool {
		return walls.contains { $0.frame.collides(frame) }
	}

	func isWall(at frame: Frame, direction: Direction) -> Bool {
		let col = frame.col
		let row = frame.row
		let new_col = direction == .left ? col - 1 : direction == .right ? col + 1 : col
		let new_row = direction == .up ? row - 1 : direction == .down ? row + 1 : row
		return checkWallCollision(Frame(row: new_row, col: new_col))
	}

	func update(playerInteractor: PlayerInteractor, enemyInteractor: EnemyInteractor) {
		for item in items {
			playerInteractor.collide(with: item)
			enemyInteractor.collide(with: item)
		}
	}

	// MARK: - Hits

	func didHitBomb(_ bomb: BaseEntity) {
		for wall in walls {
			let row = wall.frame.row
			let col = wall.frame.col
			let isEdge = row == 0 || col == 0 || row == dimension - 1 || col == dimension - 1

			guard !isEdge, bomb.frame.isNeighbour(of: wall.frame) else { continue }

			wall.explode {
				self.walls.remove(wall)
			}
		}
		
		remove(bomb)
	}

	func didHitKey(_ key: BaseEntity) {
		guard let goal = walls.first(where: { $0.type == .goal_close }) else {
			return
		}

		goal.type = .goal_open
		walls.remove(goal)
	}

	func didHitRotator() {
		let gameView = mazeView.superview!
		let transform = gameView.transform.rotated(by: .pi / 2)

		UIView.animate(withDuration: 0.3, delay: 0, options: [.transitionCrossDissolve, .allowUserInteraction]) {
			gameView.transform = transform
			self.items.forEach { $0.transform = transform.inverted() }
			self.entities.forEach { $0.transform = transform.inverted() }
		}
	}

	// MARK: - Private

	private func makeMaze() {
		let startRow = Constants.STARTING_CELL.row
		let startCol = Constants.STARTING_CELL.col
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, dimension: dimension)

		for row in 0 ..< dimension {
			for col in 0 ..< dimension {
				switch maze[row, col] {
				case .wall:
					makeWall(for: maze, row: row, col: col)
				case .start:
					break
				case .goal:
					makeGoal(for: maze, row: row, col: col)
				default:
					makeItem(for: maze, col: col, row: row)
				}
			}
		}

		makeKey(for: maze)
		maze.removeFreePositions()
	}

	private func makeWall(for maze: Maze, row: Int, col: Int) {
		let tile = BaseEntity(type: .wall, row: row, col: col)
		add(tile)
		walls.insert(tile)
	}

	private func makeGoal(for maze: Maze, row: Int, col: Int) {
		let tile = BaseEntity(type: .goal_close, row: row, col: col)
		add(tile)
		items.insert(tile)
		walls.insert(tile)
	}

	private func makeKey(for maze: Maze) {
		let tile = BaseEntity(type: .key, position: maze.getFreePosition())
		add(tile)
		items.insert(tile)
	}

	private func makeItem(for maze: Maze, col: Int, row: Int) {
		let position = Position(row: row, col: col)
		let rand = Float.random(in: 0 ..< 1)

		if let type = itemWeights.filter({ $0.0 < rand }).last {
			let tile = BaseEntity(type: type.value, position: position)
			add(tile)
			items.insert(tile)
		} else {
			maze.markFree(position: position)
		}
	}
}

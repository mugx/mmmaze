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

	var rotation: Int = 0
	private let maze: Maze
	private var walls: Set<BaseEntity> = []
	private var items: Set<BaseEntity> = []
	private var entities: Set<BaseEntity> = []
	private var dimension: Int = 0
	private unowned let mazeView: UIView
	static let STARTING_CELL = Position(row: 1, col: 1)
	private static let BASE_MAZE_DIMENSION: Int = 9

	deinit {
		mazeView.removeFromSuperview()
	}

	init(gameView: UIView, levelNumber: UInt) {
		let mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)
		self.mazeView = mazeView
		self.dimension = (Self.BASE_MAZE_DIMENSION + Int(levelNumber) * 2) % 30
		self.maze = MazeGenerator(start: Self.STARTING_CELL, dimension: dimension).make()

		populateMaze()
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
		let pos = Position(row: frame.row, col: frame.col)
		let new_pos = pos.move(direction)
		return checkWallCollision(Frame(row: new_pos.row, col: new_pos.col))
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
		guard let goal = items.first(where: { $0.type == .goal_close }) else {
			return
		}

		goal.type = .goal_open
		walls.remove(goal)
	}

	func didHitRotator() {
		rotation += 1
		let view = mazeView.superview!
		let transform = view.layer.affineTransform().rotated(by: .pi / 2)

		UIView.animate(withDuration: 0.25, delay: 0, options: [.allowUserInteraction]) {
			view.layer.setAffineTransform(transform)
			self.items.forEach { $0.transform = transform.inverted() }
		}

		entities.forEach { $0.transform = transform.inverted() }
	}

	// MARK: - Private

	private func populateMaze() {
		for cell in maze {
			makeEntity(for: cell)
		}
	}

	private func makeEntity(for tile: MazeTile) {
		switch tile.type {
		case .wall:
			let entity = BaseEntity(type: .wall, position: tile.pos)
			add(entity)
			walls.insert(entity)
		case .path:
			let rand = Float.random(in: 0 ..< 1)
			if let type = itemWeights.filter({ $0.0 < rand }).last {
				let entity = BaseEntity(type: type.value, position: tile.pos)
				add(entity)
				items.insert(entity)
			}
		case .key:
			let entity = BaseEntity(type: .key, position: tile.pos)
			add(entity)
			items.insert(entity)
		case .goal:
			let entity = BaseEntity(type: .goal_close, position: tile.pos)
			add(entity)
			items.insert(entity)
			walls.insert(entity)
		case .start:
			break
		}
	}
}

//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

class Enemy: Tile {
	@objc var wantSpawn: Bool = false
	var visible: Bool { alpha == 1 && !isHidden }
	
	private static let SPEED = 1.5
	private var path: NSMutableArray
	private var timeAccumulator: CGFloat = 0.0

	init(gameSession: GameSession) {
		path = NSMutableArray()

		super.init(frame: .zero)

		self.gameSession = gameSession
		self.speed = Float(Self.SPEED)
 
		setupAnimations()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	@objc func spawn() -> Enemy {
		wantSpawn = false

		let enemy = Enemy(gameSession: gameSession)
		enemy.frame = frame
		enemy.show()
		return enemy
	}
	
	@objc func show() {
		UIView.animateKeyframes(withDuration: 0.5, delay: 1.0) {
			self.isHidden = false
			self.alpha = 1.0
		} completion: { _ in
			self.speed = Float(self.speed)
		}
	}
	
	@objc override func update(_ delta: CGFloat) {
		timeAccumulator += delta

		calculatePath()

		if path.count > 0 {
			refinesPath()
			decideNextMove(delta)
		}

		super.update(delta)
	}

	//MARK: - Private
	
	override func respawnAtInitialFrame() {
		isHidden = true
		alpha = 0.0

		super.respawnAtInitialFrame()
	}

	private func setupAnimations() {
		animationDuration = 0.4
		animationImages = UIImage(named: "enemy")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
		startAnimating()
	}

	@objc private func currentPosition() -> CGRect {
		let initialTile_x = round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE
		let initialTile_y = round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE
		
		return CGRect(
			x: initialTile_x,
			y: initialTile_y,
			width: TILE_SIZE,
			height: TILE_SIZE
		)
	}
	
	@objc private func calculatePath() {
		guard timeAccumulator > 1 || path.count == 0 else { return }
		timeAccumulator = 0

		let currentPosition = self.currentPosition()
		let newPath = search(gameSession.player.frame) ?? []
		let firstPathFrame = (path.firstObject as? NSValue)?.cgRectValue ?? CGRect.zero
		let firstNewPathFrame = (newPath.first as? NSValue)?.cgRectValue ?? CGRect.zero
		let currentSteps = path.count
		let newSteps = newPath.count

		let d1 = distance(rect1: currentPosition, rect2: firstPathFrame)
		let d2 = distance(rect1: currentPosition, rect2: firstNewPathFrame)

		let hasToUpdatePath =
			currentSteps == 0 ||
			currentSteps > newSteps ||
			d1 > d2

		if hasToUpdatePath {
			path = NSMutableArray(array: newPath)
		}
	}

	@objc private func refinesPath() {
		let currentPosition = self.currentPosition()
		let enrolledPath: [CGRect] = path.compactMap { ($0 as? NSValue)?.cgRectValue }
		if collides(target: currentPosition, path: enrolledPath) {
			path.remove(currentPosition)
		}
	}

	@objc private func decideNextMove(_ delta: CGFloat) {
		let speed = CGFloat(self.speed + self.speed * Float(delta))
		let eastFrame = CGRect(x: CGFloat(frame.origin.x - speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let westFrame = CGRect(x: CGFloat(frame.origin.x + speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let northFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y - speed), width: frame.size.width, height: frame.size.height)
		let southFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y + speed), width: frame.size.width, height: frame.size.height)
		let collidesEast = checkWallCollision(eastFrame) != nil
		let collidesWest = checkWallCollision(westFrame) != nil
		let collidesNorth = checkWallCollision(northFrame) != nil
		let collidesSouth = checkWallCollision(southFrame) != nil

		var possibleDirections: [[String: Any]] = []
		if !collidesEast {
			possibleDirections.append(["move": "e", "frame": NSValue(cgRect: eastFrame)])
		}

		if !collidesWest {
			possibleDirections.append(["move": "w", "frame": NSValue(cgRect: westFrame)])
		}

		if !collidesNorth {
			possibleDirections.append(["move": "n","frame": NSValue(cgRect: northFrame)])
		}

		if !collidesSouth {
			possibleDirections.append(["move": "s","frame": NSValue(cgRect: southFrame)])
		}

		let nextFrame = (path.firstObject as? NSValue)?.cgRectValue ?? CGRect.zero
		switch getBestDirection(possibleDirections, targetFrame: nextFrame) {
		case "e":
			didSwipe(UISwipeGestureRecognizer.Direction.left)
		case "w":
			didSwipe(UISwipeGestureRecognizer.Direction.right)
		case "n":
			didSwipe(UISwipeGestureRecognizer.Direction.up)
		case "s":
			didSwipe(UISwipeGestureRecognizer.Direction.down)
		default:
			break
		}
	}
}

//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension Enemy {
	@objc static let SPEED = 1.5

	@objc convenience init(frame: CGRect, gameSession: GameSession) {
		self.init(frame: frame)
		self.gameSession = gameSession

		path = []
		layer.zPosition = 10
		velocity = CGPoint.zero
	}

	//	required init?(coder: NSCoder) {
	//		fatalError("init(coder:) has not been implemented")
	//	}

	@objc func originalFrame() -> CGRect {
		let originalFrame = CGRect(
			x: round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE,
			y: round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE,
			width: TILE_SIZE,
			height:TILE_SIZE
		)
		return originalFrame
	}

	@objc func calculatePath() {
		let originalFrame = self.originalFrame()

		if (self.path.count == 0) {
			let newPath = search(gameSession.player.frame) ?? []
			guard let firstPathFrame = path.firstObject as? NSValue else {
				return
			}
			guard let firstNewPathFrame = newPath.first as? NSValue else {
				return
			}
			let currentSteps = path.count
			let newSteps = newPath.count

			let d1 = distance(rect1: originalFrame, rect2: firstPathFrame.cgRectValue)
			let d2 = distance(rect1: originalFrame, rect2: firstNewPathFrame.cgRectValue)

			let hasToUpdatePath =
				currentSteps == 0 ||
				currentSteps > newSteps ||
				d1 > d2

			if hasToUpdatePath {
				upatePathAccumulator = 0
				path = NSMutableArray(array: newPath)
			}
		}

		//		if (self.timeAccumulator > 1 || self.path.count == 0)
		//		{
		//			self.timeAccumulator = 0;
		//			NSArray *newPath = [self search: self.gameSession.player.frame];
		//			CGRect firstPathFrame = [self.path.firstObject CGRectValue];
		//			CGRect firstNewPathFrame = [newPath.firstObject CGRectValue];
		//			NSUInteger currentSteps = self.path.count;
		//			NSUInteger newSteps = newPath.count;
		//
		//			BOOL hasToUpdatePath =
		//			currentSteps == 0 ||
		//			currentSteps > newSteps ||
		//			([self distanceWithRect1:originalFrame rect2:firstPathFrame] > [self distanceWithRect1:originalFrame rect2:firstNewPathFrame]);
		//			if (hasToUpdatePath)
		//			{
		//				self.upatePathAccumulator = 0;
		//				self.path = [NSMutableArray arrayWithArray:newPath];
		//			}
		//		}
	}
}
//
//class Enemy: Tile {
//	@objc var wantSpawn: Bool = false
//	let exploding: Bool = false
//	var timeAccumulator: CGFloat = 0.0
//	var upatePathAccumulator: CGFloat = 0.0
//	var path: [CGRect] = []
//	@objc static let SPEED = 1.5
//
//	init(frame: CGRect, gameSession: GameSession) {
//		super.init(frame: frame)
//
//		self.gameSession = gameSession
//		layer.zPosition = 10
//		velocity = CGPoint.zero
//	}

//
////	@objc override func update(_ delta: CGFloat) {
////		timeAccumulator += delta
////		upatePathAccumulator += delta
////
////		if (self.timeAccumulator > 1 || self.path.count == 0) {
////			self.timeAccumulator = 0;
////			let newPath = search(gameSession.player.frame) as! [CGRect]
////			let firstPathFrame = path.first ?? CGRect.zero
////			let firstNewPathFrame = newPath.first!
////			let currentSteps = path.count
////			let newSteps = newPath.count
////
////			let hasToUpdatePath =
////				currentSteps == 0 ||
////				currentSteps > newSteps ||
////				distance(rect1: originalFrame, rect2: firstPathFrame) > distance(rect1: originalFrame, rect2: firstNewPathFrame)
////
////			if hasToUpdatePath {
////				upatePathAccumulator = 0
////				path = newPath
////			}
////		}
////
////		if path.count > 0 {
////			let nextFrame = path.first!
////			if collides(target: originalFrame, path: path as Array<NSValue>) {
////				path.removeAll { $0 as AnyObject === NSValue(cgRect: originalFrame) as AnyObject }
////			}
////
////			let speed = CGFloat(self.speed + self.speed * Float(delta))
////			let eastFrame = CGRect(x: CGFloat(frame.origin.x - speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
////			let westFrame = CGRect(x: CGFloat(frame.origin.x + speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
////			let northFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y - speed), width: frame.size.width, height: frame.size.height)
////			let southFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y + speed), width: frame.size.width, height: frame.size.height)
////			let collidesEast = checkWallCollision(eastFrame) != nil
////			let collidesWest = checkWallCollision(westFrame) != nil
////			let collidesNorth = checkWallCollision(northFrame) != nil
////			let collidesSouth = checkWallCollision(southFrame) != nil
////
////			var possibleDirections: [AnyHashable] = []
////			if !collidesEast {
////				possibleDirections.append([
////					"move": NSNumber(value: String("e").utf8.map{ Int8($0) }.first ?? 0),
////					"frame": NSValue(cgRect: eastFrame)
////				])
////			}
////
////			if !collidesWest {
////				possibleDirections.append([
////					"move": NSNumber(value: String("w").utf8.map{ Int8($0) }.first ?? 0),
////					"frame": NSValue(cgRect: westFrame)
////				])
////			}
////
////			if !collidesNorth {
////				possibleDirections.append([
////					"move": NSNumber(value: String("n").utf8.map{ Int8($0) }.first ?? 0),
////					"frame": NSValue(cgRect: northFrame)
////				])
////			}
////
////			if !collidesSouth {
////				possibleDirections.append([
////					"move": NSNumber(value: String("s").utf8.map{ Int8($0) }.first ?? 0),
////					"frame": NSValue(cgRect: southFrame)
////				])
////			}
////
////			let dir = UInt8(getBestDirection(possibleDirections, targetFrame: nextFrame))
////			switch Character(UnicodeScalar(dir)) {
////			case "e":
////				didSwipe(UISwipeGestureRecognizer.Direction.left)
////			case "w":
////				didSwipe(UISwipeGestureRecognizer.Direction.right)
////			case "n":
////				didSwipe(UISwipeGestureRecognizer.Direction.up)
////			case "s":
////				didSwipe(UISwipeGestureRecognizer.Direction.down)
////			default:
////				break
////			}
////			super.update(delta)
////		}
////	}
//}

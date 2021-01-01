//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc enum TyleType: Int {
	case door
	case wall
	case explodedWall
	case coin
	case whirlwind
	case bomb
	case time
	case hearth
	case key
	case mazeEnd_close
	case mazeEnd_open
}

class Tile: UIImageView {
	var velocity: CGPoint = .zero
	var speed: Float = 0
	var didVerticalSwipe: Bool = false
	var didHorizontalSwipe: Bool = false
	@objc var x: Int = 0
	@objc var y: Int = 0
	@objc var isDestroyable: Bool = false
	var isBlinking: Bool = false
	@objc var isAngry: Bool = false
	var collidedWall: Tile?
	var gameSession: GameSession?
	var lastSwipe: UISwipeGestureRecognizer.Direction?
	var animations: [String: CABasicAnimation] = [:]

	@objc override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		lastSwipe = direction
		
		switch direction {
		case .right:
			self.velocity = CGPoint(x: CGFloat(self.speed), y: self.velocity.y);
		case .left:
			self.velocity = CGPoint(x: CGFloat(-self.speed), y: self.velocity.y);
		case .up:
			self.velocity = CGPoint(x: self.velocity.x, y: CGFloat(-self.speed))
		case .down:
			self.velocity = CGPoint(x: self.velocity.x, y: CGFloat(self.speed));
		default:
			break
		}
	}

	@objc func update(_ delta: TimeInterval) {
		var frame = self.frame
		let velx = velocity.x + velocity.x * CGFloat(delta)
		let vely = velocity.y + velocity.y * CGFloat(delta)

		var didHorizontalMove = false
		var didVerticalMove = false
		var didWallExplosion = false

		//--- checking horizontal move ---//
		if (velx < 0 || velx > 0) {
			let frameOnHorizontalMove = CGRect(x: frame.origin.x + velx, y: frame.origin.y, width :frame.size.width, height: frame.size.height)

			self.collidedWall = checkWallCollision(frameOnHorizontalMove)
			if (self.collidedWall == nil) {
				didHorizontalMove = true
				frame = frameOnHorizontalMove

				if (vely != 0 && !(self.lastSwipe == UISwipeGestureRecognizer.Direction.up || self.lastSwipe == UISwipeGestureRecognizer.Direction.down)) {
					self.velocity = CGPoint(x: self.velocity.x, y: 0);
				}
			}

			didWallExplosion = explodeWall()
		}

		//--- checking vertical move ---//
		if (vely < 0 || vely > 0) {
			let frameOnVerticalMove = CGRect(x: frame.origin.x, y: frame.origin.y + vely, width: frame.size.width, height: frame.size.height)
			self.collidedWall = checkWallCollision(frameOnVerticalMove)
			if (self.collidedWall == nil) {
				didVerticalMove = true
				frame = frameOnVerticalMove

				if (velx != 0 && !(self.lastSwipe == UISwipeGestureRecognizer.Direction.left || self.lastSwipe == UISwipeGestureRecognizer.Direction.right)) {
					self.velocity = CGPoint(x: 0, y: self.velocity.y)
				}
			}

			didWallExplosion = explodeWall()
		}

		if (didHorizontalMove || didVerticalMove || didWallExplosion) {
			self.frame = frame
		} else {
			self.velocity = .zero
		}
	}

	@objc func checkWallCollision(_ frame: CGRect) -> Tile? {
		return (gameSession?.wallsDictionary.allValues as! [Tile]).first(where: {
			$0.tag != TyleType.explodedWall.rawValue && $0.frame.intersects(frame)
		})
	}
	
	@objc func isWall(at frame: CGRect, direction: UISwipeGestureRecognizer.Direction) -> Bool {
		let col = Int(round(Double(frame.origin.x) / TILE_SIZE))
		let row = Int(round(Double(frame.origin.y) / TILE_SIZE))
		let col_offset = direction == .left ? col - 1 : direction == .right ? col + 1 : col
		let row_offset = direction == .up ? row - 1 : direction == .down ? row + 1 : row
		let wallPosition = NSValue(cgPoint: CGPoint(x: row_offset, y: col_offset))
		
		guard let tile = gameSession?.wallsDictionary[wallPosition] as? Tile else { return false }
		return tile.tag != TyleType.explodedWall.rawValue
	}
	
	@objc func flip() {
		let anim = CABasicAnimation.flipAnimation()
		layer.add(anim, forKey: "flip")
		animations["flip"] = anim
	}
	
	@objc func spin() {
		let anim = CABasicAnimation.spinAnimation()
		layer.add(anim, forKey: "spin")
		animations["spin"] = anim
	}
	
	func restoreAnimations() {
		animations.forEach({ (arg0) in
			layer.add(arg0.value, forKey: arg0.key)
		})
	}
	
	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	@objc func respawnAtInitialFrame() {
		velocity = .zero
		
		let initialTile_x = Double(Constants.STARTING_CELL.x * CGFloat(TILE_SIZE))
		let initialTile_y = Double(Constants.STARTING_CELL.y * CGFloat(TILE_SIZE))
		frame = CGRect(
			x: initialTile_x + Double(speed) / 2.0,
			y: initialTile_y + Double(speed) / 2.0,
			width: TILE_SIZE - Double(speed),
			height: TILE_SIZE - Double(speed)
		)
	}
	
	@objc func explodeWall() -> Bool {
		guard let collidedWall = collidedWall,
					collidedWall.tag == TyleType.wall.rawValue,
					collidedWall.isDestroyable,
					isAngry else { return false }
		
		collidedWall.explode()
		collidedWall.tag = TyleType.explodedWall.rawValue
		isAngry = false
		return true
	}
}

//
//  GameSession.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	@objc func play(sound: SoundType) {
		playSound(sound)
	}

	@objc func makePlayer() {
		player?.removeFromSuperview()

		let initialTile_x = Double(Constants.STARTING_CELL.y * CGFloat(TILE_SIZE))
		let initialTile_y = Double(Constants.STARTING_CELL.x * CGFloat(TILE_SIZE))
		let frame = CGRect(
			x: initialTile_x + Player.SPEED / 2.0,
			y: initialTile_y + Player.SPEED / 2.0,
			width: TILE_SIZE - Player.SPEED,
			height: TILE_SIZE - Player.SPEED
		)

		player = Player(frame: frame, gameSession: self)
		player.animationImages = UIImage(named: "player")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
		player.animationDuration = 0.4
		player.animationRepeatCount = 0
		player.startAnimating()
		mazeView.addSubview(player)
	}

	@objc func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		isGameStarted = true
		player.didSwipe(direction)
	}
}

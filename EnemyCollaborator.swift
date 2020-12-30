//
//  EnemyCollaborator.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension EnemyCollaborator {
	@objc public convenience init(gameSession: GameSession) {
		self.init()
		
		self.gameSession = gameSession
		initEnemies()
	}

	@objc func spawn(from enemy: Enemy) {
		for currentEnemy in spawnableEnemies as! [Enemy] {
			if currentEnemy.isHidden {
				let size = CGSize(width: TILE_SIZE, height: TILE_SIZE)
				currentEnemy.animationImages = UIImage(named: "enemy")?.sprites(with: size)
				currentEnemy.startAnimating()
				spawnableEnemies.remove(currentEnemy)
				enemies.add(currentEnemy)

				UIView.animateKeyframes(withDuration: 0.5, delay: 1.0) {
					currentEnemy.isHidden = false
					currentEnemy.alpha = 1.0
				} completion: { _ in
					currentEnemy.speed = self.speed
				}

				currentEnemy.frame = enemy.frame;
				break
			}
		}
	}
}

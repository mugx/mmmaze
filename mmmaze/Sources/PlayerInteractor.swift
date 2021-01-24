//
//  PlayerInteractor.swift
//  mmmaze
//
//  Created by mugx on 18/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol PlayerInteractorDelegate: class {
	func didUpdate(lives: UInt)
	func didHitGoal()
	func didGetBonus(score: UInt)
	func didGameOver(from interactor: PlayerInteractor)
}

class PlayerInteractor {
	private var collisionActions: [BaseEntityType: (BaseEntity)->()] {
		[
			.coin: hitCoin,
			.rotator: hitRotator,
			.time: hitTimeBonus,
			.key: hitKey,
			.hearth: hitHearth,
			.bomb: hitBomb,
			.goal_open: hitGoal,
		]
	}

	private unowned let delegate: PlayerInteractorDelegate
	private unowned let mazeInteractor: MazeInteractor
	private(set) var player: Player!

	init(delegate: PlayerInteractorDelegate, mazeInteractor: MazeInteractor) {
		self.delegate = delegate
		self.mazeInteractor = mazeInteractor
		self.player = Player(mazeInteractor: mazeInteractor)
		mazeInteractor.add(player)
	}

	// MARK: - Public

	func update(_ delta: TimeInterval, enemyInteractor: EnemyInteractor) {
		guard player.currentLives > 0 else {
			delegate.didGameOver(from: self)
			return
		}

		player.update(delta)
		mazeInteractor.follow(player)
		enemyInteractor.collide(with: player)
		delegate.didUpdate(lives: player.currentLives)
	}

	func collide(with entity: BaseEntity) {
		guard entity.collides(player) else { return }

		collisionActions[entity.type]?(entity)
	}

	func move(to direction: Direction) {
		play(sound: .selectItem)
		player.move(to: direction)
	}

	// MARK: - Private

	private func hitRotator(entity: BaseEntity) {
		play(sound: .hitRotator)
		mazeInteractor.didHitRotator()
		entity.visible = false
	}

	private func hitCoin(entity: BaseEntity) {
		play(sound: .hitCoin)
		delegate.didGetBonus(score: 15)
		entity.visible = false
	}

	private func hitTimeBonus(entity: BaseEntity) {
		play(sound: .hitTimeBonus)
		delegate.didGetBonus(score: 5)
		entity.visible = false
	}

	private func hitKey(entity: BaseEntity) {
		play(sound: .hitHearth)
		mazeInteractor.didHitKey(entity)
		entity.visible = false
	}

	private func hitHearth(entity: BaseEntity) {
		play(sound: .hitHearth)
		player.currentLives += 1
		delegate.didUpdate(lives: player.currentLives)
		delegate.didGetBonus(score: 5)
		entity.visible = false
	}

	private func hitBomb(entity: BaseEntity) {
		play(sound: .hitBomb)
		mazeInteractor.didHitBomb(entity)
		delegate.didGetBonus(score: 5)
	}

	private func hitGoal(entity: BaseEntity) {
		delegate.didHitGoal()
		delegate.didGetBonus(score: 100)
	}
}

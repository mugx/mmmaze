//
//  AudioManager.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import AVFoundation

@objc
enum SoundType: UInt {
		case hitCoin
		case hitWhirlwind
		case hitBomb
		case hitHearth
		case hitTimeBonus
		case startGame
		case game
		case selectItem
		case timeOver
		case gameOver
		case levelChange
		case enemySpawn
		case hitPlayer
}

func playSound(_ sound: SoundType) {
	AudioManager.shared.play(sound: sound)
}

@objc class AudioManager: NSObject {
	@objc static let shared = AudioManager()
	var soundEnabled: Bool = false
	var volume: Float = 0
	private var sounds = [SoundType: AVAudioPlayer]()

	func play(sound: SoundType) {
		guard soundEnabled, !UIDevice.current.isSimulator else { return }

		try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
		try? AVAudioSession.sharedInstance().setActive(true)

		var fileName = ""
		switch sound {
		case .hitCoin:
			fileName = "soundHitCoin"
		case .selectItem:
			fileName = "soundSelectItem"
		case .hitWhirlwind:
			fileName = "soundSelectItem"
		case .hitBomb:
			fileName = "soundHitBomb"
		case .hitHearth:
			fileName = "soundHitHearth"
		case .hitTimeBonus:
			fileName = "soundHitTimeBonus"
		case .startGame:
			fileName = "soundStartGame"
		case .game:
			fileName = "soundGame"
		case .timeOver:
			fileName = "soundTimeOver"
		case .gameOver:
			fileName = "soundGameOver"
		case .levelChange:
			fileName = "soundLevelChange"
		case .enemySpawn:
			fileName = "soundEnemySpawn"
		case .hitPlayer:
			fileName = "soundHitPlayer"
		}

		if sounds[sound] == nil, let url = Bundle.main.url(forResource: fileName, withExtension: "caf") {
			let player = try? AVAudioPlayer(contentsOf: url)
			player?.prepareToPlay()
			sounds[sound] = player
		}
		sounds[sound]?.volume = volume
		sounds[sound]?.play()
	}
}

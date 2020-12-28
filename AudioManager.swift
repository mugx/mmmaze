//
//  AudioManager.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import AVFoundation

enum AudioFileType: String {
	case mp3 = "mp3"
	case wav = "wav"
}

@objc class AudioManager: NSObject {
	@objc static let shared = AudioManager()
	var soundEnabled: Bool = false
	var volume: Float = 0

	@objc func play(_ sound: SoundType) {
		var fileName = ""
		switch sound {
		case .STHitCoin:
			fileName = "soundHitCoin"
		case .STSelectItem:
			fileName = "soundSelectItem"
		case .STHitWhirlwind:
			fileName = "soundSelectItem"
		case .STHitBomb:
			fileName = "soundHitBomb"
		case .STHitHearth:
			fileName = "soundHitHearth"
		case .STHitTimeBonus:
			fileName = "soundHitTimeBonus"
		case .STStartGame:
			fileName = "soundStartGame"
		case .STGame:
			fileName = "soundGame"
		case .STTimeOver:
			fileName = "soundTimeOver"
		case .STGameOver:
			fileName = "soundGameOver"
		case .STLevelChange:
			fileName = "soundLevelChange"
		case .STEnemySpawn:
			fileName = "soundEnemySpawn"
		case .STHitPlayer:
			fileName = "soundHitPlayer"
		}

		try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
		try! AVAudioSession.sharedInstance().setActive(true)

		let url = Bundle.main.url(forResource: fileName, withExtension: "caf")
		let player: AVAudioPlayer! = try! AVAudioPlayer(contentsOf: url!)
		player.play()
	}
}

//
//  AudioManager.swift
//  mmmaze
//
//  Created by mugx on 28/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import AVFoundation
import UIKit

enum SoundType: String {
	case enemySpawn
	case game
	case gameOver
	case hitBomb
	case hitCoin
	case hitHearth
	case hitPlayer
	case hitRotator
	case hitTimeBonus
	case levelChange
	case selectItem
	case startGame
	case timeOver
}

enum VolumeType: Float, CaseIterable {
	case mute = 0
	case low = 0.1
	case mid = 0.5
	case high = 1

	mutating func next() {
		let allCases = Self.allCases
		self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
	}
}

func play(sound: SoundType) {
	AudioManager.shared.play(sound: sound)
}

class AudioManager {
	static let shared = AudioManager()
	var soundEnabled: Bool = true
	var volume: VolumeType = .mid
	private var sounds = [SoundType: AVAudioPlayer]()

	func play(sound: SoundType) {
		guard soundEnabled, !UIDevice.current.isSimulator else { return }

		try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
		try? AVAudioSession.sharedInstance().setActive(true)

		if sounds[sound] == nil, let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "caf") {
			let player = try? AVAudioPlayer(contentsOf: url)
			player?.prepareToPlay()
			sounds[sound] = player
		}
		sounds[sound]?.volume = volume.rawValue
		sounds[sound]?.play()
	}
}

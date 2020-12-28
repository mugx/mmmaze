//
//  TNSettingsViewController.swift
//  mmmaze
//
//  Created by mugx on 23/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import UIKit

class TNSettingsViewController: UIViewController {
    @IBOutlet var settingsTitleLabel: UILabel!
    @IBOutlet var languageView: UIView!
    @IBOutlet var languageTitleLabel: UILabel!
    @IBOutlet var languageValueLabel: UILabel!
    @IBOutlet var soundEnabledView: UIView!
    @IBOutlet var soundEnabledTitleLabel: UILabel!
    @IBOutlet var soundEnabledValueLabel: UILabel!
    @IBOutlet var soundEnabledButton: UIButton!
    @IBOutlet var soundVolumeView: UIView!
    @IBOutlet var soundVolumeTitleLabel: UILabel!
    @IBOutlet var soundVolumeValueLabel: UILabel!
    @IBOutlet var volumeButton: UIButton!
    @IBOutlet var backButton: UIButton!

    enum VolumeType: Int {
        case mute = 0
        case low = 1
        case mid = 5
        case high = 10
    }
    
    static func create() -> TNSettingsViewController {
        return TNSettingsViewController(nibName: "TNSettingsViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--- setting buttons ---//
        languageView.layer.borderColor = Constants.magentaColor.cgColor;
        languageView.layer.borderWidth = 2.0
        
        soundEnabledView.layer.borderColor = Constants.magentaColor.cgColor;
        soundEnabledView.layer.borderWidth = 2.0;
        
        soundVolumeView.layer.borderColor = Constants.magentaColor.cgColor;
        soundVolumeView.layer.borderWidth = 2.0;
        
        backButton.layer.borderColor = Constants.magentaColor.cgColor;
        backButton.layer.borderWidth = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    //MARK: - Refresh

    func refresh() {
        let locale = NSLocale(localeIdentifier: MXLocalizationManager.sharedInstance()!.currentLanguageCode)
        languageValueLabel.text = locale.displayName(forKey: NSLocale.Key.identifier, value: MXLocalizationManager.sharedInstance()!.currentLanguageCode.capitalized)
        soundEnabledTitleLabel.text = "mmmaze.settings.sound".localized
        soundEnabledValueLabel.text = MXAudioManager.sharedInstance()!.soundEnabled ? "mmmaze.settings.enabled".localized : "mmmaze.settings.disabled".localized
        soundEnabledButton.isSelected = MXAudioManager.sharedInstance()!.soundEnabled
        soundVolumeTitleLabel.text = "mmmaze.settings.volume".localized
        backButton.setTitle("mmmaze.menu.back".localized, for: .normal)
        refreshSoundVolume()
    }
    
    func refreshSoundVolume() {
        switch VolumeType(rawValue: Int(MXAudioManager.sharedInstance()!.volume * 10))! {
        case .mute:
            volumeButton.setImage(UIImage(named: "iconVolumeMute"), for: .normal)
            soundVolumeValueLabel.text = "mmmaze.settings.volume_mute".localized
        case .low:
            volumeButton.setImage(UIImage(named: "iconVolumeLow"), for: .normal)
            soundVolumeValueLabel.text = "mmmaze.settings.volume_low".localized
        case .mid:
            volumeButton.setImage(UIImage(named: "iconVolumeMid"), for: .normal)
            soundVolumeValueLabel.text = "mmmaze.settings.volume_mid".localized
        case .high:
            volumeButton.setImage(UIImage(named: "iconVolumeHigh"), for: .normal)
            soundVolumeValueLabel.text = "mmmaze.settings.volume_high".localized
        }
    }

    //MARK: - IBActions

    @IBAction func languageDecrTouched() {
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)

        //--- decr logic ---//
        let langs = MXLocalizationManager.sharedInstance()!.availableLanguages()!
        for i in 0...langs.count {
            let currentCode = langs[i] as! String
            if currentCode == MXLocalizationManager.sharedInstance()!.currentLanguageCode! {
                let newIndex = (i - 1 + langs.count) % langs.count
                let newLangCode = langs[newIndex] as! String
                MXLocalizationManager.sharedInstance()?.currentLanguageCode = newLangCode
                break
            }
        }
        refresh()
    }

    @IBAction func languageIncrTouched() {
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)

        //--- incr logic ---//
        let langs = MXLocalizationManager.sharedInstance()!.availableLanguages()!
        for i in 0...langs.count {
            let currentCode = langs[i] as! String
            if currentCode == MXLocalizationManager.sharedInstance()!.currentLanguageCode! {
                let newIndex = (i + 1) % langs.count
                let newLangCode = langs[newIndex] as! String
                MXLocalizationManager.sharedInstance()?.currentLanguageCode = newLangCode
                break
            }
        }
        refresh()
    }

    @IBAction func soundVolumeTouched() {
        switch VolumeType(rawValue: Int(MXAudioManager.sharedInstance()!.volume * 10))! {
        case .mute:
            MXAudioManager.sharedInstance()!.volume = Float(VolumeType.low.rawValue) / 10.0
            volumeButton.setImage(UIImage(named: "iconVolumeLow"), for: .normal)
        case .low:
            MXAudioManager.sharedInstance()!.volume = Float(VolumeType.mid.rawValue) / 10.0
            volumeButton.setImage(UIImage(named: "iconVolumeMid"), for: .normal)
        case .mid:
            MXAudioManager.sharedInstance()!.volume = Float(VolumeType.high.rawValue) / 10.0
            volumeButton.setImage(UIImage(named: "iconVolumeHigh"), for: .normal)
        case .high:
            MXAudioManager.sharedInstance()!.volume = Float(VolumeType.mute.rawValue) / 10.0
            volumeButton.setImage(UIImage(named: "iconVolumeMute"), for: .normal)
        }
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
        refresh()
    }

    @IBAction func soundEnabledTouched() {
        MXAudioManager.sharedInstance()?.soundEnabled = !MXAudioManager.sharedInstance()!.soundEnabled
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
        refresh()
    }

    @IBAction func backTouched() {
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
        AppDelegate.sharedInstance.selectScreen(ScreenType.STMenu)
    }
}

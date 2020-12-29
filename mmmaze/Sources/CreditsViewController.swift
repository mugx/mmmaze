//
//  CreditsViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import Foundation
import MessageUI

@objcMembers
class CreditsViewController: UIViewController {
	@IBOutlet var versionLabel: UILabel!
	@IBOutlet var logoIconImage: UIImageView!
	@IBOutlet var sendFeedbackButton: UIButton!
	@IBOutlet var backButton: UIButton!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		versionLabel.text = "v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!)"
	}

	//MARK: - Actions

	@IBAction func backTouched() {
		AudioManager.shared.play(SoundType.STSelectItem)
		AppDelegate.sharedInstance.selectScreen(.STMenu)
	}

	@IBAction func sendFeedbackTouched() {
		if MFMailComposeViewController.canSendMail() {
			let emailController = MFMailComposeViewController()
			emailController.mailComposeDelegate = self
			emailController.setCcRecipients([Constants.FEEDBACK_EMAIL])
			emailController.setMessageBody("", isHTML: false)
			emailController.setSubject("Feedback mmmaze")
			emailController.title = "Feedback"
			present(emailController, animated: true, completion: nil)
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate

extension CreditsViewController: MFMailComposeViewControllerDelegate {
	@objc func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult,error: Error?) {
		switch (result) {
		case .cancelled:
			print("Mail cancelled: you cancelled the operation and no email message was queued")
		case .saved:
			print("Mail saved: you saved the email message in the Drafts folder")
		case .sent:
			print("Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email")
		case .failed:
			print("Mail failed: the email message was nog saved or queued, possibly due to an error")
		default:
			print("Mail not sent")
			break;
		}
		controller.dismiss(animated: true, completion: nil)
	}
}

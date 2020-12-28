//
//  TNCreditsViewController.swift
//  mmmaze
//
//  Created by mugx on 22/09/2019.
//  Copyright © 2019 mugx. All rights reserved.
//

import Foundation
import MessageUI

@objcMembers
class TNCreditsViewController: UIViewController {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var logoIconImage: UIImageView!
    @IBOutlet var sendFeedbackButton: UIButton!
    @IBOutlet var backButton: UIButton!

    static func create() -> TNCreditsViewController {
        let aboutViewController = TNCreditsViewController(nibName: nil, bundle: nil)
        return aboutViewController
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        versionLabel.text = "v\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!)"
        sendFeedbackButton.layer.borderColor = Constants.magentaColor.cgColor
        sendFeedbackButton.layer.borderWidth = 2.0
        logoIconImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        logoIconImage.layer.shadowColor = Constants.magentaColor.withAlphaComponent(0.4).cgColor
        backButton.layer.borderColor = Constants.magentaColor.cgColor
        backButton.layer.borderWidth = 2.0;
    }

    //MARK: - Actions

    @IBAction func backTouched() {
        MXAudioManager.sharedInstance()?.play(SoundType.STSelectItem.rawValue)
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
        else {
            //    UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Cannot send the email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            //    [gameOverAlert show];
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension TNCreditsViewController: MFMailComposeViewControllerDelegate {
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

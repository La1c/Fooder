//
//  SettingsTableViewController.swift
//  Fooder
//
//  Created by Vladimir on 25.12.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class SettingsTableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowIntolerances"{
            if let navigationVC = segue.destination as? UINavigationController,
               let destinationVC = navigationVC.viewControllers[0] as? IntolerancesTableViewController{
                    destinationVC.delegate = self
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 0, indexPath.row == 0{
            //Send email
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else{
                self.showSendMailErrorAlert()
            }
        }
    }
    
    func configureSubtitleText(with: Results<Intolerance>){
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        
        var subtitleText:String
        switch with.count {
        case 0:
            subtitleText = "No Intolerances"
        case 1:
            subtitleText = with[0].name
        case 2:
            subtitleText = with[0].name + ", " + with[1].name
        default:
            subtitleText = with[0].name + ", " + with[1].name + " and \(with.count - 2) more"
        }
        cell?.detailTextLabel?.text = subtitleText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSubtitleText(with: realm.objects(Intolerance.self).filter("status == true"))
    }
}

extension SettingsTableViewController: IntolerancesTableViewControllerDelegate{
    func userFinishedChoosingIntolerances(chosen: Results<Intolerance>) {
        configureSubtitleText(with: chosen)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -email compose view controller
extension SettingsTableViewController: MFMailComposeViewControllerDelegate{
    func configuredMailComposeViewController() -> MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["fooder.feedback@gmail.com"])
        mailComposerVC.setSubject("Fooder feedback")
        mailComposerVC.setMessageBody("Hello!\nI have some thoughts about Fooder:", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please check your internet connection, email configuration and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

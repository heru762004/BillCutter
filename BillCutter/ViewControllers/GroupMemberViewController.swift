//
//  GroupMemberViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 10/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import ContactsUI
import RxSwift

class GroupMemberViewController: ParentViewController {
    
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var addMemberBarButton: UIBarButtonItem!
    
    var groupId = -1
    var groupMembers = [GroupMember]()
    var contactPicker: CNContactPickerViewController?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMemberBarButton.target = self
        addMemberBarButton.action = #selector(addMemberButtonOnTap(sender:))
        membersTableView.tableFooterView = UIView()
        
        loadMembers()
    }
    
    @objc func addMemberButtonOnTap(sender: UIBarButtonItem) {

        contactPicker = CNContactPickerViewController()
        contactPicker!.delegate = self
        contactPicker!.displayedPropertyKeys = [CNContactPhoneNumbersKey]

        var listPN: [String] = []
        groupMembers.forEach { (groupMember) in
            listPN.append(groupMember.handphone)
        }
        if listPN.count > 0 {
            var listPredicate: [NSPredicate] = []
            for i in 0..<listPN.count {
                let predicate2 = NSPredicate(
                    format: "NOT (self.phoneNumbers.'value'.'digits' CONTAINS[c] %@)", listPN[i])
                listPredicate.append(predicate2)
            }
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: listPredicate)
            contactPicker!.predicateForEnablingContact = predicate
        }
        present(contactPicker!, animated: true, completion: nil)
    }
    
    private func loadMembers() {
        showLoading { () in
            GroupMemberApiService.shared.getGroupMember(groupId: self.groupId)
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] groupMember in
                    self?.dismiss(animated: true, completion: {
                        self?.groupMembers = groupMember
                        self?.membersTableView.reloadData()
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func addMember(name: String, phone: String) {
        showLoading { () in
            GroupMemberApiService.shared.addMember(groupId: self.groupId, name: name, phone: phone)
                .catchError { _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] apiResultStatus in
                    self?.dismiss(animated: true, completion: {
                        if apiResultStatus.success {
                            self?.loadMembers()
                        } else if let weakSelf = self {
                            ViewUtil.showAlert(controller: weakSelf, message: apiResultStatus.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func removeMember(memberId: Int) {
        showLoading { () in
            GroupMemberApiService.shared.removeMember(groupId: self.groupId, memberId: memberId)
                .catchError { _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] apiResultStatus in
                    self?.dismiss(animated: true, completion: {
                        if apiResultStatus.success {
                            self?.loadMembers()
                        } else if let weakSelf = self {
                            ViewUtil.showAlert(controller: weakSelf, message: apiResultStatus.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
}

extension GroupMemberViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = "\(contact.givenName) \(contact.familyName)"
        let phoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
        dismiss(animated: true) {
            self.addMember(name: name, phone: phoneNumber)
        }
    }
}

extension GroupMemberViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberViewCell", for: indexPath)
        cell.textLabel?.text = "\(groupMembers[indexPath.row].name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "\(groupMembers[indexPath.row].handphone)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < groupMembers.count else { return }
            removeMember(memberId: groupMembers[indexPath.row].id)
        }
    }
}

//
//  GroupSummaryViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 11/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class GroupSummaryViewController: ParentViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var groupReceipt = GroupReceipt()
    var groupMembers = [GroupMember]()
    var selectedIdx = -1

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Group Summary"
        tableView.tableFooterView = UIView()
        loadMembers()
    }
    
    private func loadMembers() {
        showLoading { () in
//            if self.groupReceipt.listReceipt[self.selectedIdx].listDetail.count > 0 {
//                GroupMemberApiService.shared.getGroupMember(groupId: self.groupReceipt.id, receiptHeaderId: self.groupReceipt.listReceipt[self.selectedIdx].listDetail[0].receiptHdrId)
                
//            }
            GroupMemberApiService.shared.getGroupMember(groupId: self.groupReceipt.id)
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] groupMember in
                    self?.dismiss(animated: true, completion: {
                        self?.groupMembers = groupMember
                        self?.tableView.reloadData()
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func sendNotification(memberId: Int) {
        showLoading {
            NotificationApiService.shared.sendNotification(groupMemberId: "\(memberId)", receiptId: "\(self.groupReceipt.id)")
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] statusResponse in
                    guard let weakSelf = self else { return }
                    self?.dismiss(animated: true, completion: {
                        if statusResponse.success {
                            ViewUtil.showAlert(controller: weakSelf, message: "Notification sent!")
                        } else {
                            weakSelf.showErrorMessage(errorCode: "", errorMessage: statusResponse.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
    }
}

extension GroupSummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member = groupMembers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSummaryViewCell", for: indexPath)
        cell.textLabel?.text = "\(member.name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "$\(member.totalOwe)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        
        if member.statusPayment == "NOT PAY" {
            cell.imageView?.image = UIImage.init(named: "unpaid")
        } else {
            cell.imageView?.image = UIImage.init(named: "paid")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < groupMembers.count else { return nil }
        let member = groupMembers[indexPath.row]

        if member.statusPayment == "NOT COMPLETED" {
            let action = UIContextualAction(style: .normal, title: title,
                                            handler: { [weak self] (action, view, completionHandler) in
                                                self?.sendNotification(memberId: member.id)
                                                completionHandler(true)
            })

            action.image = UIImage(named: "notification")
            action.backgroundColor = .green
            let configuration = UISwipeActionsConfiguration(actions: [action])
            return configuration
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

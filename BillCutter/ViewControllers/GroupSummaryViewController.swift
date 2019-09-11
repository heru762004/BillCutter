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
    
    var groupId = -1
    var groupMembers = [GroupMember]()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        loadMembers()
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
                        self?.tableView.reloadData()
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
}

extension GroupSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberViewCell", for: indexPath)
        cell.textLabel?.text = "\(groupMembers[indexPath.row].name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "\(groupMembers[indexPath.row].totalpayment)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            guard indexPath.row < groupMembers.count else { return }
//            removeMember(memberId: groupMembers[indexPath.row].id)
        }
    }
}

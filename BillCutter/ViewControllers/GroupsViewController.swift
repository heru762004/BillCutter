//
//  CreateGroupsViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 25/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class GroupsViewController: ParentViewController {
    
    @IBOutlet weak var tableGroup: UITableView!
    
    var groups: [GroupReceipt] = []
    var selectedGroupId = -1

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableGroup.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        groups = GroupDataController.shared.getAllGroups()
//        tableGroup.reloadData()
        loadAllGroup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupReceiptHeader" {
            guard let destinationViewController = segue.destination as? GroupReceiptHeaderViewController, let groupReceipt = sender as? GroupReceipt else { return }
            destinationViewController.groupReceipt = groupReceipt
            destinationViewController.selectedGroupId = self.selectedGroupId
        }
    }

    @IBAction func doCreateGroup(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateGroup", sender: nil)
    }
    
    // MARK: -
    
    private func loadAllGroup() {
        self.showLoading { () in
            GroupReceiptApiService.shared.getGroupList()
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] groupList in
                    self?.dismiss(animated: true, completion: {
                        let sortedGroup = groupList.sorted { $0.id > $1.id }
                        self?.groups = sortedGroup
                        self?.tableGroup.reloadData()
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func loadGroupReceiptView(groupReceipt: GroupReceipt) {
        performSegue(withIdentifier: "showGroupReceiptHeader", sender: groupReceipt)
    }
    
    private func deleteGroup(groupId: Int) {
        showLoading { () in
            GroupReceiptApiService.shared.deleteGroup(groupId: groupId)
                .catchError { _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] apiResultStatus in
                    self?.dismiss(animated: true, completion: {
                        if apiResultStatus.success {
                            self?.loadAllGroup()
                        } else if let weakSelf = self {
                            ViewUtil.showAlert(controller: weakSelf, message: apiResultStatus.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
    }
    
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupViewCell", for: indexPath)
        cell.textLabel?.text = "\(groups[indexPath.row].name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "$\(groups[indexPath.row].spendingAmt)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < groups.count else { return }
        selectedGroupId = groups[indexPath.row].id
        GroupReceiptApiService.shared.getGroupReceipt(id: selectedGroupId)
            .catchError {  _ in
                ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                return Observable.empty()
            }
            .subscribe(onNext: { [weak self] groupReceipt in
                guard let weakSelf = self else { return }
                groupReceipt.receiptHdrId = weakSelf.groups[indexPath.row].receiptHdrId
                weakSelf.loadGroupReceiptView(groupReceipt: groupReceipt)
            }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < groups.count else { return }
            deleteGroup(groupId: groups[indexPath.row].id)
        }
    }
}

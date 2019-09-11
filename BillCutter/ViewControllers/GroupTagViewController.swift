//
//  GroupTagViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 3/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class GroupTagViewController: ParentViewController {

    @IBOutlet weak var tableGroup: UITableView!
    
    var groups: [GroupReceipt] = []
    var groupMember: [GroupMember] = []
    var tagMembers: [TagMember] = []
    var itemName: String?
    var itemPrice: Float = 0.0
    var receiptId: String?
    var selectedGroupId: String?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Choose Group"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        super.viewDidLoad()
        loadAllGroup()
        // Do any additional setup after loading the view.
//        groups = GroupDataController.shared.getAllGroups()
        
        //tableGroup.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.showLoading()
//        ListGroupApiService.shared.sendRequest(onSuccess: { (successResult) in
//            self.dismiss(animated: true, completion: {
//
//            })
//        }) { (error) in
//            self.dismiss(animated: true, completion: {
//                self.showErrorMessage(errorCode: error.errorCode, errorMessage: error.errorMessage)
//            })
//        }
    }
    
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
                    self?.onLoadSuccess(groupList: groupList)
                }).disposed(by: self.disposeBag)
        }
    }
    
    private func onLoadSuccess(groupList: [GroupReceipt]) {
        self.dismiss(animated: true, completion: {
            self.groups = groupList
            self.tableGroup.reloadData()
        })
    }
    
    private func onLoadGroupMembers(groupMember: [GroupMember]) {
        self.dismiss(animated: true, completion: {
            self.groupMember = groupMember
            self.tagMembers.removeAll()
            print("GroupMember count = \(self.groupMember.count)")
            for i in 0..<self.groupMember.count {
                let tgMember = TagMember()
                tgMember.id = self.groupMember[i].id
                self.tagMembers.append(tgMember)
                print("Group member name = \(self.groupMember[i].name)")
                print("Group member phone = \(self.groupMember[i].handphone)")
                print("Group member id = \(self.groupMember[i].id)")
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateReceiptItem() {
//        let items = ItemDataController.shared.getAllItem()
//        var counter = 0
//        for item in items {
//            var twoDecimalPlaces = ""
//            if item.price >= 0.0 {
//                twoDecimalPlaces = String(format: "%.2f", item.price)
//            } else {
//                twoDecimalPlaces = String(format: "%.2f", item.price)
//                twoDecimalPlaces = twoDecimalPlaces.replacingOccurrences(of: "-", with: "")
//                twoDecimalPlaces = String(format: "-%@", twoDecimalPlaces)
//            }
//
//            ReceiptApiService.shared.addReceipt(receiptHdrId: self.receiptId!, itemName: item.name, itemAmount: twoDecimalPlaces, members: self.tagMembers)
//                .catchError {  _ in
//                    self.dismiss(animated: true, completion: {
//                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
//                    })
//                    return Observable.empty()
//                }
//                .subscribe(onNext: {[weak self] statusResponse in
//                    if statusResponse.success {
//                        if counter < items.count {
//                            self?.sendOweNotification()
//                        }
//                        counter+=1
//                    }
//                }).disposed(by: self.disposeBag)
//        }
        self.sendOweNotification()
    }
    
    func sendOweNotification() {
        print("sendOweNotification")
        self.showLoading {
            NotificationApiService.shared.sendNotification(groupId: self.selectedGroupId!, receiptId: self.receiptId!)
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] statusResponse in
                    self?.dismiss(animated: true, completion: {
                        if statusResponse.success {   self?.navigationController?.popToRootViewController(animated: true)
                        } else {
                            self?.showErrorMessage(errorCode: "", errorMessage: statusResponse.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
    }

    @IBAction func doSave(_ sender: Any) {
        
        if self.groupMember.count > 0 && self.selectedGroupId != nil {
            self.showLoading {
                ReceiptApiService.shared.attachReceipt(groupId: self.selectedGroupId!, receiptId: self.receiptId!)
                    .catchError {  _ in
                        self.dismiss(animated: true, completion: {
                            ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                        })
                        return Observable.empty()
                    }
                    .subscribe(onNext: {[weak self] statusResponse in
                        self?.dismiss(animated: true, completion: {
                            if statusResponse.error == false {
                                self?.sendOweNotification()
                            }
                        })
                    }).disposed(by: self.disposeBag)
            }
        } else {
            self.showErrorMessage(errorCode: "", errorMessage: "Group does not have any member!")
        }
        
    }
        
}

extension GroupTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = "\(groups[indexPath.row].name)"
//        print("Label TEXT = \(cell.textLabel!.text)")
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
//        cell.detailTextLabel?.text = "\(groups[indexPath.row].spendingAmt)"
//        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < groups.count else { return }
        let groupId = groups[indexPath.row].id
        self.selectedGroupId = "\(groupId)"
        self.showLoading {
            GroupMemberApiService.shared.getGroupMember(groupId: groupId)
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] groupMember in
                    self?.onLoadGroupMembers(groupMember: groupMember)
                }).disposed(by: self.disposeBag)
        }
    }
}

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
    var itemName: String?
    var itemPrice: Float = 0.0
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doSave(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    }
}

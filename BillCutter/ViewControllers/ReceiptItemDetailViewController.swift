//
//  ReceiptItemViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 26/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class ReceiptItemDetailViewController: ParentViewController  {
    
    @IBOutlet weak var itemNamelabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var paidByLabel: UILabel!
    @IBOutlet weak var splitingMethodLabel: UILabel!
    @IBOutlet weak var tagMemberList: UITableView!
    
    var paidBy = ""
    var groupId = -1
    var receiptItem = ReceiptItem()
    var receiptDetailItem = ReceiptDetailItem()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        paidByLabel.text = paidBy
        itemNamelabel.text = receiptItem.name
        itemPriceLabel.text = "\(receiptItem.total)"
        splitingMethodLabel.text = receiptItem.splitType
        tagMemberList.tableFooterView = UIView()
        
        getItemDetail(receiptHeaderId: receiptItem.receiptHdrId, itemId: receiptItem.id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupMember" {
            guard let destinationViewController = segue.destination as? GroupMemberViewController else { return }
            destinationViewController.groupId = groupId
            destinationViewController.isSelectionMode = true
            destinationViewController.setSelectionDelegate { (userSelectedId) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                    self.addTagMember(userId: userSelectedId)
                })
            }
        }
    }
    
    @IBAction func addTagButtonOnClick(_ sender: Any) {
        
    }
    
    private func addTagMember(userId: Int) {
        let tagMember = TagMember()
        tagMember.id = userId
        self.receiptDetailItem.tagMembers.append(tagMember)
        
        showLoading { () in
            ReceiptApiService.shared.updateReceiptItemDetail(receiptHdrId: self.receiptItem.receiptHdrId, id: self.receiptItem.id, name: self.receiptDetailItem.name, price: Float(self.receiptDetailItem.price), total: Float(self.receiptDetailItem.total), amount: self.receiptDetailItem.amount, tagMembers: self.receiptDetailItem.tagMembers)
                .catchError { _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] apiResultStatus in
                    guard let weakSelf = self else { return }
                    weakSelf.dismiss(animated: true, completion: {
                        weakSelf.getItemDetail(receiptHeaderId: weakSelf.receiptItem.receiptHdrId, itemId: weakSelf.receiptItem.id)
                        
                    })
                }).disposed(by: self.disposeBag)
        }
    }
 
    private func getItemDetail(receiptHeaderId: Int, itemId: Int) {
        ReceiptApiService.shared.getReceiptItemDetail(receiptHeaderId: receiptHeaderId, itemId: itemId)
            .catchError {  _ in
                self.dismiss(animated: true, completion: {
                    ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                })
                return Observable.empty()
            }
            .subscribe(onNext: {[weak self] itemDetail in
                self?.receiptDetailItem = itemDetail
                self?.tagMemberList.reloadData()
            }).disposed(by: self.disposeBag)
    }
    
}

extension ReceiptItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("\(receiptDetailItem.tagMembers.count)")
        return receiptDetailItem.tagMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceitpItemDetailViewCell", for: indexPath)
        cell.textLabel?.text = "\(receiptDetailItem.tagMembers[indexPath.row].name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < receiptDetailItem.tagMembers.count else { return }
        }
    }
}

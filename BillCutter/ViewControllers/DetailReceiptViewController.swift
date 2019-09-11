//
//  DetailReceiptViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 19/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class DetailReceiptViewController: ParentViewController {
    
    @IBOutlet weak var tableReceipt: UITableView!
    var items: [Item] = []
    var selectedIdx = -1
    var typeEditor = 0
    var receiptId = ""
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Review Items"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        items = ItemDataController.shared.getAllItem()
        self.tableReceipt.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let navController = segue.destination as? UINavigationController {
            if let detailReceipt = navController.viewControllers.first as? ModifyDetailReceiptViewController {
                detailReceipt.items = items
                detailReceipt.type = self.typeEditor
                print(selectedIdx)
                detailReceipt.selectedIdx = selectedIdx
            }
        } else if let viewController = segue.destination as? GroupTagViewController {
            viewController.receiptId = self.receiptId
        }
        
    }
    

    @objc func priceButtonTapped(sender: UIButton!) {
        self.typeEditor = ModifyDetailReceiptViewController.TYPE_EDIT
        selectedIdx = sender.tag
        self.performSegue(withIdentifier: "goToModifyDetailReceipt", sender: nil)
    }
    
    @objc func deleteButtonTapped(sender: UIButton!) {
        
        self.items.remove(at: sender.tag)
        ItemDataController.shared.removeItemAtIndex(idx: sender.tag)
        self.tableReceipt.reloadData()
    }
    
    @IBAction func showAddItem(_ sender: Any) {
        self.typeEditor = ModifyDetailReceiptViewController.TYPE_ADD
        self.performSegue(withIdentifier: "goToModifyDetailReceipt", sender: nil)
    }
    
    @IBAction func showAssignTo(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Receipt Title", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Receipt Title"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let receiptTitle = alertController.textFields![0] as UITextField
            if receiptTitle.text != nil && receiptTitle.text!.count > 0 {
                var listItem: [ReceiptDetailItem] = []
                for item in self.items {
                    let myItem = ReceiptDetailItem()
                    myItem.name = item.name
                    var twoDecimalPlaces = ""
                    if item.price >= 0.0 {
                        twoDecimalPlaces = String(format: "%.2f", item.price)
                    } else {
                        twoDecimalPlaces = String(format: "%.2f", item.price)
                        twoDecimalPlaces = twoDecimalPlaces.replacingOccurrences(of: "-", with: "")
                        twoDecimalPlaces = String(format: "-%@", twoDecimalPlaces)
                    }
                    myItem.price = twoDecimalPlaces
                    myItem.amount = "1"
                    myItem.total = twoDecimalPlaces
                    listItem.append(myItem)
                }
                self.showLoading {
                    ReceiptApiService.shared.createReceipt(receiptTitle: receiptTitle.text!, receiptItem: listItem)
                        .catchError {  _ in
                            self.dismiss(animated: true, completion: {
                                ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                            })
                            return Observable.empty()
                        }
                        .subscribe(onNext: {[weak self] result in
                            self?.dismiss(animated: true, completion: {
                                if result.success {
                                    print("Receipt ID = \(result.id)")
                                    self?.receiptId = "\(result.id)"
                                    self?.performSegue(withIdentifier: "goToAssignGroup", sender: nil)
                                } else {
                                    self?.showErrorMessage(errorCode: "", errorMessage: result.message)
                                }
                            })
                        }).disposed(by: self.disposeBag)
                }
                
            }

        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })


        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)

    }
}

extension DetailReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! DetailReceiptTableViewCell
        cell.itemName.text = items[indexPath.row].name
        var twoDecimalPlaces = ""
        if items[indexPath.row].price >= 0.0 {
            twoDecimalPlaces = String(format: "$%.2f", items[indexPath.row].price)
        } else {
            twoDecimalPlaces = String(format: "%.2f", items[indexPath.row].price)
            twoDecimalPlaces = twoDecimalPlaces.replacingOccurrences(of: "-", with: "")
            twoDecimalPlaces = String(format: "-$%@", twoDecimalPlaces)
        }
        cell.buttonPrice.setTitle(twoDecimalPlaces, for: .normal)
        cell.buttonPrice.tag = indexPath.row
        
        // add target to button price, so user can change the price
        cell.buttonPrice.addTarget(self, action: #selector(priceButtonTapped), for: UIControl.Event.touchUpInside)
        
        cell.buttonDelete.tag = indexPath.row
        // Add target to the deleteButton so that the row can be deleted when tapped
        cell.buttonDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

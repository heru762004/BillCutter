//
//  ScanViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 15/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var processor: ScaledElementProcessor?
    
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.imagePicker.dismiss(animated: true) {
            self.showLoading()
            guard let image = self.imageView.image else { return }
            
            DispatchQueue.global().async() {
                
                let img2 =  image.fixedOrientation()
                let img3 = img2.scaledImage(3000) ?? img2
                // add GPUImage processing to improve the detection
                let preprocessedImage = img3.preprocessedImage() ?? img3
                
                DispatchQueue.main.async{
                    self.imageView.image = preprocessedImage
                }
                
                if self.processor == nil {
                    self.processor = ScaledElementProcessor()
                }
                if self.processor != nil {
                    self.processor?.process(in: preprocessedImage) { text in
                        DispatchQueue.main.async{
                            self.dismiss(animated: true, completion: {
                                //self.showAlert(message: text)
                                self.items = text
                                self.performSegue(withIdentifier: "goToReceiptScanResult", sender: self)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            //                self.storeDataToDB(keyValue: "0", keyName: self.IS_REGISTERED)
//            self.navigationController?.dismiss(animated: true, completion: nil)
            self.imagePicker.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if imagePicker == nil {
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
            }
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func showLibrary(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            if imagePicker == nil {
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
            }
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToReceiptScanResult" {
            if let detailReceipt = segue.destination as? DetailReceiptViewController {
                detailReceipt.items = items
            }
        }
    }

}

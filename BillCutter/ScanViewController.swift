//
//  ScanViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 15/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    var myImage: UIImage!
    var processor: ScaledElementProcessor?
    var isCameraCancelPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isCameraCancelPressed == false {
            if imagePicker == nil {
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
            }
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        isCameraCancelPressed = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCameraCancelPressed = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isCameraCancelPressed = true
        self.showLoading()
        myImage = info[.originalImage] as? UIImage
        if let img = myImage {
            myImage = img.fixedOrientation()
            if let img2 = myImage {
                myImage = img2.scaledImage(1000) ?? img2
            }
        }
        guard let image = myImage else { return }
        DispatchQueue.global().async() {
            if self.processor == nil {
                self.processor = ScaledElementProcessor()
            }
            if self.processor != nil {
                self.processor?.process(in: image) { text in
                    DispatchQueue.main.async{
                        self.dismiss(animated: true, completion: {
                            self.showAlert(message: text)
                        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

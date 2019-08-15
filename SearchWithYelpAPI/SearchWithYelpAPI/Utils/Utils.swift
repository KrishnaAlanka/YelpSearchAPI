//
//  Utils.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation
import UIKit


class Utils {
    //Can use this over all to app and easy to use Alert view.
    class func showAlertWithOkAction(title: String,
                                     message: String,
                                     viewController: UIViewController,
                                     okTapped:@escaping () -> Void) {
        //As this is UI update so making this main thread
        DispatchQueue.main.async {
            //set the title, message and type to UIAlertController
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            //Setting the action
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default) { _ in
                                            okTapped()
            })
            //Presention on the viewcontroller passed
            viewController.present(alert, animated: true) { () -> Void in
            }
        }
    }
    
}

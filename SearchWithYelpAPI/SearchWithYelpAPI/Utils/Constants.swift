//
//  Constants.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import Foundation

// Storyboard name
enum Storyboard: String {
    case main                           = "Main"
}

//All the URL to call and retrive data
struct ServiceUtility {
    static let Authorization              = "Authorization"
    static let limit                      = 50
    //Have to encript and save this Token
    static let AuthorizationCode          = "Bearer ZaUZIGV_7JmeifTorCBnbI3W-PG8ylewpf2iQUoNmwUAPde7mCC8O_Q0IlWkf4C348LMOU9EjZoMwjp0YB_C0EVefd7BGcx-BeGy5IUSWJKtMxJJjqI3LP2zkcxRXXYx"
    static let serviceURL                 = "https://api.yelp.com/v3/businesses/search?"
}

//Error Messages
struct ErrorMessage {
    static let alertTitle          = "Error"
    static let defaultError        = "Some thing went Wrong"
    static let alertDismissTitle   = "Dismiss"
    static let jsonParsingError     = "Failed to parse Json"
    static let noControllerWithIdentifier   = "No view controller with identifier"
}

struct CellIdentifier {
    static let customTableViewCell           = "CustomCell"
}


//
//  ViewController.swift
//  SearchWithYelpAPI
//
//  Created by Krishna  on 8/13/19.
//  Copyright © 2019 Krishna . All rights reserved.
//

import UIKit

class YelpSearchViewContrioller : UIViewController {

     var viewModel: YelpSearchViewModel?
    @IBOutlet var EmptyResultView: EmptySearchView!
    @IBOutlet var hederView: summaryHeader!
    @IBOutlet weak var searchViewHieghtConstarint: NSLayoutConstraint!
    @IBOutlet weak var locationLbl: UITextField!
    @IBOutlet weak var termLbl: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView : InstagramActivityIndicator?

    var offsetVal = 0
    var pickerDatsource = ["OBGYn","Physical-Therapist","General-Physician","Cardiologist"]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initial View SetUp
        intialSetup()
        //Initialize viewModel
         viewModel = YelpSearchViewModel()
        self.navigationController?.isNavigationBarHidden = false 
    }
    
    func intialSetup() {
        self.searchViewHieghtConstarint.constant = 0.0
        self.view.layoutIfNeeded()
        displayTableHeader(show: false)
        EmptyResultView.message.text = "Please search for medical Profession"
        tableView.backgroundView = EmptyResultView
        let searchPicker = UIPickerView()
        searchPicker.backgroundColor = UIColor.gray
        searchPicker.delegate = self
        termLbl.inputView = searchPicker
        activityView?.stopAnimating()
    }
    @IBAction func showSearchTapped(_ sender: Any) {
        showSearchView(show: true)
    }

    private func getSearchResults(searchTerm: String? , location: String?, offsetValue: Int? ) {
        
        viewModel?.getSearchResults(location: location, searchText: searchTerm, offset: offsetVal, completion: { (error) in
            if error == nil {
                
                if let totalRecords = self.viewModel?.yelpSearchdata?.total,let businesse = self.viewModel?.business.count, let businessResponse = self.viewModel?.businessResponse {
                    self.offsetVal = businessResponse
                    if  self.offsetVal <= 999 && totalRecords > businesse && self.viewModel?.yelpSearchdata?.businesses.count != 0   {
                        self.getSearchResults(searchTerm: searchTerm, location: location, offsetValue: self.offsetVal)
                    }else {
                        self.hederView.totalResultLbl.text = "\(self.viewModel?.totalNumberOfPtsInSearchArea ?? 0)"
                        self.hederView.resultsWithRatingLbl.text = "\(self.viewModel?.totalNumberOfPtsWithRatting ?? 0)"
                        self.hederView.avgRatingLbl.text =  String(format: "%.01f", self.viewModel?.averageRattingforPtsInArea ?? 0)
                        self.hederView.totalReviewsCount.text = "\(self.viewModel?.totalNumberOfreviews ?? 0)"
                        
                        //Reload the table with updated data
                        DispatchQueue.main.async {
                            self.activityView?.stopAnimating()
                            self.tableView.backgroundView = nil
                            self.showSearchView(show: false)
                            self.displayTableHeader(show: true)
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.activityView?.stopAnimating()
                    //  Any failute throw the alert
                    self.EmptyResultView.message.text = error?.localizedDescription ?? ErrorMessage.defaultError
                    self.tableView.backgroundView = self.EmptyResultView
                    self.tableView.reloadData()
                    self.displayTableHeader(show: false)
                }
                Utils.showAlertWithOkAction(title: ErrorMessage.alertTitle,
                                            message:  error?.localizedDescription ?? ErrorMessage.defaultError,
                                            viewController: self,
                                            okTapped: {self.okTapped()})
            }
        })
        
    }
    
    func okTapped() {
        //Dismiss the alertView
        self.dismiss(animated: true, completion: nil)
    }
 
    
    func showSearchView(show:Bool) {
        if show {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchViewHieghtConstarint.constant = 150.0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchViewHieghtConstarint.constant = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func displayTableHeader(show: Bool) {
        if show {
            tableView.tableHeaderView = hederView
            tableView.sectionHeaderHeight = 160
        } else {
            tableView.tableHeaderView = nil
            tableView.sectionHeaderHeight = 0
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        termLbl.resignFirstResponder()
        locationLbl.resignFirstResponder()
        showSearchView(show: false)
    }
    @IBAction func searchTapped(_ sender: Any) {
        if self.termLbl.text == "" {
            Utils.showAlertWithOkAction(title: ErrorMessage.alertTitle,
                                        message:  "Please select the search Term",
                                        viewController: self,
                                        okTapped: {self.okTapped()})
        }else if self.locationLbl.text == "" {
            Utils.showAlertWithOkAction(title: ErrorMessage.alertTitle,
                                        message:  "Please enter the location",
                                        viewController: self,
                                        okTapped: {self.okTapped()})
        }
        else {
            activityView?.startAnimating()
            resetAllObjects()
            getSearchResults(searchTerm: self.termLbl.text, location: self.locationLbl.text, offsetValue: 0)
        }
    }
    
    func resetAllObjects() {
        viewModel?.business.removeAll()
        viewModel?.businessResponse = 0
        self.offsetVal = 0
        termLbl.resignFirstResponder()
        locationLbl.resignFirstResponder()
    }
    
}

extension YelpSearchViewContrioller: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

}

extension YelpSearchViewContrioller: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.customTableViewCell,
                                                       for: indexPath) as? CustomTableViewCell else {
                                                        return UITableViewCell()
        }
         cell.configure(with: viewModel?.business(at: indexPath.row))
        return cell
    }
    
}

extension YelpSearchViewContrioller: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDatsource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerDatsource[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerDatsource[row]
        let myTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        termLbl.text = pickerDatsource[row]
    }
    
}


class summaryHeader: UIView {
    @IBOutlet weak var totalResultLbl: UILabel!
    @IBOutlet weak var resultsWithRatingLbl: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var totalReviewsCount: UILabel!
}

class EmptySearchView: UIView {
    @IBOutlet weak var message: UILabel!
}


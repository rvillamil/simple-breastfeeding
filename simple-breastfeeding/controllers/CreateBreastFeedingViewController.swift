//
//  CreateBreastFeedingViewController.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 29/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//
//
//  DetailViewController.swift
//  masterdetail
//
//  Created by Rodrigo Villamil Pérez on 29/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import UIKit

class CreateBreastFeedingViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txtBeginDate: UITextField!
    @IBOutlet weak var lblBeginDate: UILabel!
    
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var lblEndDate: UILabel!
    
    @IBOutlet weak var txtDuration: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btnCheckLeftBreast: UIButton!
    @IBOutlet weak var btnCheckRightBreast: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Internal vars
    var breastFeedingStaticsStore    = BreastFeedingStaticsStore()
    var leftBreastSelected   = false
    var rightBreastSelected  = false
    var defaultTextFieldFont: UIFont!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.l18n()
        self.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - My functions
    func configView() {
        // Get default font from text field. Set in storyboard
        self.defaultTextFieldFont = txtBeginDate.font
        // Display cancel and save button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(save(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        // DatePicker
        self.datePicker.isHidden = true
        self.datePicker.datePickerMode = .dateAndTime
        // Date time text fields
        self.txtBeginDate.isUserInteractionEnabled = true
        self.txtBeginDate.text = SimpleDateFormatter.dateToString(Date())
        self.txtEndDate.isUserInteractionEnabled = true
        self.txtEndDate.text = SimpleDateFormatter.dateToString(Date())
    }
    
    func l18n () {
        self.navigationItem.title = NSLocalizedString(
            "additem.scence.title", comment: "")
        self.lblBeginDate.text = NSLocalizedString(
            "labelBeginDate.text", comment: "")
        self.lblEndDate.text = NSLocalizedString(
            "labelEndDate.text", comment: "")
        self.lblDuration.text = NSLocalizedString(
            "labelDuration.text", comment: "")
      
    }
   
    func updateView(){
        self.txtDuration.text
            = SimpleDateFormatter.durationBetweenStringDates(
                strDateFrom: self.txtBeginDate.text!,
                strDateTo: self.txtEndDate.text!)
    }
    
    func swapTextFieldFonts(_ textFieldSelected: UITextField,
                            _ textFieldNormal: UITextField){
        textFieldSelected.font = UIFont.boldSystemFont(ofSize: (self.txtBeginDate.font?.pointSize)!)
        textFieldNormal.font = self.defaultTextFieldFont
    }
    
    
    @objc
    func save(_ sender: Any) {
        
        let beginDate = SimpleDateFormatter.stringToDate(txtBeginDate.text!)
        let endDate = SimpleDateFormatter.stringToDate(txtEndDate.text!)
        let duration = SimpleDateFormatter.durationBetweenStringDatesAsInt(
            strDateFrom:txtBeginDate.text!,
            strDateTo: txtEndDate.text!)
        /*
        print ("beginDate: \(beginDate), endDate: \(endDate), duration: \(duration), rightBreastSelected: \(self.rightBreastSelected), leftBreastSelected: \(self.leftBreastSelected)")
        */
        if (duration <= 0) {
            showDialogWrongDuration()
            return
        }
        if (endDate > Date()) {
            showDialogBackToTheFuture()
            return
        }
        if (self.rightBreastSelected) {
            breastFeedingStaticsStore.insert( beginDateTime:beginDate ,
                endDateTime: endDate,
                chestRight: true,
                duration: duration)
        }
        if (self.leftBreastSelected) {
            breastFeedingStaticsStore.insert( beginDateTime:beginDate ,
                                              endDateTime: endDate,
                                              chestRight: false,
                                              duration: duration)
         
        }
        if (!self.leftBreastSelected) && (!self.rightBreastSelected) {
                showDialogBreastNotSelected()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showDialogBackToTheFuture() {
        let alert = UIAlertController(
            title: NSLocalizedString(
                "dialogBackToTheFuture.title", comment: ""),
            message:NSLocalizedString(
                "dialogBackToTheFuture.message", comment: ""),
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler:nil))
        
        self.present(alert, animated: true)
        
    }
    func showDialogBreastNotSelected () {
        
        let alert = UIAlertController(
            title: NSLocalizedString(
                "dialogBreastNotSelected.title", comment: ""),
            message:NSLocalizedString(
                "dialogBreastNotSelected.message", comment: ""),
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler:nil))
        
        self.present(alert, animated: true)
    }
    
    func showDialogWrongDuration () {
        
        let alert = UIAlertController(
            title: NSLocalizedString(
                "dialogBreastWrongDuration.title", comment: ""),
            message:NSLocalizedString(
                "dialogBreastWrongDuration.message", comment: ""),
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler:nil))
        
        self.present(alert, animated: true)
    }
    
  
    
    // MARK: - Actions
    @IBAction func touchInBeginDateTime(_ sender: Any) {
        self.datePicker.isHidden = false
        self.txtBeginDate.isUserInteractionEnabled = false
        self.txtEndDate.isUserInteractionEnabled = true
        self.swapTextFieldFonts (self.txtBeginDate, self.txtEndDate)
   
        self.lblStatus.text =  NSLocalizedString(
            "touchInBeginDateTime.message", comment: "")
    }
    // MARK: - Actions
    @IBAction func touchInEndDateTime(_ sender: Any) {
        self.datePicker.isHidden = false
        self.txtEndDate.isUserInteractionEnabled = false
        self.txtBeginDate.isUserInteractionEnabled = true
        self.swapTextFieldFonts (self.txtEndDate, self.txtBeginDate)
        
        self.lblStatus.text =  NSLocalizedString(
            "touchInEndDateTime.message", comment: "")
    }
    
    @IBAction func touchInRightBreast(_ sender: Any) {
        if !self.btnCheckRightBreast.isSelected {
            self.rightBreastSelected = true
            self.lblStatus.text =  NSLocalizedString(
                "touchInRightBreast.message", comment: "")
        } else {
            self.rightBreastSelected = false
            self.lblStatus.text = ""
        }
        self.btnCheckRightBreast.isSelected = !self.btnCheckRightBreast.isSelected
    }
    
    @IBAction func touchInLeftBreast(_ sender: Any) {

        if !self.btnCheckLeftBreast.isSelected {
            self.leftBreastSelected = true
            self.lblStatus.text =  NSLocalizedString(
                "touchInLeftBreast.message", comment: "")
        } else {
            self.leftBreastSelected = false
            self.lblStatus.text = ""
        }
        self.btnCheckLeftBreast.isSelected = !self.btnCheckLeftBreast.isSelected
    }
    
    @IBAction func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let selectedDate = SimpleDateFormatter.dateToString(datePicker.date)
        if !txtBeginDate.isUserInteractionEnabled {
            self.txtBeginDate.text = selectedDate
        }
        if !txtEndDate.isUserInteractionEnabled {
            self.txtEndDate.text = selectedDate
        }
        self.updateView()
    }
}


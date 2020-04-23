//
//  SearchMoviesViewController.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import UIKit

class SearchMoviesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueEditor: UITextField!
    @IBOutlet weak var movieSeriesPicker: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var screenDescription: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSeriesTitle: UILabel!
    var pickerView: UIPickerView!
    let pickerViewItems: [String] = ["movie", "series", "episodes"]
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        // the user pressed submit button. Transition to search result screen.
        performSegue(withIdentifier: "segueToSearchResult", sender: nil)
    }
    
    @IBAction func clickedOutsidePickerView(_ sender: UITapGestureRecognizer) {
        // Dsimiss the picker view when the user taps outside of it.
        if movieSeriesPicker.isFirstResponder {
            movieSeriesPicker.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MovieSearchScreen.viewTitle".localized
        screenDescription.text = "MovieSearchScreen.viewDescription".localized
        movieTitle.text = "MovieSearchScreen.movieTitle".localized
        movieSeriesTitle.text = "MovieSearchScreen.moviePickerTitle".localized
        

        // Configure submit button.
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blue.cgColor
        submitButton.isEnabled = false
        submitButton.setTitle("MovieSearchScreen.submitButtonTitle".localized,
                              for: .normal)
        // Configure moview title editor.
        titleValueEditor.delegate = self
        titleValueEditor.addTarget(self, action: #selector(editorDidChanged), for: .editingChanged)
        
        // Create and configure picker view when the user taps on TV/Series editor
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        movieSeriesPicker.inputView = pickerView
        movieSeriesPicker.delegate = self
        movieSeriesPicker.textAlignment = .center
        movieSeriesPicker.tintColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSearchResult" {
            // Create a view model for SearchMoviesResultViewController to use
            // when it loads.
            if let destinationVC = segue.destination as? SearchMoviesResultViewController {
                destinationVC.viewModel = SearchMoviesResultViewModel(title: titleValueEditor.text!,
                                                                      movieType: movieSeriesPicker.text!,
                                                                      client: SearchMoviewResultClient())
            }
        }
    }
    
    @objc
    func editorDidChanged(textField: UITextField) {
        // This function is called every time the user types in
        // title of the movie. Since this field is required field
        // we disable submit button when this field is empty.
        if textField.text == "" {
            enableSubmutButton(enable: false)
        } else {
            enableSubmutButton(enable: true)
        }
    }
    
    private func enableSubmutButton(enable: Bool) {
        submitButton.isEnabled = enable
    }
}

extension SearchMoviesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Since the movie pikcer editor creates a picker view we don't allow
        //  user to type in movieSeriesPicker editor
        if textField == movieSeriesPicker {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        // Enable "Return" key to dismiss a keyboard.
        textField.resignFirstResponder()
        return true
    }
}

// The cod below creates and confiures the picker view.
extension SearchMoviesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewItems.count
    }
}

extension SearchMoviesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return pickerView.bounds.size.width
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    
        var customView: UILabel
        if view == nil {
            customView = UILabel()
        } else {
            customView = view as! UILabel
        }
        
        customView.text = pickerViewItems[row]
        customView.textAlignment = .center
        let size = pickerView.rowSize(forComponent: component)
        customView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: size.width, height: size.height)
        
        return customView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        movieSeriesPicker.text = pickerViewItems[row]
        movieSeriesPicker.resignFirstResponder()
    }
}


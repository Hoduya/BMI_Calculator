//
//  ViewController.swift
//  BMI_Calculator
//
//  Created by HoJun on 2022/09/17.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var heigthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    var bmiManager = BMICalculatorManager()
    
    var bmi: Double?
    var adviceString: String?
    var bmiColor: UIColor?
    
    func configureUI() {
        heigthTextField.delegate = self
        weightTextField.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.9321654319, green: 0.9252404467, blue: 0.7937848456, alpha: 1)
        mainLabel.text = "키와 몸무게를 입력해 주세요"
        calcButton.clipsToBounds = true
        calcButton.layer.cornerRadius = 5
        calcButton.setTitle("BMI 계산하기", for: .normal)
        heigthTextField.placeholder = "cm 단위로 입력해주세요"
        weightTextField.placeholder = "kg 단위로 입력해주세요"
    }
    
    @IBAction func calcButtonTapped(_ sender: UIButton) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if heigthTextField.text == "" || weightTextField.text == "" {
            mainLabel.text = "키와 몸무게 입력이 필요합니다."
            mainLabel.textColor = .red
            return false
        }
        mainLabel.text = "키와 몸무게를 입력해 주세요"
        mainLabel.textColor = .black
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultVC" {
            let resultVC = segue.destination as! ResultViewController
            
            guard let w = weightTextField.text,
                  let h = heigthTextField.text else {return}
            
            resultVC.bmi = bmiManager.getBMI(height: h, weight: w)
        }
        
        heigthTextField.text = ""
        weightTextField.text = ""
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Int(string) != nil {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if heigthTextField.text != "", weightTextField.text != "" {
            weightTextField.resignFirstResponder()
        } else if heigthTextField.text != "" {
            weightTextField.becomeFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heigthTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
}

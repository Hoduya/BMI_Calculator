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
        guard let w = weightTextField.text,
              let h = heigthTextField.text else {return}
        
        bmi = calculateBMI(height: h, weight: w)
        bmiColor = getBackgroundColor()
        adviceString = getBMIAdviceString()
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
            
            resultVC.bmi = self.bmi
            resultVC.bmiColor = self.bmiColor
            resultVC.adviceString = self.adviceString
        }
        
        heigthTextField.text = ""
        weightTextField.text = ""
    }
    
    func calculateBMI(height: String, weight: String) -> Double {
        guard let h = Double(height), let w = Double(weight) else { return 0.0 }
        var bmi = w / (h * h) * 10000
        bmi = round(bmi * 10) / 10
        
        return bmi
    }
    
    // 색깔 얻는 메서드
    func getBackgroundColor() -> UIColor {
        guard let bmi = bmi else { return UIColor.black }
        switch bmi {
        case ..<18.6:
            return UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1)
        case 18.6..<23.0:
            return UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
        case 23.0..<25.0:
            return UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1)
        case 25.0..<30.0:
            return UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1)
        case 30.0...:
            return UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1)
        default:
            return UIColor.black
        }
    }
    
    // 문자열 얻는 메서드
    func getBMIAdviceString() -> String {
        guard let bmi = bmi else { return "" }
        switch bmi {
        case ..<18.6:
            return "저체중"
        case 18.6..<23.0:
            return "표준"
        case 23.0..<25.0:
            return "과체중"
        case 25.0..<30.0:
            return "중도비만"
        case 30.0...:
            return "고도비만"
        default:
            return ""
        }
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

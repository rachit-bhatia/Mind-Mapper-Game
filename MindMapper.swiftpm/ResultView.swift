//
//  ResultView.swift
//  Rachit's App_2
//
//  Created by Rachit on 19/03/2023.
//

import UIKit
import SwiftUI

class ResultViewController: UIViewController {
    
    let cameraView: CameraView
    
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    var textR: UITextView! = nil
    var textBoundary: UIView! = nil
    var gradientBackground: CAGradientLayer! = nil
    var retryButton: UIButton! = nil
    var screenRect = UIScreen.main.bounds
    var viewRect: CGRect! = nil
    var level1_completed = false
    var level2_completed = false
    
    
    init(cameraView: CameraView) {
        self.cameraView = cameraView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        
        view.frame = CGRect(x: 0, y: (screenRect.size.height)/2, width: screenRect.size.width, height: (screenRect.size.height)/2 + 45)
        viewRect = view.bounds
        
        self.displayBG()
        self.dispHomeButton()
        self.dispRetryButton()
        self.level_1_initial()
        
        self.level1_completed = false
        self.level2_completed = false
        self.cameraView.level1_running = false
        self.cameraView.level2_running = false
        self.cameraView.level3_running = false
        self.cameraView.resultDisplayed = false
        

        
    }
    
    func displayBG(){
        //        screenRect = UIScreen.main.bounds
        gradientBackground = CAGradientLayer()
        gradientBackground.frame = view.frame
        gradientBackground.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        gradientBackground.cornerRadius = 20
        view.layer.addSublayer(gradientBackground)
    }
    
    func dispHomeButton(){
        let homeButton = UIButton(type: .system)
        homeButton.setBackgroundImage(UIImage(systemName: "house.circle"), for: .normal)
        homeButton.tintColor = UIColor.black
        homeButton.frame = CGRect(x: 20, y: screenRect.size.height-75, width: 55, height: 55)
        homeButton.addTarget(self,action: #selector(backToHome), for: .touchUpInside)
        view.addSubview(homeButton)
        
    }
    
    //UIButton selector requires function to be exposed to Objective-C
    @objc func backToHome(){
        UIView.animate(withDuration: 0.4, animations: {
            self.view.alpha = 0 }, completion: { finished in
                self.cameraView.captureSession.stopRunning()
                self.cameraView.view.removeFromSuperview()
                self.view.removeFromSuperview()
            })
        
        let homePage = HomeViewController()
        homePage.isModalInPresentation = true
        homePage.modalPresentationStyle = .overCurrentContext
        homePage.modalTransitionStyle = .coverVertical
        
        present(homePage, animated: true, completion: nil)
        
    }
    
    func dispRetryButton (){
        retryButton = UIButton(type: .system)
        retryButton.setBackgroundImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        retryButton.tintColor = UIColor.black
        retryButton.frame = CGRect(x: screenRect.size.width-75, y: screenRect.size.height-75, width: 55, height: 55)
        retryButton.addTarget(self,action: #selector(level_1_initial), for: .touchUpInside)
        retryButton.isEnabled = false   //button is disabled
        retryButton.alpha = 0.5         //reducing opacity to show disabled effect
        view.addSubview(retryButton)
    }
    
    
    func dispMainText(textLine1: String, textLine2: String, lineSize1: CGFloat, lineSize2: CGFloat, numOfLines: Int) -> UILabel{
        
        //splitting into two different lines of text
        let textLine1 = textLine1
        let textLine2 = textLine2
        
        let fullText = NSMutableAttributedString(string: textLine1)
        fullText.append(NSAttributedString(string: textLine2))
        fullText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: lineSize1), range: NSRange(location: 0, length: textLine1.count))
        fullText.addAttribute(.font, value: UIFont.systemFont(ofSize: lineSize2), range: NSRange(location: textLine1.count, length: textLine2.count))
        
        let textLabel = UILabel(frame: CGRect(x: 0, y: (screenRect.size.height)/2, width: viewRect.size.width, height: 400))
        
        //attributed text is used to apply for multiple text formatting to a single UIlabel
        textLabel.attributedText = fullText
        textLabel.numberOfLines = numOfLines        //no of lines of text displayed
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.white
        view.addSubview(textLabel)
        
        textLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // Animate the label's entry by scaling it up to its final size
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            textLabel.transform = CGAffineTransform.identity
        }, completion: nil)
        
        return textLabel
    }
    
    
    func dispTaskText(addedText: String) -> UITextView{
        let taskText = UITextView(frame: CGRect(x: 0, y: (screenRect.size.height)/1.5, width: viewRect.size.width, height: 40))
        taskText.text = addedText
        taskText.font = .boldSystemFont(ofSize: 30)
        taskText.textAlignment = .center
        taskText.textColor = UIColor.white
        taskText.backgroundColor = .clear   //needed for gradient colour's visibility
        
        return taskText
    }
    
    
    @objc func level_1_initial() {
        
        self.level1_completed = false
        self.cameraView.level1_running = false
        self.cameraView.resultDisplayed = false
        
        //cleaning out any previously placed views
        for subview in self.view.subviews{
            if subview is UIButton{
                continue
            }
            else{
                subview.removeFromSuperview()}
        }
        
        let textLine1 = "Level 1: Exact Match\n"
        let textLine2 = "Act exactly as the symbols"
        
        let lvlIntro = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 35, lineSize2: 30, numOfLines: 2)
        
        //button updates are UI updates so need to be made on the main queue
        DispatchQueue.main.async {
            self.retryButton.isEnabled = false
            self.retryButton.alpha = 0.5
        }
        
        //disappearing animation to occur after a set time
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, animations: {
                lvlIntro.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                lvlIntro.alpha = 0
            }, completion: { (finished: Bool) in
                lvlIntro.removeFromSuperview()
                self.level_1_main()
            })
        }
    }
    
    func level_1_main(){
        
        let textLine1 = "Memorise the sequence: \n"
        let textLine2 = "1️⃣  5️⃣  3️⃣      "
        
        let lvlMain = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 50, numOfLines: 2)
        
        let taskText = self.dispTaskText(addedText: "Now count the numbers!!!")
        
        //      disappearing animation to occur after a set time
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1, animations: {
                lvlMain.alpha = 0
            }, completion: { (finished: Bool) in
                lvlMain.removeFromSuperview()
                self.view.addSubview(taskText)
                
                taskText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    taskText.transform = .identity
                }, completion: nil)
                
                self.retryButton.isEnabled = true
                self.retryButton.alpha = 1
                self.cameraView.level1_running = true
            })
        }
    }
    
    
    @objc func level_2_initial(){
        
        self.level2_completed = false
        self.level1_completed = false
        self.cameraView.level2_running = false
        self.cameraView.resultDisplayed = false
        
        for subview in self.view.subviews{
            if subview is UIButton{
                continue
            }
            else{
                subview.removeFromSuperview()}
        }
        
        let textLine1 = "Level 2: Reverse Match\n"
        let textLine2 = "Act opposite to the symbols"
        
        DispatchQueue.main.async { [self] in
            self.retryButton.removeTarget(self,action: #selector(level_1_initial), for: .touchUpInside)
            self.retryButton.addTarget(self,action: #selector(level_2_initial), for: .touchUpInside)
            self.retryButton.isEnabled = false
            self.retryButton.alpha = 0.5
        }
        
        let lvlIntro = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 32, lineSize2: 30, numOfLines: 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, animations: {
                lvlIntro.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                lvlIntro.alpha = 0
            }, completion: { (finished: Bool) in
                lvlIntro.removeFromSuperview()
                self.level_2_intermediate()
            })
        }
    }
    
    func level_2_intermediate(){
        let textLine1 = "Memorise the symbol-num keys: \n\n"
        let textLine2 = "🌟 → 1️⃣\n⚽️ → 4️⃣\n🧲 → 3️⃣\n🍎 → 2️⃣             "
        
        let lvlMain = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 40, numOfLines: 8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1, animations: {
                lvlMain.alpha = 0
            }, completion: { (finished: Bool) in
                lvlMain.removeFromSuperview()
                self.level_2_main()
            })
        }
    }
    
    func level_2_main(){
        let textLine1 = "Memorise the sequence: \n"
        let textLine2 = "⚽️  🍎  🧲  🌟      "
        
        let lvlMain = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 40, numOfLines: 2)
        
        let taskText = self.dispTaskText(addedText: "Now count the numbers!!!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1, animations: {
                lvlMain.alpha = 0
            }, completion: { (finished: Bool) in
                lvlMain.removeFromSuperview()
                self.view.addSubview(taskText)
                taskText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    taskText.transform = .identity
                }, completion: nil)
                
                self.retryButton.isEnabled = true
                self.retryButton.alpha = 1
                self.cameraView.level2_running = true
            })
        }
    }
    
    
    @objc func level_3_initial(){
        
        self.level2_completed = false
        self.cameraView.level3_running = false
        self.cameraView.resultDisplayed = false
        
        for subview in self.view.subviews{
            if subview is UIButton{
                continue
            }
            else{
                subview.removeFromSuperview()}
        }
        
        let textLine1 = "Level 3: Jumbled Match\n"
        let textLine2 = "Use your memory skills"
        
        DispatchQueue.main.async { [self] in
            self.retryButton.removeTarget(self,action: #selector(level_2_initial), for: .touchUpInside)
            self.retryButton.addTarget(self,action: #selector(level_3_initial), for: .touchUpInside)
            self.retryButton.isEnabled = false
            self.retryButton.alpha = 0.5
        }
        
        let lvlIntro = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 32, lineSize2: 30, numOfLines: 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, animations: {
                lvlIntro.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                lvlIntro.alpha = 0
            }, completion: { (finished: Bool) in
                lvlIntro.removeFromSuperview()
                self.level_3_intermediate()
            })
        }
    }
    
    //34125
    func level_3_intermediate(){
        let textLine1 = "Memorise the symbol-num and num-num keys: \n\n"
        let textLine2 = "🛎 → 1️⃣\n📕 → 5️⃣\n🎮 → 3️⃣\n7️⃣ → 4️⃣\n8️⃣ → 2️⃣                              "
        
        let lvlMain = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 40, numOfLines: 10)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1, animations: {
                lvlMain.alpha = 0
            }, completion: { (finished: Bool) in
                lvlMain.removeFromSuperview()
                self.level_3_main()
            })
        }
    }
    
    func level_3_main(){
        let textLine1 = "Memorise the sequence: \n"
        let textLine2 = "🎮  7️⃣  🛎  8️⃣  📕           "
        
        let lvlMain = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 40, numOfLines: 2)
        
        let taskText = self.dispTaskText(addedText: "Now count the numbers!!!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 1, animations: {
                lvlMain.alpha = 0
            }, completion: { (finished: Bool) in
                lvlMain.removeFromSuperview()
                self.view.addSubview(taskText)
                taskText.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    taskText.transform = .identity
                }, completion: nil)
                
                self.retryButton.isEnabled = true
                self.retryButton.alpha = 1
                self.cameraView.level3_running = true
            })
        }
    }
    
    
    func displayCorrectResult(){
        
        //cleaning out any previously placed views
        for subview in self.view.subviews{
            if subview is UIButton{
                continue
            }
            else{
                subview.removeFromSuperview()}
        }
        
        DispatchQueue.main.async {
            self.retryButton.isEnabled = false
            self.retryButton.alpha = 0.5
        }
        
        let textLine1 = "Good Job!\n"
        let textLine2 = "You move to the next level"
        
        let result = self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 30, numOfLines: 2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 1, animations: {
                result.frame.origin.y = self.view.frame.height
            }, completion: { (finished: Bool) in
                result.removeFromSuperview()
                if self.level1_completed == true{
                    self.level_2_initial()
                }
                else if self.level2_completed == true{
                    self.level_3_initial()
                }
            })
        }
    }
    
    
    func displayFinalMessage(){
        
        //cleaning out any previously placed views
        for subview in self.view.subviews{
            if subview is UIButton{
                continue
            }
            else{
                subview.removeFromSuperview()}
        }
        
        DispatchQueue.main.async {
            self.retryButton.isEnabled = false
            self.retryButton.alpha = 0.5
        }
        
        let textLine1 = "Good Job!\n"
        let textLine2 = "You have cleared the Game"
        
        self.dispMainText(textLine1: textLine1, textLine2: textLine2, lineSize1: 30, lineSize2: 30, numOfLines: 2)
    }
    
    func displayTick (){
        
        let tickMark = UITextView(frame: CGRect(x: 0, y: (screenRect.size.height)/1.4, width: viewRect.size.width, height: 40))
        tickMark.text = "✅"
        tickMark.font = .boldSystemFont(ofSize: 30)
        tickMark.textAlignment = .center
        tickMark.textColor = UIColor.white
        tickMark.backgroundColor = .clear
        view.addSubview(tickMark)
        
        tickMark.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            tickMark.transform = .identity
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                tickMark.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } , completion: nil)
            
        }
        
    }
}


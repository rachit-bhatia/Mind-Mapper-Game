//
//  HomeViewController.swift
//  Rachit's App_2
//
//  Created by Rachit on 12/04/2023.


import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    private let screenRect = UIScreen.main.bounds
    private var gradientBackground: CAGradientLayer! = nil
    
    var htpView: UIView = UIView()
    var htpButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayBg()
        dispStartButton()
        dispHtpButton()
//        howToPlayView()
    }
    
    
    func displayBg(){
        gradientBackground = CAGradientLayer()
        gradientBackground.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        gradientBackground.colors = [UIColor.blue.cgColor, UIColor.systemMint.cgColor, UIColor.systemPink.cgColor]
        view.layer.addSublayer(gradientBackground)
    }
    
    func dispStartButton(){
        let startButton = UIButton(type: .system)
        startButton.frame = CGRect(x: screenRect.size.width/3, y: screenRect.size.height/2, width: 220, height: 80)
        startButton.center = self.view.center
        startButton.setTitle("Let's Begin!", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 32)
        startButton.backgroundColor = UIColor.systemPink
        startButton.layer.cornerRadius = 20
        startButton.addTarget(self,action: #selector(changeView), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    func dispHtpButton (){
        htpButton = UIButton(type: .system)
        htpButton.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        htpButton.tintColor = UIColor.black
        htpButton.frame = CGRect(x: screenRect.size.width - 75, y: screenRect.size.height - 75, width: 55, height: 55)
        htpButton.addTarget(self,action: #selector(howToPlayView), for: .touchUpInside)
        view.addSubview(htpButton)
    }
    
    @objc func howToPlayView(){
        
        self.htpButton.removeFromSuperview()
        //main htp view setup
        htpView = UIView()
        
        htpView.frame = CGRect(x: 20, y: 0, width: screenRect.size.width - 40, height: screenRect.size.height - 130)
        htpView.layer.frame = htpView.frame
        
        //gradient background setup
        let gradientColour = CAGradientLayer()
        gradientColour.frame = CGRect(x: 0, y: 0, width: screenRect.size.width - 40, height: screenRect.size.height - 130)
        gradientColour.colors = [ UIColor.purple.cgColor, UIColor.brown.cgColor]
        gradientColour.cornerRadius = 25
        
        htpView.layer.addSublayer(gradientColour)
        htpView.layer.cornerRadius = 25
        view.addSubview(htpView)
        
        //close button setup
        let closeButton = dispCloseButton(htpView: htpView)
        htpView.addSubview(closeButton)
        
        //entry animation for htp view
        htpView.frame.origin.y = screenRect.size.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.htpView.frame.origin.y = 80     // Translate the view to its original position
        }, completion: nil)
        
        //title text setup
        let textLine1 = "Mind Mapper\n\n"
        let title = NSMutableAttributedString(string: textLine1)
        title.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 40), range: NSRange(location: 0, length: textLine1.count))
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 40, width: htpView.frame.size.width - 20, height: 50))
        
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        htpView.addSubview(titleLabel)
        
        //intro text setup
        let textLine2 = "Welcome to a twisted version of the classic memory game. Tired of sticking your fingers to your mouse and keyboard all day? It's time to give your fingers a break!"

        let fullText = NSMutableAttributedString(string: textLine2)
        fullText.addAttribute(.font, value: UIFont.systemFont(ofSize: 23), range: NSRange(location: 0, length: textLine2.count))

        let textLabel = UILabel(frame: CGRect(x: 20, y: 85, width: htpView.frame.size.width - 40, height: 180))

        textLabel.attributedText = fullText
        textLabel.numberOfLines = 10
        textLabel.textAlignment = .justified
        textLabel.textColor = UIColor.white
        htpView.addSubview(textLabel)


        //htp text setup
        let textLine3 = "How to Play?\n\n"
        let htpTitle = NSMutableAttributedString(string: textLine3)
        htpTitle.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 30), range: NSRange(location: 0, length: textLine1.count))
        
        let htpTitleLabel = UILabel(frame: CGRect(x: 10, y: 305, width: htpView.frame.size.width - 20, height: 40))
        
        htpTitleLabel.attributedText = htpTitle
        htpTitleLabel.numberOfLines = 1
        htpTitleLabel.textAlignment = .center
        htpTitleLabel.textColor = UIColor.white
        htpView.addSubview(htpTitleLabel)
        
        //instructions text setup
        let textLine4 = """
Memorise the sequence of numbers and count using your fingers

~ Level 1: The exact number sequence will be displayed\n
~ Level 2: Number sequence will be replaced by symbol keys\n
~ Level 3: Number sequence will be replaced by symbol keys and unique number keys\n
"""
            
        let fullText2 = NSMutableAttributedString(string: textLine4)
        fullText2.addAttribute(.font, value: UIFont.systemFont(ofSize: 23), range: NSRange(location: 0, length: textLine4.count))

        let textLabel2 = UILabel(frame: CGRect(x: 20, y: 330, width: htpView.frame.size.width - 40, height: 400))

        textLabel2.attributedText = fullText2
        textLabel2.numberOfLines = 30
        textLabel2.textAlignment = .justified
        textLabel2.textColor = UIColor.white
        htpView.addSubview(textLabel2)
    }
    
    func dispCloseButton(htpView: UIView) -> UIButton{
        let closeButton = UIButton(type: .system)
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.tintColor = UIColor.red
        closeButton.frame = CGRect(x: htpView.frame.width - 40, y: 15, width: 32, height: 30)
        closeButton.addTarget(self,action: #selector(close_htpView), for: .touchUpInside)
        return closeButton
    }
    
    @objc func close_htpView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.htpView.frame.origin.y = self.screenRect.size.height}, completion: { finished in
        self.htpView.removeFromSuperview()})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispHtpButton()
        }
    }
    
    @objc func changeView(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0 }, completion: { finished in
        self.view.removeFromSuperview()})
        
        ///self.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        let secondPage = CameraView()
        secondPage.isModalInPresentation = true
        secondPage.modalPresentationStyle = .overCurrentContext
        secondPage.modalTransitionStyle = .coverVertical
        present(secondPage, animated: true, completion: nil)
    }
    

}

struct HostHomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return HomeViewController()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}

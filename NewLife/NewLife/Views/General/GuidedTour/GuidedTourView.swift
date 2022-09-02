//
//  GuidedTourView.swift
//  Tawazon
//
//  Created by mac on 21/08/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

struct StepInfo
{
    let view:UIView
    let position: CGRect
    let textInfo:(title: String,description: String)
    let isBelow:Bool
    let isSameHierarchy: Bool
}

class GuidedTourView: UIView {

    var infoView: UIView!
    
    var steps: [StepInfo] = [StepInfo](){
        didSet{
            showSteps()
        }
    }

    var screenName: String = ""
    var currentStepIndex = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
    }
    func addStep(step: StepInfo) {
        steps.append(step)
    }
    
    func resetSteps(){
        steps = []
    }
    
    func showSteps(){
        guard !steps.isEmpty else{
            return
        }
        print("currentStepIndex: \(currentStepIndex)")
        createInfoView(for: steps[currentStepIndex], isBelow: steps[currentStepIndex].isBelow)
    }
    
    func hideSteps(){
        self.recursiveSubviews.forEach({$0.removeFromSuperview()})
        self.removeFromSuperview()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("nextButtonTapped: \(currentStepIndex == (steps.count - 1))")
        self.recursiveSubviews.forEach({$0.removeFromSuperview()})
//        infoView.removeFromSuperview()
        currentStepIndex = currentStepIndex == (steps.count - 1) ?  0 : (currentStepIndex + 1)
        if currentStepIndex == 0 {
            print("HIDE")
            hideSteps()
            return
        }
        showSteps()
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        print("skipButtonTapped")
        TrackerManager.shared.sendGuidedTourClosed(isAllSteps: currentStepIndex == (steps.count - 1) ? true : false,
                                                   viewName: screenName, stepTitle: steps[currentStepIndex].textInfo.title)
        hideSteps()
    }
    
    func createInfoView(for step: StepInfo, isBelow: Bool){
        var arrowImage : UIImage = UIImage(named: "GuidedTourInfoViewArrowUp")!
        print("forView: \(step.view)")
        print("isBelow: \(isBelow) step.position: \(step.position)")
        infoView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 40, height: 200))
        infoView.backgroundColor = .slateBlue
        infoView.roundCorners(corners: .allCorners, radius: 16.0)
        self.addSubview(infoView)

        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        infoView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        if isBelow {
            //bellow targeted view
            
            if step.isSameHierarchy{
                infoView.topAnchor.constraint(equalTo: step.view.bottomAnchor, constant: 20).isActive = true
            }else{
                infoView.topAnchor.constraint(equalTo: self.topAnchor , constant: 20 + step.view.frame.size.height + step.view.frame.maxY).isActive = true
            }
            
        }else{
            //above
//            step.view.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 20).isActive = true
            self.bottomAnchor.constraint(equalTo: infoView.bottomAnchor , constant: 60 + step.position.height).isActive = true
            arrowImage = UIImage(named: "GuidedTourInfoViewArrowDown")!
        }
        
        // add arrow
        let arrowImageView = UIImageView(image: arrowImage)
        self.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowImageViewConstraint = isBelow ? arrowImageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: 1) : infoView.bottomAnchor.constraint(equalTo: arrowImageView.topAnchor, constant: 1)
        arrowImageViewConstraint.isActive = true
        
//        let point = window?.rootViewController?.view.convert(step.view.frame, to: step.view.superview)
        print("step.view.frame.minX: \(step.position.origin.x + ((step.position.width/2) - (arrowImageView.frame.width/2)))")
        
        if step.isSameHierarchy{
            arrowImageView.centerXAnchor.constraint(equalTo: step.view.centerXAnchor, constant: 0).isActive = true
        }else{
            arrowImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: step.position.origin.x + ((step.position.width/2) - (arrowImageView.frame.width/2))).isActive = true
        }
        
        
        
        // add foucus circle
        let focusView = UIView(frame: CGRect(x: 0, y: 0, width: step.view.frame.width, height: step.view.frame.height))
        
        
        
        focusView.roundCorners(corners: .allCorners, radius: 24.0)
        self.addSubview(focusView)
        focusView.translatesAutoresizingMaskIntoConstraints = false
        print("focusView.heightAnchor: \(step.view.frame.height)")
        focusView.heightAnchor.constraint(equalToConstant: step.view.frame.height).isActive = true
        focusView.widthAnchor.constraint(equalToConstant: step.view.frame.width).isActive = true
        if step.isSameHierarchy{
            focusView.centerXAnchor.constraint(equalTo: step.view.centerXAnchor, constant: 0).isActive = true
            focusView.centerYAnchor.constraint(equalTo: step.view.centerYAnchor, constant: 0).isActive = true
        }else{
            if isBelow {
                //bellow targeted view
                focusView.topAnchor.constraint(equalTo: self.topAnchor , constant: 8 + step.position.origin.y + step.position.height).isActive = true
                
            }else{
                //above
                self.bottomAnchor.constraint(equalTo: focusView.bottomAnchor , constant: step.position.origin.y).isActive = true
            }
            focusView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: step.position.origin.x).isActive = true
            
        }
        print("focusView.frame: \(focusView.frame)")
        let overlayLayer = CALayer()
        overlayLayer.frame = focusView.frame
        overlayLayer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        overlayLayer.compositingFilter = "darkenBlendMode"
        focusView.layer.addSublayer(overlayLayer)
        
        // add details
        let descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        descriptionLabel.font = .munaFont(ofSize: 18)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.text = step.textInfo.description
        infoView.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 24).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 24).isActive = true
        infoView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 24).isActive = true
        
        
        // add actions
        let actionsView = UIView()
        actionsView.backgroundColor = .clear
        infoView.addSubview(actionsView)
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        actionsView.heightAnchor.constraint(equalTo: infoView.heightAnchor, multiplier: 0.3).isActive = true
        actionsView.widthAnchor.constraint(equalTo: infoView.widthAnchor, multiplier: 1).isActive = true
        actionsView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 0).isActive = true
        
            //separator line
        let horizontalLine = UILabel()
        horizontalLine.text = ""
        horizontalLine.backgroundColor = .white.withAlphaComponent(0.2)
        actionsView.addSubview(horizontalLine)
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        horizontalLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        horizontalLine.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 1).isActive = true
        horizontalLine.topAnchor.constraint(equalTo: actionsView.topAnchor, constant: 0).isActive = true
        
            //buttons
        let nextButton = UIButton()
        nextButton.tintColor = .white
        nextButton.setTitle("GuidedTourNextButton".localized, for: .normal)
        nextButton.titleLabel?.font = .munaBoldFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        
        let closeButton = UIButton()
        closeButton.tintColor = .white
        closeButton.setTitle("GuidedTourSkipButton".localized, for: .normal)
        closeButton.titleLabel?.font = .munaBoldFont(ofSize: 20)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        
        
            //stack of buttons
        let actionsStackView = UIStackView()
        actionsStackView.axis = .horizontal
        actionsStackView.distribution = .fillProportionally
        actionsStackView.spacing = 1
        
        
        actionsView.addSubview(actionsStackView)
        actionsStackView.translatesAutoresizingMaskIntoConstraints = false
        actionsStackView.widthAnchor.constraint(equalTo: actionsView.widthAnchor, multiplier: 1).isActive = true
        actionsStackView.heightAnchor.constraint(equalTo: actionsView.heightAnchor, constant: -1).isActive = true
        actionsStackView.bottomAnchor.constraint(equalTo: actionsView.bottomAnchor, constant: 0).isActive = true
        
        //vertical separator line
        let verticalLine = UILabel()
        verticalLine.text = "|"
        verticalLine.backgroundColor = .white.withAlphaComponent(0.2)
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        if currentStepIndex != (steps.count - 1) {
            actionsStackView.addArrangedSubview(nextButton)
        }else{
            actionsStackView.removeArrangedSubview(nextButton)
        }
        
        actionsStackView.addArrangedSubview(verticalLine)
        actionsStackView.addArrangedSubview(closeButton)
//        verticalLine.heightAnchor.constraint(equalTo: actionsStackView.heightAnchor).isActive = true
        
        // add pages
        let pageControl = UIPageControl()
        pageControl.numberOfPages = steps.count
        pageControl.currentPage = currentStepIndex
        infoView.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: infoView.centerXAnchor, constant: 0).isActive = true
        actionsView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5).isActive = true
        
        
    }
}
// add foucus circle
//let focusView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
//focusView.backgroundColor = .white.withAlphaComponent(0.5)
//focusView.roundCorners(corners: .allCorners, radius: 24.0)
//self.addSubview(focusView)
//focusView.translatesAutoresizingMaskIntoConstraints = false
//focusView.heightAnchor.constraint(equalToConstant: 48).isActive = true
//focusView.widthAnchor.constraint(equalToConstant: 48).isActive = true
//focusView.centerXAnchor.constraint(equalTo: arrowImageView.centerXAnchor, constant: 0).isActive = true
//let focusViewYConstraint = isBelow ? focusView.bottomAnchor.constraint(equalTo: arrowImageView.topAnchor, constant: 0) : focusView.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 0)
//focusViewYConstraint.isActive = true


extension UIView
{
    func constrainFill(padding:CGPoint)
    {
        guard superview != nil else {return}
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding.x).isActive = true
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding.y).isActive = true
        trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: padding.x).isActive = true
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: padding.y).isActive = true
    }
}

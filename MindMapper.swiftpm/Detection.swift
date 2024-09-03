//
//  Detection.swift
//  Rachit's App_2
//
//  Created by Rachit on 13/03/2023.
//

import Vision
import AVFoundation
import UIKit

extension CameraView {
    
    func check_level1(fingersCounted: Int){
        print ("\nDetection Array is ", self.detectionArray)
        print ("\n")
        
        if (fingersCounted == 1) && (self.detectionArray.count == 0){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(1)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 5) && (self.detectionArray.count == 1){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(5)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 3) && (self.detectionArray.count == 2){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(3)
            self.resultLayer.displayTick()
        }
        
        if self.detectionArray == [1, 5, 3] {
            self.resultLayer.level1_completed = true
            self.resultLayer.displayCorrectResult()
            self.resultDisplayed = true
            self.level1_running = false
            self.detectionArray = []
        }
    }
    
    
    func check_level2(fingersCounted: Int){
        print ("\nDetection Array is ", self.detectionArray)
        print ("\n")
        
        if (fingersCounted == 4) && (self.detectionArray.count == 0){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(4)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 2) && (self.detectionArray.count == 1){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(2)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 3) && (self.detectionArray.count == 2){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(3)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 1) && (self.detectionArray.count == 3){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(1)
            self.resultLayer.displayTick()
        }
        
        if self.detectionArray == [4, 2, 3, 1] {
            self.resultLayer.level2_completed = true
            self.resultLayer.displayCorrectResult()
            self.resultDisplayed = true
            self.level2_running = false
            self.detectionArray = []
        }
    }
    
    
    func check_level3(fingersCounted: Int){
        print ("\nDetection Array is ", self.detectionArray)
        print ("\n")
        
        if (fingersCounted == 3) && (self.detectionArray.count == 0){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(3)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 4) && (self.detectionArray.count == 1){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(4)
            self.resultLayer.displayTick()
        }
        
        
        if (fingersCounted == 1) && (self.detectionArray.count == 2){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(1)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 2) && (self.detectionArray.count == 3){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(2)
            self.resultLayer.displayTick()
        }
        
        if (fingersCounted == 5) && (self.detectionArray.count == 4){
            print ("Finger Count is: ", fingersCounted)
            self.detectionArray.append(5)
            self.resultLayer.displayTick()
        }
        
        if self.detectionArray == [3, 4, 1, 2, 5] {
            self.resultLayer.displayFinalMessage()
            self.resultDisplayed = true
            self.level3_running = false
            self.detectionArray = []
        }
    }
    
    
    func captureOutput(
      _ output: AVCaptureOutput,
      didOutput sampleBuffer: CMSampleBuffer,
      from connection: AVCaptureConnection
    ) {
        
        var fingerTips: [CGPoint] = []
        
        defer {
          DispatchQueue.main.sync {
            self.processPoints(fingerTips)
          }
        }

      
      let handler = VNImageRequestHandler(
        cmSampleBuffer: sampleBuffer,
        orientation: .up,
        options: [:]
      )

      do {
        
        try handler.perform([handPoseRequest])

        
        guard let results = handPoseRequest.results,
          !results.isEmpty
            
          else {
            return
        }

              var recognizedPoints: [VNRecognizedPoint] = []
              var fingerCount = 0
              try results.forEach { observation in
              
                  let fingers = try observation.recognizedPoints(.all)
              
                  print("finger tip count:", fingers.count)
              
                  
                  var wristPoint = fingers[.wrist]
                  var thumbTip = fingers[.thumbTip]
                  var indexTip = fingers[.indexTip]
                  var middleTip = fingers[.middleTip]
                  var ringTip = fingers[.ringTip]
                  var littleTip = fingers[.littleTip]
                  
                  print ("Thumb Tip Normal Difference: ", thumbTip!.y - wristPoint!.y)
                  print ("Index Tip Normal Difference: ", indexTip!.y - wristPoint!.y)
                  print ("Middle Tip Normal Difference: ", middleTip!.y - wristPoint!.y)
                  print ("Ring Tip Normal Difference: ", ringTip!.y - wristPoint!.y)
                  print ("Little Tip Normal Difference: ", littleTip!.y - wristPoint!.y)
//
                  if (thumbTip!.y - wristPoint!.y > 0.10) && (thumbTip!.y - wristPoint!.y < 0.15) {
                      fingerCount += 1
                      print ("Thumb Tip Difference: ", thumbTip!.y - wristPoint!.y)
                  }
                  if indexTip!.y - wristPoint!.y > 0.30 {
                      fingerCount += 1
                      print ("Index Tip Difference: ", indexTip!.y - wristPoint!.y)
                  }
                  if middleTip!.y - wristPoint!.y > 0.30 {
                      fingerCount += 1
                      print ("Middle Tip Difference: ", middleTip!.y - wristPoint!.y)
                  }
                  if ringTip!.y - wristPoint!.y > 0.30 {
                      fingerCount += 1
                      print ("Ring Tip Difference: ", ringTip!.y - wristPoint!.y)
                  }
                  if littleTip!.y - wristPoint!.y > 0.27 {
                      fingerCount += 1
                      print ("Little Tip Difference: ", littleTip!.y - wristPoint!.y)
                  }

          }
          
          DispatchQueue.main.async{
              if (self.resultDisplayed == false) {
                  if self.level1_running == true {
                      self.check_level1(fingersCounted: fingerCount)
                  }
                  
                  if self.level2_running == true {
                      self.check_level2(fingersCounted: fingerCount)
                  }
                  
                  if self.level3_running == true {
                      self.check_level3(fingersCounted: fingerCount)
                  }
              }
          }

      } catch {
        captureSession.stopRunning()
      }
    }
}


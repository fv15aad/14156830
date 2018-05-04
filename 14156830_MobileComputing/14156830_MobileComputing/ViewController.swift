//
//  ViewController.swift
//  14156830_MobileComputing
//
//  Created by Valentine on 17/04/2018.
//  Copyright © 2018 Valentine. All rights reserved.
//

import UIKit
import AVFoundation

protocol subviewDelegate {
    func collisionBounds()
}

class ViewController: UIViewController, subviewDelegate {
    var bombSoundEffect: AVAudioPlayer?
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var carAnimation: UIDynamicAnimator!
    

    @IBOutlet weak var scoreNo: UILabel!
    @IBOutlet weak var carDragged: DraggedImageView!
    @IBOutlet weak var backgroundRoad: UIImageView!
  
    var delayArray = [ 1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
                       11, 12 ,13, 14, 15, 16, 17, 18, 19, 20]
    

    
    var arrayForScore: [UIImageView] = []
    var scoreNumber = 0
    var carsCompleted: [UIImageView] = []
    
    let gameOver = UIImageView(image: nil)
    let button = UIButton(frame: CGRect(x:150, y:500, width:80, height:50))
    
    var screenHeight = UIScreen.main.bounds.height
    var screenWidth = UIScreen.main.bounds.width
   
    @objc func playButton (sender: UIButton!) {
        gameOver.removeFromSuperview()
        button.removeFromSuperview()
        scoreNumber = 0;
        for i in carsCompleted{
            i.removeFromSuperview()
        }
        viewDidLoad()
    }
    
    func collisionBounds() {
        collisionBehaviour.removeAllBoundaries()
        collisionBehaviour.addBoundary(withIdentifier: "barrier" as
            NSCopying, for: UIBezierPath(rect: carDragged.frame))
        for car in arrayForScore {
            if (carDragged.frame.intersects(car.frame)) {
                scoreNumber = scoreNumber - 1
                self.scoreNo.text = String(self.scoreNumber)
            }
        }
    }
    
    func sound(){
       let path = Bundle.main.path(forResource: "music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func randomObjects() {
        carAnimation = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        collisionBehaviour = UICollisionBehavior(items: [])
        
        for index in 0...19 {
            
            
            let delay = Double(self.delayArray[index])
            let timer = DispatchTime.now() + delay
            
            //let random = Int(arc4random_uniform(UInt32(234))) + 53
            let random = (Int(arc4random_uniform(UInt32(UIScreen.main.bounds.width))) + 53)
            
            DispatchQueue.main.asyncAfter(deadline: timer){
                
                
                
                let cars = UIImageView(image:nil)
                // Dropping random cars
                let rand = Int(arc4random_uniform(6))
                
                switch rand{
                case 1: cars.image = UIImage(named: "car1.png")
                case 2: cars.image = UIImage(named: "car2.png")
                case 3: cars.image = UIImage(named: "car3.png")
                case 4: cars.image = UIImage(named: "car4.png")
                case 5: cars.image = UIImage(named: "car5.png")
                case 6: cars.image = UIImage(named: "car6.png")
                    
                default: cars.image = UIImage(named: "car1")
                }
                
                
                // Size and position of the image view
                cars.frame = CGRect(x:random, y:15, width:40,  height:70)
                self.carsCompleted.append(cars)
                self.view.addSubview(cars)
                self.view.bringSubview(toFront: cars)
                
                self.arrayForScore.append(cars)
                
                self.scoreNumber = (self.scoreNumber + 5)
                self.scoreNo.text = String(self.scoreNumber)
                
                self.dynamicItemBehavior.addItem(cars)
                self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: 0, y: 500), for: cars)
                self.collisionBehaviour.addItem(cars)
                self.collisionBehaviour.translatesReferenceBoundsIntoBoundary = false
                
            }
            
            carAnimation.addBehavior(dynamicItemBehavior)
            self.collisionBehaviour.collisionMode = UICollisionBehaviorMode.everything
            carAnimation.addBehavior(collisionBehaviour)
            
        }
        let when = DispatchTime.now() + 20
        
        DispatchQueue.main.asyncAfter(deadline: when){
            //print("20 seconds")
            self.button.backgroundColor = .blue
            self.button.setTitle("Replay", for: [])
            self.button.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
            self.view.addSubview(self.button)
            
            
            // let gameover = UIImageView(image: nil)
            self.gameOver.image = UIImage(named: "game_over.jpg")
            self.gameOver.frame = UIScreen.main.bounds
            self.view.addSubview(self.gameOver)
            self.view.bringSubview(toFront: self.gameOver)
            self.view.bringSubview(toFront: self.button)
            
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        carDragged.myDelegate = self
        sound()
        var football: [UIImage]!
        
        football = [UIImage(named: "perf0.png")!,
                    UIImage(named: "ship.png")!,
                    UIImage(named: "ship2.png")!]
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        carDragged.image = UIImage.animatedImage(with: football, duration: 0.75)
        carDragged.frame = UIScreen.main.bounds
        carDragged.frame  = CGRect(x: 200, y:300, width:100, height:100)
        
        
        
        //background animation, loop.
        var imageArray: [UIImage]!
        
        imageArray = [UIImage(named: "road1.png")!,
                      UIImage(named: "road2.png")!,
                      UIImage(named: "road3.png")!,
                      UIImage(named: "road4.png")!,
                      UIImage(named: "road5.png")!,
                      UIImage(named: "road6.png")!,
                      UIImage(named: "road7.png")!,
                      UIImage(named: "road8.png")!,
                      UIImage(named: "road9.png")!,
                      UIImage(named: "road10.png")!,
                      UIImage(named: "road11.png")!,
                      UIImage(named: "road12.png")!,
                      UIImage(named: "road13.png")!,
                      UIImage(named: "road14.png")!,
                      UIImage(named: "road15.png")!,
                      UIImage(named: "road16.png")!,
                      UIImage(named: "road17.png")!,
                      UIImage(named: "road18.png")!,
                      UIImage(named: "road19.png")!,
                      UIImage(named: "road20.png")!]
        
        self.view.addSubview(backgroundRoad)
        self.view.sendSubview(toBack: backgroundRoad)
        
        backgroundRoad.image = UIImage.animatedImage(with: imageArray, duration: 2.7)
        //backgroundRoad.frame = UIScreen.main.bounds
        
        // Call randomCar function, that has For loop and collision behaviour.
        randomObjects()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



//
//  ViewController.swift
//  Maze
//
//  Created by Zentaro Imai on 2021/05/11.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var playerView: UIView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    
    let screenSize = UIScreen.main.bounds.size
    
    let maze = [
    
        [1, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 1, 0],
        [3, 0, 1, 0, 1, 0],
        [1, 1, 1, 0, 0, 0],
        [1, 0, 0, 1, 1, 0],
        [0, 0, 1, 0, 0, 0],
        [0, 1, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 1],
        [0, 1, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 2],
    
    
    ]
    
    
    //show start and goal
    
    var startView: UIView!
    var goalView: UIView!
    
    var wallRectArray = [CGRect]()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let cellWidth = screenSize.width / CGFloat(maze[0].count)
        let cellHeight = screenSize.height / CGFloat(maze.count)
        
        //let cellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
        //let cellOffsetY = screenSize.height / CGFloat(maze.count * 2)
        
        
        
       let cellOffsetX = cellWidth / 2
        let cellOffsetY = cellHeight / 2
        
        
        for y in 0 ..< maze.count {
            
            for x in 0 ..< maze[y].count {
                switch maze[y][x]{
                case 1: //当たるとゲームオーバー
                
                    let wallView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    
                    wallView.backgroundColor = UIColor.black
                    
                    view.addSubview(wallView)
                    wallRectArray.append(wallView.frame)
                    
                case 2: //スタート地点
                
                startView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    
                    startView.backgroundColor = UIColor.green
                    
                    view.addSubview(startView)
                    
                case 3: //ゴール地点
                    goalView = creatView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    
                    goalView.backgroundColor = UIColor.red
                    
                    view.addSubview(goalView)
                default:
                    break
                    
                
                }
                
            }
        }
        
        
        
        //playerViewを生成
        
      playerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth / 6, height: cellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        view.addSubview(playerView)
        
        //MotionManagerを生成
        
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        startAccelerometer()
    
        
    }
 
    
    func creatView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UIView{
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
        
        view.center = center
        
        return view
        
        
        
    }
    
    
    func startAccelerometer() {
        
        let handler: CMAccelerometerHandler = {(CMAccelerometerData: CMAccelerometerData?, error: Error?) -> Void in
                                                self.speedX += CMAccelerometerData!.acceleration.x
                                                self.speedY += CMAccelerometerData!.acceleration.y
                                                
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            
            //画面上からはみ出しそうなプレイヤーを修正
            
            if posX <= self.playerView.frame.width / 2 {
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            
            if posY <= self.playerView.frame.width / 2 {
                self.speedY = 0
                posY = self.playerView.frame.width / 2
            }
            if posX >= self.screenSize.width - (self.playerView.frame.width / 2){
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= self.screenSize.width - (self.playerView.frame.width / 2){
                self.speedY = 0
                posY = self.screenSize.width - (self.playerView.frame.width / 2)
            }
                
                for wallRect in self.wallRectArray {
                    if wallRect.intersects(self.playerView.frame){
                        print("Game Over")
                        return
                    }
                }
          
            if self.goalView.frame.intersects(self.playerView.frame){
                print("Clear")
                return
            }
            
            self.playerView.center = CGPoint(x: posX, y: posY)
        }
        
        playerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handler)
        

}

}

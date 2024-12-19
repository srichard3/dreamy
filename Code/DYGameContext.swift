//
//  DYGameContext.swift
//  circle_snap
//
//  Created by Sam Richard on 12/18/24.
//

import Combine
import GameplayKit

class DYGameContext: GameContext {
    var gameScene: DYGameScene? { scene as? DYGameScene }
    let gameMode: GameModeType
    let gameInfo: DYGameInfo
    var layoutInfo: DYLayoutInfo
    
    
    init(dependencies: Dependencies, gameMode: GameModeType) {
        self.gameMode = gameMode
        self.gameInfo = DYGameInfo()
        self.layoutInfo = DYLayoutInfo()
        super.init(dependencies: dependencies)
        self.scene = DYGameScene(context: self, size: UIScreen.main.bounds.size)
        
        configureLayoutInfo()
    }
    
    func configureLayoutInfo() {
        let screenSize = UIScreen.main.bounds.size
        print(screenSize)
        print(screenSize.width * 0.340909091)

        layoutInfo.circleTrackRadius = screenSize.width * 0.340909091
        layoutInfo.circleTrackLineWidth = layoutInfo.circleTrackRadius * 1/3
        layoutInfo.nodeRadius = layoutInfo.circleTrackRadius * 0.15
        
        layoutInfo.conditionPatchSize = layoutInfo.circleTrackRadius * 8/15
        layoutInfo.scoreFontSize = layoutInfo.circleTrackRadius * 7/15
        layoutInfo.tutorialLabelFontSize = layoutInfo.circleTrackRadius * 2/15
        
        layoutInfo.circleTrackNodeSideLength = (layoutInfo.circleTrackRadius + layoutInfo.circleTrackLineWidth) * 2
        
        layoutInfo.startNodePosition = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.275)

        if screenSize.height > 700 {
            layoutInfo.circleTrackNodePosition = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2 - screenSize.height * 0.07)
            layoutInfo.cloudNodePosition = CGPoint(x: 0, y: layoutInfo.circleTrackNodeSideLength * -0.49)
        } else {
            layoutInfo.circleTrackNodePosition = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2 - screenSize.height * 0.04)
            layoutInfo.cloudNodePosition = CGPoint(x: 0, y: layoutInfo.circleTrackNodeSideLength * -0.52)
        }
        layoutInfo.playerNodePosition = CGPoint(x: 0, y: layoutInfo.circleTrackNodeSideLength * 0.5)
        layoutInfo.tutorialOverlayNodePosition = CGPoint(x: 0, y: layoutInfo.circleTrackNodePosition.y * -0.52)
        
        layoutInfo.cloudMovementRange = screenSize.width / 22
        layoutInfo.conditionScaleReference = layoutInfo.circleTrackRadius * 182/150

    }

}

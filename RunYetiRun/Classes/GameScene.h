//
//  GameScene.h
//  RunYetiRun
//
//  Created by Jorge Jordán Arenas on 22/04/14.
//  Copyright 2014 Insane Platypus Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene {
    
    // STEP 2
    CCSprite *yeti;
    
    // STEP 5 - Explain why avoidusing CCArray
    NSMutableArray *snowBalls;
    int numSnowBalls;
    
    // STEP 8 - Show and increase score
    CCLabelTTF *scoreLabel;
    int gameScore;
    BOOL collisionDetected;
}
    // STEP 1
+(GameScene *) scene;

// STEP 4 - Moving the Yeti
-(void) moveYetiToPosition:(CGPoint)newPosition;

// STEP 5 - Initialize snow balls
-(void) initSnowBalls;

// STEP 6 - Detect collisions
-(void) detectCollisions;

// STEP 7 - Let's make blink the yeti!
-(void) manageCollision;

// STEP 8 - Show and increase score
-(void) increaseScore;

@end

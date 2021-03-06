//
//  GameScene.m
//  RunYetiRun
//
//  Created by Jorge Jordán Arenas on 22/04/14.
//  Copyright 2014 Insane Platypus Games. All rights reserved.
//

#import "GameScene.h"

#define yetiSpeed   360.0

@implementation GameScene
    // STEP 1
+(GameScene *) scene {
    return [[self alloc] init];
}

-(id) init {
        // STEP 1
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        // STEP 2 - Adding the Yeti sprite
        yeti = [CCSprite spriteWithImageNamed:@"yeti.png"];
        [self addChild:yeti];
        
        CGSize screenSize = [CCDirector sharedDirector].viewSize; //former winSize
        // delete
        //CGSize imageSize = yeti.texture.contentSize;
        yeti.position = CGPointMake(screenSize.width * 3 / 4, screenSize.height / 2);
        
        // STEP 3 - Adding background
        // Explain why using z:-1
        CCSprite *background = [CCSprite spriteWithImageNamed:@"background.png"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background z:-1];
        
        // STEP 4 - Moving the Yeti //https://www.makegameswith.us/gamernews/359/cocos2d-30-a-brief-transition-guide
        // to enable touch handling on you CCNode:
        self.userInteractionEnabled = TRUE;
        
        // STEP 5 - Adding snow balls
        CCSprite *tempSnowBall = [CCSprite spriteWithImageNamed:@"SnowBall.png"];
        
        // STEP 5 - Calculate how many snow balls can fit on the screen
        float snowBallHeight = tempSnowBall.texture.contentSize.height;
        
        numSnowBalls = screenSize.height / snowBallHeight; // x 2 to increase dificulty
        
        //STEP 5 - Initialize the snow balls array
        snowBalls = [NSMutableArray arrayWithCapacity:numSnowBalls];
        
        for (int i = 0; i < numSnowBalls;i++){
            CCSprite *snowBall = [CCSprite spriteWithImageNamed:@"SnowBall.png"];

            // Add the snow ball to the scene
            [self addChild:snowBall];
            
            // Add the snow ball to the array
            [snowBalls addObject:snowBall];
        }
                
        // STEP 5 - Initialize the snow balls position
        [self initSnowBalls];
        
        // STEP 8 - Show score. Talk about anchor points on labels
        gameScore = 0;
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", gameScore] fontName:@"Arial" fontSize:30];
        scoreLabel.position = CGPointMake(screenSize.width / 2, screenSize.height - 30);
        [self addChild:scoreLabel];
        
        // STEP 8 - Show and increase score
        collisionDetected = FALSE;
        
        // STEP 9 - Playing audio - Explain new way of playing music
        [[OALSimpleAudio sharedInstance] playBg:@"background_music.mp3" loop:YES];
    }
    
    return self;
}

// STEP 6 - Detect collisions
-(void) update:(CCTime)delta
{//https://www.makegameswith.us/gamernews/359/cocos2d-30-a-brief-transition-guide

    // STEP 6 - Detect collisions
    [self detectCollisions];
}

// STEP 4 - Moving the Yeti
// to catch a touch and its touch position
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Prevent actions sum. Explain MoveTo and MoveBy behaviour
    //[yeti stopAllActions];
    [yeti stopActionByTag:0];
    //stop action? by tag?
    CGPoint touchLocation = [touch locationInNode:self];
    [self moveYetiToPosition:touchLocation];
}

// STEP 4 - Moving the Yeti
-(void) moveYetiToPosition:(CGPoint)newPosition{
    
    // Explain new way of executing actions
    //CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position:CGPointMake(yeti.position.x, touchLocation.y)];
    CGPoint yetiPosition = yeti.position;
    
    // Preventing the yeti go out of the screen
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    float yetiHeight = yeti.texture.contentSize.height;
    
    if (newPosition.y > screenSize.height - yetiHeight/2) {
        newPosition.y = screenSize.height - yetiHeight/2;
    } else if (newPosition.y < yetiHeight/2) {
        newPosition.y = yetiHeight/2;
    }
    
    float duration = ccpDistance(newPosition, yetiPosition) / yetiSpeed;
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:duration position:CGPointMake(yetiPosition.x, newPosition.y)];
    // In order to identify the action to stop
    [actionMove setTag:0];
    [yeti runAction:actionMove];
}

// STEP 5 - Initialize snow balls
-(void) initSnowBalls {
    int positionY = 0;
    
    for (int i = 0; i < snowBalls.count; i++){
        
        CCSprite *snowBall = [snowBalls objectAtIndex:i];
        
        // Put the snow ball out of the screen
        positionY += snowBall.contentSize.height;
        CGPoint snowBallPosition = CGPointMake(-snowBall.texture.contentSize.width / 2, positionY);
        
        snowBall.position = snowBallPosition;
        
        [snowBall stopAllActions];
    }
    
    // Explain the schedule method and why we take this approach
    [self schedule:@selector(throwSnowBall:) interval:3.5f];

}

// STEP 5 - Throw snow balls
-(void) throwSnowBall:(CCTime) delta {
    for (int i = 0; i < numSnowBalls; i++){
    
        int randomSnowBall = CCRANDOM_0_1() * snowBalls.count;
        CCLOG(@"randomSnowBall %d", randomSnowBall);
        
        CCSprite *snowBall = [snowBalls objectAtIndex:randomSnowBall];
        
        // We don't want to stop the snow ball
        if (snowBall.numberOfRunningActions == 0) {
            CGPoint newSnowBallPosition = snowBall.position;
            newSnowBallPosition.x = [CCDirector sharedDirector].viewSize.width + snowBall.texture.contentSize.width / 2;

            CCAction *throwSnowBallAction = [CCActionMoveTo actionWithDuration:1 position:newSnowBallPosition];
            
            // Explain blocks, new use
            CCActionCallBlock *callDidThrown = [CCActionCallBlock actionWithBlock:^{

                CGPoint position = snowBall.position;
                position.x = -snowBall.texture.contentSize.width / 2;
                snowBall.position = position;
                
                // STEP 8 - Show and increase score
                if (!collisionDetected){
                    [self increaseScore];
                }
               
            }];

            // STEP 9 - Playing audio
            [[OALSimpleAudio sharedInstance] playEffect:@"avalanche.mp3"];
            
            // Explain sequences and nil
            CCActionSequence *sequence = [CCActionSequence actionWithArray:@[throwSnowBallAction, callDidThrown]];
            [snowBall runAction:sequence];
            
            // STEP 6 - Set visible the snow ball once it's out of the screen
            [snowBall setVisible:TRUE];
            
            // STEP 8 - Reset collision flag
            collisionDetected = FALSE;
            break;
        }
    }
}

// STEP 6 - Detect collisions
-(void) detectCollisions{
    for (CCSprite *snowBall in snowBalls){
        
        if (CGRectIntersectsRect(snowBall.boundingBox, yeti.boundingBox)) {
            [snowBall setVisible:FALSE];
            
             // STEP 7 - Let's make blink the yeti!
            [self manageCollision];
        } /*else {
            collisionDetected = FALSE;

        }*/

    }
}

-(void) manageCollision{
    // STEP 8 - Show and increase score
    collisionDetected = TRUE;
    
    // STEP 9 - Make yeti grrr
    
    // STEP 7 - Let's make blink the yeti!
    CCAction *actionBlink = [CCActionBlink actionWithDuration:0.9 blinks:3];
    CCActionCallBlock *callDidBlink = [CCActionCallBlock actionWithBlock:^{
        [yeti setVisible:TRUE];
    }];
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[actionBlink, callDidBlink]];
    [yeti runAction:sequence];
}

// STEP 8 - Show and increase score
-(void) increaseScore{
    gameScore += 10;
    CCLOG(@"game score %d", gameScore);
    [scoreLabel setString:[NSString stringWithFormat:@"%i", gameScore]];
    collisionDetected = FALSE;
    
}


@end

//
//  GameScene.m
//  RunYetiRun
//
//  Created by Jorge Jordán Arenas on 22/04/14.
//  Copyright 2014 Insane Platypus Games. All rights reserved.
//

#import "GameScene.h"


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
        
    }
    
    return self;
}

// STEP 4 - Moving the Yeti
-(void) update:(CCTime)delta
{//https://www.makegameswith.us/gamernews/359/cocos2d-30-a-brief-transition-guide
    CCLOG(@"%@", @"Schedule update is called automatically");
}

// STEP 4 - Moving the Yeti
// to catch a touch and its touch position:
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    // Explain new way of execting actions
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position:CGPointMake(yeti.position.x, touchLocation.y)];
    [yeti runAction:[CCActionSequence actionWithArray:@[actionMove]]];
}

@end

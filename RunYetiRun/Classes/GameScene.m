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
        
        // STEP 2
        yeti = [CCSprite spriteWithImageNamed:@"yeti.png"];
        [self addChild:yeti];
        
        CGSize screenSize = [CCDirector sharedDirector].viewSize; //former winSize
        // delete
        //CGSize imageSize = yeti.texture.contentSize;
        yeti.position = CGPointMake(screenSize.width * 3 / 4, screenSize.height / 2);
    }
    
    return self;
}

@end

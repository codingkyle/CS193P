//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Kyle Adams on 03-01-14.
//  Copyright (c) 2014 Kyle Adams. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init]; 
}

@end

//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Kyle Adams on 21-12-13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger matchNumber;
@property (nonatomic, strong) NSString *resultString;

@end

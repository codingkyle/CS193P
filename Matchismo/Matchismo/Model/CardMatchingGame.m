//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kyle Adams on 21-12-13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSUInteger)matchNumber {
    if (!_matchNumber) {
        _matchNumber = 2;
    }
    return _matchNumber;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index <[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.resultString = [NSString stringWithFormat:@"%@", card.contents];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.resultString = @"";
        } else {
            NSMutableArray *otherCards = [NSMutableArray array];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
            }
            if ([otherCards count] == self.matchNumber - 1) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    NSString *otherCardsContents = @"";
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                        otherCardsContents = [otherCardsContents stringByAppendingFormat:@"%@", otherCard.contents];
                    }
                    self.resultString = [NSString stringWithFormat:@"Matched %@ %@ for score: %d", card.contents, otherCardsContents, matchScore * MATCH_BONUS];
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                    self.resultString = [NSString stringWithFormat:@"Mismatch! Penalty of %d", MISMATCH_PENALTY];
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end

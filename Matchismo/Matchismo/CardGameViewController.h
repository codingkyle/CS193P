//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Kyle Adams on 21-12-13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//
// Abstract Class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

//protected
//for subclasses
- (Deck *)createDeck; //abstract

@end

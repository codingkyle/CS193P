//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Adams on 21-12-13.
//  Copyright (c) 2013 Kyle Adams. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeControl;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (nonatomic, strong) NSMutableArray *gameResults;
@property (weak, nonatomic) IBOutlet UISlider *resultsSlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        [self matchModeSelector:self.matchModeControl];
    }
    return _game;
}

- (NSMutableArray *)gameResults {
    if (!_gameResults) {
        _gameResults = [[NSMutableArray alloc] init];
    }
    return _gameResults;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)gameResultSlider:(UISlider *)resultsSlider {
    
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self.matchModeControl setEnabled:NO];
    [self updateUI];
}

- (IBAction)dealButtonPressed:(UIButton *)sender {
    self.game = nil;
    [self.gameResults removeAllObjects];
    [self.matchModeControl setEnabled:YES];
    [self updateUI];
}

- (IBAction)matchModeSelector:(UISegmentedControl *)sender {
    self.game.matchNumber = sender.selectedSegmentIndex + 2;
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
    self.progressLabel.text = self.game.resultString;
    if (![self.game.resultString isEqualToString:@""] && self.game.resultString) {
        [self.gameResults addObject:self.game.resultString];
    }
    
    if ([self.gameResults count]) {
        [self setSliderRange];
    }
}

- (void)setSliderRange
{
    int maxValue = [self.gameResults count] - 1;
    self.resultsSlider.maximumValue = maxValue;
    [self.resultsSlider addTarget:self action:@selector(setResults) forControlEvents:UIControlEventValueChanged];
}

- (void)setResults {
    int sliderValue = lroundf(self.resultsSlider.value);
    [self.resultsSlider setValue:sliderValue animated:YES];
    if ([self.gameResults count]) {
        self.progressLabel.alpha = self.resultsSlider.value = [self.gameResults count] + 1 ? 0.5 : 1;
        self.progressLabel.text = [self.gameResults objectAtIndex:sliderValue];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end

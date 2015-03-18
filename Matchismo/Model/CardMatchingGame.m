//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Sonny Kui on 12/23/14.
//  Copyright (c) 2014 Sonny. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) NSInteger numberMatchMode;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardcount:(NSUInteger)count usingDeck:(Deck *)deck
{
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
    self.numberMatchMode = MATCH_MODE_DEFAULT;
    return self;
}


//#define MISMATCH_PENALTY 2;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int MATCH_MODE_BONUS = 10;
static const int MATCH_MODE_DEFAULT = 2;
static const int MATCH_MODE_NUMBER = 3;

- (void)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        
        card.chosen = YES;
        
        self.score -= COST_TO_CHOOSE;
        
        int numberOfCardsChosen = [self findNumberCardsChosen];
        
        if (numberOfCardsChosen < self.numberMatchMode) return;

        int matchScore = 0;
        BOOL isMatched = NO;
        
        for (Card *otherCard in self.cards) {
            if (otherCard.isChosen && !otherCard.isMatched) {
                
                matchScore += [card match:@[otherCard]];
                if (matchScore) {
                    
                    if (isMatched) self.score += matchScore * MATCH_MODE_BONUS;
                    self.score += matchScore * MATCH_BONUS;;
                    card.matched = YES;
                    otherCard.matched = YES;
                    isMatched = YES;
                    
                } else {
                    self.score -= MISMATCH_PENALTY;
                }
            }
            otherCard.chosen = NO;
        }
        
        card.chosen = NO;
        
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)toggleMatchMode {
    self.numberMatchMode  = (self.numberMatchMode == MATCH_MODE_DEFAULT) ? MATCH_MODE_NUMBER : MATCH_MODE_DEFAULT;
}

- (NSInteger)findNumberCardsChosen {
    int numberOfCardsChosen = 0;
    
    for (Card *card in self.cards) {
        if (card.chosen) numberOfCardsChosen++;
    }
    return numberOfCardsChosen;
}

- (void)resetGame {
    self.score = 0;
    
    for (Card *card in self.cards) {
        card.matched = NO;
        card.chosen = NO;

    }
}
@end

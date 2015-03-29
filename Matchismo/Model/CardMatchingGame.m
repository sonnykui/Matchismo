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
static const int MATCH_MODE_BONUS = 100;
static const int MATCH_MODE_DEFAULT = 2;
static const int MATCH_MODE_NUMBER = 3;

- (void)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        
        //if already chosen, flip it face down again
        if (card.isChosen) {
            card.chosen = NO;
            return;
        }
        
        self.score -= COST_TO_CHOOSE;
        
        card.chosen = YES;
        
        if ([self findNumberCardsChosen] < self.numberMatchMode) return;
        
        NSMutableArray *chosenCards = [self findCardsChosen];

        BOOL foundMatching = NO;
        
        //iterate and check all combinations
        //first card against all other cards
        //then second card against all other cards, etc
        for (int i = 0; i < chosenCards.count; i++) {

            
            int matchScore = [self calculateScore:chosenCards];
            if (matchScore) {
                self.score += matchScore * MATCH_BONUS;
                foundMatching = YES;
            } else {
                self.score -= MISMATCH_PENALTY;
            }
            
            //don't check again if only 2 chosen cards
            if (chosenCards.count == 2) break;
            
            [chosenCards addObject:chosenCards[0]];
            [chosenCards removeObjectAtIndex:0];
            
        }
        
        if (foundMatching) {
            for (Card *chosenCard in chosenCards) {
                chosenCard.matched = YES;
            }
            if (chosenCards.count > 2) self.score += MATCH_MODE_BONUS;
            
        } else {
            for (Card *chosenCard in chosenCards) {
                chosenCard.matched = NO;
                chosenCard.chosen = NO;
            }
            card.chosen = YES;
            
        }



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
        if (card.chosen && !card.isMatched) numberOfCardsChosen++;
    }
    return numberOfCardsChosen;
}


- (NSMutableArray *)findCardsChosen {
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for (Card *card in self.cards) {
        if (card.chosen && !card.isMatched) {
            [cards addObject:card];
        }
    }
    return cards;
}

-(NSInteger)calculateScore:(NSArray *)cards {
    if ([cards count] == 1) return 0;
    
    
    NSRange theRange;
    
    theRange.location = 1;
    theRange.length = [cards count] - 1;
    
    NSArray *otherChosenCards = [cards subarrayWithRange:theRange];
    
    int score = [cards[0] match:otherChosenCards];
  
    return (score + [self calculateScore:otherChosenCards]);
}

- (void)resetGame {
    self.score = 0;
    
    for (Card *card in self.cards) {
        card.matched = NO;
        card.chosen = NO;

    }
}
@end

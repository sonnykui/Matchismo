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
    self.matchMode3 = NO;
    return self;
}


//#define MISMATCH_PENALTY 2;
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int MATCH_MODE_3_BONUS = 10;

- (void)chooseCardAtIndex:(NSInteger)index
{
    Card *card = [self cardAtIndex:index];
    

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against another card

            BOOL firstPairChecked = NO;
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    
                    Card *savedOtherCard = otherCard;
                    
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;;
                        card.matched = YES;
                        otherCard.matched = YES;
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                    }
                    
                    //Done if only matching on 2
                    if (!self.matchMode3) break;
                    NSLog(@"Mode 3: Checking 1st pair...");
                    
                    //2nd pass on a match on 3?
                    if (firstPairChecked) {
                        NSLog(@"Mode 3: Checking 2nd pair...");
                        matchScore = [card match:@[savedOtherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_MODE_3_BONUS;;
                            card.matched = YES;
                            otherCard.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                        }

                        break;
                    }
 
                    //if matching on 3 cards, do an extra pass
                    firstPairChecked = YES;
                    
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)toggleMatchMode {
    self.matchMode3 = !self.matchMode3;
    
}

- (void)resetGame {
    self.score = 0;
    
    for (Card *card in self.cards) {
        card.matched = NO;
        card.chosen = NO;

    }
}
@end

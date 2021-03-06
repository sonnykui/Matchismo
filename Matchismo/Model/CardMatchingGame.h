//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Sonny Kui on 12/23/14.
//  Copyright (c) 2014 Sonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardcount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)resetGame;
- (void)toggleMatchMode;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger numberMatchMode;
@property (nonatomic, readonly) NSMutableString *result;

@end

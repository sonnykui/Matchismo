//
//  Deck.h
//  Matchismo
//
//  Created by Sonny Kui on 11/17/14.
//  Copyright (c) 2014 Sonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end

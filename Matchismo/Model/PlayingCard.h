//
//  PlayingCard.h
//  Matchismo
//
//  Created by Sonny Kui on 11/17/14.
//  Copyright (c) 2014 Sonny. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end

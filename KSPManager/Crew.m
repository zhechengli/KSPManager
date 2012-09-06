//
//  Crew.m
//  KSPManager
//
//  Created by Erik O'Shaughnessy on 9/5/12.
//  Copyright (c) 2012 Symbolic Armageddon. All rights reserved.
//

#import "Crew.h"

@implementation Crew


@synthesize name = _name;
@synthesize brave = _brave;
@synthesize dumb = _dumb;
@synthesize badS = _badS;
@synthesize state = _state;
@synthesize ToD = _ToD;
@synthesize idx = _idx;


#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Overridden Properties

- (NSString *)description
{
 return [NSString  stringWithFormat:@"Crew: %@  Brave: %@ Dumb: %@ badS: %@ state: %@ ToD: %@ idx: %@",
         self.name,
         self.brave,
         self.dumb,
         self.badS,
         self.state,
         self.ToD,
         self.idx];
}


#pragma mark -
#pragma mark Instance Methods

#pragma mark -
#pragma mark Overridden Instance Methods

#pragma mark -
#pragma mark Class Methods

#pragma mark -
#pragma mark Overridden Class Methods

@end
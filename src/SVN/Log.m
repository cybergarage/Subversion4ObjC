//
//  Log.m
//  iSubversion
//
//  Created by Satoshi Konno on 11/04/12.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "Log.h"


@implementation Log

@synthesize revision;
@synthesize author;
@synthesize date;
@synthesize message;

-(void)dealloc
{
    self.author = nil;
    self.date = nil;
    self.message = nil;
    
	[super dealloc];
}

@end

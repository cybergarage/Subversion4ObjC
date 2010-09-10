//
//  Core.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import "Core.h"


@implementation Core

@synthesize pool;

- (id)initWithPool:(Pool *)aPool
{
	if (self = [super init]) {
		[self setPool:aPool];
	}
	return self;	
}

-(void)dealloc
{
	[super dealloc];
}


@end

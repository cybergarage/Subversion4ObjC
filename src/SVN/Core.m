//
//  Core.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Core.h>
#import <APR/Apr.h>

@implementation Core

@synthesize pool;
@synthesize cObject;

- (id)initWithPool:(Pool *)aPool
{
	if ((self = [super init])) {
		[self setPool:aPool];
	}
	return self;	
}

- (id)initWithCObject:(const void *)cObj;
{
	if ((self = [super init])) {
		[self setCObject:cObj];
	}
	return self;	
}

- (id)init
{
	return [self initWithPool:[[[Pool alloc] init] autorelease]];
}

-(void)dealloc
{
    self.pool = nil;
    
	[super dealloc];
}

@end

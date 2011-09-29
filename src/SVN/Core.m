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

@synthesize cObject;

- (id)initWithCObject:(const void *)cObj;
{
	if ((self = [super init])) {
		[self setCObject:cObj];
	}
	return self;	
}

- (id)init
{
	if ((self = [super init])) {
	}
	return self;	
}

-(void)dealloc
{
	[super dealloc];
}

@end

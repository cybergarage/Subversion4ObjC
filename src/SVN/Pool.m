//
//  Pool.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Pool.h>

@implementation Pool

@synthesize pool;

-(id)init
{
	if (self = [super init]) {
		pool = svn_pool_create(NULL);
	}
	return self;
}

- (id)initWithPool:(Pool *)aPool;
{
	if (self = [super init]) {
		pool = svn_pool_create([aPool pool]);
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
	svn_pool_destroy([self pool]);
}

@end

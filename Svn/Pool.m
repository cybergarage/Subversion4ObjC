//
//  Pool.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Svn/Pool.h>

@implementation Pool

@synthesize pool;

-(id)init
{
	if (self = [super init]) {
		pool = svn_pool_create(NULL);
	}
	return self;
}

@end

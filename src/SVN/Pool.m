//
//  Pool.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Pool.h>
#import <APR/Apr.h>

@implementation Pool

@synthesize pool;

- (id)initWithPool:(Pool *)aPool;
{
	if ((self = [super init])) {
		[Apr sharedInstance];	
		pool = svn_pool_create([aPool pool]);
	}
	return self;
}

-(id)init
{
	if ((self = [super init])) {
		[Apr sharedInstance];	
		pool = svn_pool_create(NULL);
	}
	return self;
}

-(void)dealloc
{
	svn_pool_destroy([self pool]);
    
	[super dealloc];
}

@end

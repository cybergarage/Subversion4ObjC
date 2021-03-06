//
//  Apr.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <APR/Apr.h>

#include <apr_general.h>

static Apr *aprSharedInstance = nil;

@implementation Apr

+ (Apr *)sharedInstance
{
	if (aprSharedInstance == nil)
		aprSharedInstance = [[Apr alloc] init];
	return aprSharedInstance;
}

- (id)init;
{
	if ((self = [super init])) {
		apr_status_t aprErr = apr_initialize();
		if (aprErr) {
			[self release];
			return nil;
		}
		if (atexit(apr_terminate) < 0) {
			[self release];
			return nil;
		}			
	}
	return self;
}

@end

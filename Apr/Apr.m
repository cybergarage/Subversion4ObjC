//
//  Apr.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/07.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Apr/Apr.h>

#include <apr_general.h>

@implementation Apr

+ (Apr *)sharedInstance
{
	static Apr *aprSharedInstance = nil;
	if (aprSharedInstance == nil)
		aprSharedInstance = [[Apr alloc] init];
	return aprSharedInstance;
}

- (id)init;
{
	if (self = [super init]) {
		apr_initialize();
	}
	return self;
}
@end

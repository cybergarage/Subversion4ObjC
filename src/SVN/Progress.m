//
//  Progress.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/11/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Progress.h>
#import <svn_wc.h>

@implementation Progress

@synthesize position;
@synthesize total;

- (id)init
{
	if ((self = [super init])) {
	}
	return self;	
}

@end

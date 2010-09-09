//
//  Fs.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import "Svn/Fs.h"

#include <svn_fs.h>

@implementation Fs

- (id)initWithPool:(Pool *)aPool
{
	if (self = [super init]) {
		svn_error_t *svnErr = svn_fs_initialize([aPool pool]);
		if (svnErr) {
			[self release];
			return nil;
		}
	}
	return self;	
}

-(void)dealloc
{
}

@end

//
//  Notify.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/11/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Notify.h>
#import <svn_wc.h>

@implementation Notify

- (id)init
{
	if (self = [super init]) {
	}
	return self;	
}

- (NSString *)path
{
	svn_wc_notify_t *notifyObj = (svn_wc_notify_t *)[self cObject];
	return [NSString stringWithUTF8String:notifyObj->path];
}

@end

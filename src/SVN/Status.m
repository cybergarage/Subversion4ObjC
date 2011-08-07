//
//  Status.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/12/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import "SVN/Status.h"
#include <svn_wc.h>

@implementation Status

@synthesize path;

- (id)initWithCObject:(const void *)cObj
{
	if ((self = [super initWithCObject:cObj])) {
		svn_wc_status_t *statusObj = (svn_wc_status_t *)[self cObject];
		svn_wc_status_t *statusCopyObj = malloc(sizeof(svn_wc_status_t));
		*statusCopyObj = *statusObj;
		[self setCObject:statusCopyObj];
	}
	return self;
}

-(void)dealloc
{
    self.path = nil;
    
	svn_wc_status_t *statusObj = (svn_wc_status_t *)[self cObject];
	if (statusObj)
		free(statusObj);

	[super dealloc];
}

- (NSString *)basename
{
	if ([self path] == nil)
		return @"";
	NSArray *filenames = [[self path] componentsSeparatedByString:@"/"];
	if ([filenames count] <= 0)
		return @"";
	return [filenames objectAtIndex:([filenames count] - 1)];
}

- (int)statusKindFrom:(int)statusKind
{
	switch (statusKind) {
		case svn_wc_status_none:
			return CGSvnStatusNone;
		case svn_wc_status_unversioned:
			return CGSvnStatusUnversioned;
		case svn_wc_status_normal:
			return CGSvnStatusNormal;
		case svn_wc_status_added:
			return CGSvnStatusAdded;
		case svn_wc_status_missing:
			return CGSvnStatusMissing;
		case svn_wc_status_deleted:
			return CGSvnStatusDeleted;
		case svn_wc_status_replaced:
			return CGSvnStatusReplaced;
		case svn_wc_status_modified:
			return CGSvnStatusModified;
		case svn_wc_status_merged:
			return CGSvnStatusMerged;
		case svn_wc_status_conflicted:
			return CGSvnStatusConflicted;
		case svn_wc_status_ignored:
			return CGSvnStatusIgnored;
		case svn_wc_status_obstructed:
			return CGSvnStatusObstructed;
		case svn_wc_status_external:
			return CGSvnStatusExternal;
		case svn_wc_status_incomplete:
			return CGSvnStatusIncomplete;
	}
	
	return CGSvnStatusUnknown; 	
}

- (int)textStatus
{
	svn_wc_status_t *statusObj = (svn_wc_status_t *)[self cObject];
	if (!statusObj)
		return CGSvnStatusUnknown;
	return [self statusKindFrom:statusObj->text_status];
}

- (int)propStatus
{
	svn_wc_status_t *statusObj = (svn_wc_status_t *)[self cObject];
	if (!statusObj)
		return CGSvnStatusUnknown;
	return [self statusKindFrom:statusObj->prop_status];
}

@end

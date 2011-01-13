//
//  Status.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/12/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Core.h>

enum {
	CGSvnStatusUnknown = 0,
	CGSvnStatusNone,
	CGSvnStatusUnversioned,
	CGSvnStatusNormal,
	CGSvnStatusAdded,
	CGSvnStatusMissing,
	CGSvnStatusDeleted,
	CGSvnStatusReplaced,
	CGSvnStatusModified,
	CGSvnStatusMerged,
	CGSvnStatusConflicted,
	CGSvnStatusIgnored,
	CGSvnStatusObstructed,
	CGSvnStatusExternal,
	CGSvnStatusIncomplete,
};

@interface Status : Core {

}
@property(retain) NSString *path;
- (NSString *)basename;
- (int)textStatus;
- (int)propStatus;
@end

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
	if ((self = [super init])) {
	}
	return self;	
}

- (NSString *)path
{
	svn_wc_notify_t *notifyObj = (svn_wc_notify_t *)[self cObject];
	if (notifyObj->path == NULL)
		return nil;
	return [NSString stringWithUTF8String:notifyObj->path];
}

- (NSString *)basename
{
	NSString *url = [self path];
	if (url == nil)
		return @"";
	NSArray *filenames = [url componentsSeparatedByString:@"/"];
	if ([filenames count] <= 0)
		return @"";
	return [filenames objectAtIndex:([filenames count] - 1)];
}

- (int)actionType
{
	svn_wc_notify_t *notifyObj = (svn_wc_notify_t *)[self cObject];
	svn_wc_notify_action_t notifyAction = notifyObj->action;

	switch (notifyAction) {
		case svn_wc_notify_add:
			return CGSvnNotifyActionAdd;
		case svn_wc_notify_copy:
			return CGSvnNotifyActionCopy;
		case svn_wc_notify_delete:
			return CGSvnNotifyActionDelete;
		case svn_wc_notify_restore:
			return CGSvnNotifyActionRestore;
		case svn_wc_notify_revert:
			return CGSvnNotifyActionRevert;
		case svn_wc_notify_failed_revert:
			return CGSvnNotifyActionFailedRevert;
		case svn_wc_notify_resolved:
			return CGSvnNotifyActionResolved;
		case svn_wc_notify_skip:
			return CGSvnNotifyActionSkip;
		case svn_wc_notify_update_delete:
			return CGSvnNotifyActionUpdateDelete;
		case svn_wc_notify_update_add:
			return CGSvnNotifyActionUpdateAdd;
		case svn_wc_notify_update_update:
			return CGSvnNotifyActionUpdateUpdate;
		case svn_wc_notify_update_completed:
			return CGSvnNotifyActionUpdateCompleted;
		case svn_wc_notify_update_external:
			return CGSvnNotifyActionUpdateExternal;
		case svn_wc_notify_status_completed:
			return CGSvnNotifyActionStatusCompleted;
		case svn_wc_notify_status_external:
			return CGSvnNotifyActionStatusExternal;
		case svn_wc_notify_commit_modified:
			return CGSvnNotifyActionCommitModified;
		case svn_wc_notify_commit_added:
			return CGSvnNotifyActionCommitAdded;
		case svn_wc_notify_commit_deleted:
			return CGSvnNotifyActionCommitDeleted;
		case svn_wc_notify_commit_replaced:
			return CGSvnNotifyActionCommitReplaced;
		case svn_wc_notify_commit_postfix_txdelta:
			return CGSvnNotifyActionCommitPostfixTxdelta;
	}
	
	return CGSvnNotifyActionUnknown;
}

- (long)revision
{
	svn_wc_notify_t *notifyObj = (svn_wc_notify_t *)[self cObject];
	return notifyObj->revision;
}

- (NSString *)shortMessage
{
	NSString *basename = [self basename];
	if (basename == nil)
		return @"";
	
	NSString *notifyMsg = @"";
	
	switch ([self actionType]) {
		case CGSvnNotifyActionUpdateDelete:
		case CGSvnNotifyActionCommitDeleted:
			notifyMsg = [NSString stringWithFormat:@"D:%@", basename];
			break;
		case CGSvnNotifyActionUpdateAdd:
		case CGSvnNotifyActionCommitAdded:
			notifyMsg = [NSString stringWithFormat:@"A:%@", basename];
			break;
		case CGSvnNotifyActionUpdateUpdate:
			notifyMsg = [NSString stringWithFormat:@"U:%@", basename];
			break;
		case CGSvnNotifyActionCommitModified:
			notifyMsg = [NSString stringWithFormat:@"M:%@", basename];
			break;
		case CGSvnNotifyActionCommitReplaced:
			notifyMsg = [NSString stringWithFormat:@"R:%@", basename];
			break;
	}
	
	return notifyMsg;
}

@end

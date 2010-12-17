//
//  Notify.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/11/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Core.h>

enum {
	CGSvnNotifyActionUnknown = 0,
	CGSvnNotifyActionAdd,
	CGSvnNotifyActionCopy,
	CGSvnNotifyActionDelete,
	CGSvnNotifyActionRestore,
	CGSvnNotifyActionRevert,
	CGSvnNotifyActionFailedRevert,
	CGSvnNotifyActionResolved,
	CGSvnNotifyActionSkip,
	CGSvnNotifyActionUpdateDelete,
	CGSvnNotifyActionUpdateAdd,
	CGSvnNotifyActionUpdateUpdate,
	CGSvnNotifyActionUpdateCompleted,
	CGSvnNotifyActionUpdateExternal,
	CGSvnNotifyActionStatusCompleted,
	CGSvnNotifyActionStatusExternal,
	CGSvnNotifyActionCommitModified,
	CGSvnNotifyActionCommitAdded,
	CGSvnNotifyActionCommitDeleted,
	CGSvnNotifyActionCommitReplaced,
	CGSvnNotifyActionCommitPostfixTxdelta,
};

@interface Notify : Core {

}
- (id)init;
- (NSString *)path;
- (NSString *)basename;
- (int)actionType;
- (long)revision;
- (NSString *)shortMessage;
@end

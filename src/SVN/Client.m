//
//  Client.m
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/06.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <SVN/Client.h>

#import <APR/Apr.h>
#import <SVN/Pool.h>
#import <SVN/Status.h>

#include <svn_client.h>
#include <svn_pools.h>
#include <svn_path.h>

@implementation Client

@synthesize ctx;
@synthesize auth;
@synthesize fs;
@synthesize delegate;
@synthesize delegateObject;
@synthesize resultSet;
@synthesize errorMessage;

static void cg_svnobjc_ra_progress_notify_func(apr_off_t progress, apr_off_t total, void *baton, apr_pool_t *pool);
static void cg_svnobjc_wc_notify_func2(void *baton, const svn_wc_notify_t *notify, apr_pool_t *pool);
static svn_error_t* cg_svnobjc_cancel_func(void *cancel_baton);
static void cg_svnobjc_status_func(void *baton, const char *path, svn_wc_status_t *status);
static svn_error_t* cg_svnobjc_info_receiver_func(void *baton, const char *path, const svn_info_t *info, apr_pool_t *pool);
static svn_error_t * cg_svnobjc_log_msg_func(const char **log_msg, const char **tmp_file,  apr_array_header_t *commit_items, void *baton, apr_pool_t *pool);
static svn_error_t* cg_svnobjc_log_receiver_func(void *baton, apr_hash_t *changed_paths, svn_revnum_t revision, const char *author, const char *date,const char *message, apr_pool_t *pool);

- (id)initWithPool:(Pool *)aPool
{
	svn_error_t *err;
	
	if (!(self = [super initWithPool:aPool]))
		return nil;
	
	if ((err = svn_config_ensure (NULL, [[self pool] pool]))) {
		[self release];
		return nil;
	}
	
	[self setFs:[[[Fs alloc] initWithPool:aPool] autorelease]];
	if (![self fs]) {
		[self release];
		return nil;
	}
	
	if ((err = svn_client_create_context(&ctx, [[self pool] pool]))) {
		[self release];
		return nil;
	}
	
	if ((err = svn_config_get_config (&(ctx->config), NULL, [[self pool] pool]))) {
		[self release];
		return nil;
	}

	ctx->notify_func2 = cg_svnobjc_wc_notify_func2;
	ctx->notify_baton2 = self;

	ctx->log_msg_func = cg_svnobjc_log_msg_func;
	ctx->log_msg_baton = NULL;
	
	ctx->cancel_func = cg_svnobjc_cancel_func;
	ctx->cancel_baton = self;

	ctx->progress_func = cg_svnobjc_ra_progress_notify_func;
	ctx->progress_baton = self;
	
	[self setAuth:[[[Auth alloc] initWithPool:aPool] autorelease]];
	if (![self auth]) {
		return nil;
	}	
	svn_auth_open (&ctx->auth_baton, [[self auth] providers], [[self pool] pool]);

	return self;	
}

- (id)init
{
	return [self initWithPool:[[[Pool alloc] init] autorelease]];
}

-(void)dealloc
{
    self.auth = nil;
    self.fs = nil;
    self.delegate = nil;
    self.delegateObject = nil;
    self.resultSet = nil;
    self.errorMessage = nil;
    
	[super dealloc];
}

#pragma mark -
#pragma mark list

- (void)errorMessage:(svn_error_t *)err buffer:(NSMutableString *)buffer
{
	if (err->message)
		[buffer appendString:[NSString stringWithUTF8String:err->message]];
		 
	if (err->child) {
		[buffer appendString:@"\n"];
		[self errorMessage:err->child buffer:buffer];
	}
}

- (NSMutableString *)errorMessage:(svn_error_t *)err
{
	NSMutableString *errMessage = [NSMutableString string];
	[self errorMessage:err buffer:errMessage];
	return errMessage;
}

#pragma mark -
#pragma mark list

- (BOOL)list:(NSString *)url recurse:(BOOL)recurse;
{
	apr_hash_t *dirents;
	svn_opt_revision_t revision;
	
	revision.kind = svn_opt_revision_head;
	
	svn_error_t *err = svn_client_ls (&dirents,
						[url UTF8String], 
						&revision,
						recurse,
						[self ctx], 
						[[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}

	NSMutableArray *listArray = [NSMutableArray array];
	for (apr_hash_index_t *hi = apr_hash_first ([[self pool] pool], dirents); hi; hi = apr_hash_next (hi)){
		const char *entryname;
		svn_dirent_t *val;
		apr_hash_this (hi, (void *) &entryname, NULL, (void *) &val);
		[listArray addObject:[NSString stringWithUTF8String:entryname]];
	}
	
	[self setResultSet:listArray];
		 
	return YES;
}

#pragma mark -
#pragma mark checkout

- (BOOL)checkout:(NSString *)url path:(NSString *)path recurse:(BOOL)recurse
{
	svn_revnum_t 	result_rev;
	svn_opt_revision_t revision;
	 
	revision.kind = svn_opt_revision_head;
	
	svn_error_t *err = svn_client_checkout(&result_rev,
										   [url UTF8String], 
										   [path UTF8String], 
										   &revision,
										   recurse,
										   [self ctx], 
										   [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark update

- (BOOL)update:(NSString *)path recurse:(BOOL)recurse
{
	svn_revnum_t 	result_rev;
	svn_opt_revision_t revision;
	
	revision.kind = svn_opt_revision_head;
	
	svn_error_t *err = svn_client_update(&result_rev,
										   [path UTF8String], 
										   &revision,
										   recurse,
										   [self ctx], 
										   [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark add

- (BOOL)add:(NSString *)path recurse:(BOOL)recurse
{
	svn_error_t *err = svn_client_add([path UTF8String],
									  recurse,
									  [self ctx], 
									  [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark commit

- (BOOL)commit:(NSString *)path message:(NSString *)message recurse:(BOOL)recurse
{
	if ([self status:path recurse:recurse update:NO] == NO)
		return NO;
	
	NSMutableArray *modifiedFiles = [NSMutableArray array];
	for (Status *status in [self resultSet]) {
		if ([status propStatus] != CGSvnStatusNormal)
			[modifiedFiles addObject:status];
	}
	
	if ([modifiedFiles count] <= 0)
		return YES;
	
	ctx->log_msg_baton = (void *)[message UTF8String];
	
	svn_client_commit_info_t *commit_info = NULL;
	apr_array_header_t *targets;

	targets = apr_array_make([[self pool] pool], [modifiedFiles count], sizeof(const char *));
	for (Status *status in modifiedFiles)
		APR_ARRAY_PUSH(targets, const char *) = [[status path] UTF8String];
	
	svn_error_t *err = svn_client_commit(&commit_info,
										 targets,
										 NO,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		NSLog(@"%@", [self errorMessage]);
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark delete

- (BOOL)remove:(NSString *)path force:(BOOL)force
{
	svn_client_commit_info_t *commit_info = NULL;
	apr_array_header_t *targets;
	
	targets = apr_array_make([[self pool] pool], 1, sizeof(const char *));
	APR_ARRAY_PUSH(targets, const char *) = [path UTF8String];
	
	svn_error_t *err = svn_client_delete(&commit_info,
										 targets,
										 force,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark mkdir

- (BOOL)mkdir:(NSString *)path
{
	svn_client_commit_info_t *commit_info = NULL;
	apr_array_header_t *targets;
	
	targets = apr_array_make([[self pool] pool], 1, sizeof(const char *));
	APR_ARRAY_PUSH(targets, const char *) = [path UTF8String];

	svn_error_t *err = svn_client_mkdir(&commit_info,
										 targets,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark move

- (BOOL)move:(NSString *)srcPath to:(NSString *)dstPath force:(BOOL)force
{
	svn_client_commit_info_t *commit_info = NULL;
	svn_opt_revision_t revision;
	
	revision.kind = svn_opt_revision_unspecified;
	
	svn_error_t *err = svn_client_move(&commit_info,
										 [srcPath UTF8String], 
										 &revision,
										 [dstPath UTF8String], 
										 force,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark copy

- (BOOL)copy:(NSString *)srcPath to:(NSString *)dstPath
{
	svn_client_commit_info_t *commit_info = NULL;
	svn_opt_revision_t revision;
	
	revision.kind = svn_opt_revision_unspecified;
	
	svn_error_t *err = svn_client_copy(&commit_info,
									   [srcPath UTF8String], 
									   &revision,
									   [dstPath UTF8String], 
									   [self ctx], 
									   [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark resolved

- (BOOL)resolved:(NSString *)path recurse:(BOOL)recurse
{
	svn_error_t *err = svn_client_resolved(
										   [path UTF8String], 
										   recurse,
										   [self ctx], 
										   [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark status

- (BOOL)status:(NSString *)path recurse:(BOOL)recurse update:(BOOL)update
{
	svn_revnum_t 	result_rev;
	svn_opt_revision_t revision;
	
	revision.kind = svn_opt_revision_head;
	
	NSMutableArray *statusList = [NSMutableArray array];
	[self setResultSet:statusList];
	
	svn_error_t *err = svn_client_status(&result_rev,
										 [path UTF8String], 
										 &revision,
										 cg_svnobjc_status_func,
										 self,
										 recurse,
										 YES,
										 update,
										 YES,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark info

- (BOOL)info:(NSString *)path recurse:(BOOL)recurse
{
	NSMutableArray *listArray = [NSMutableArray array];
	
	svn_error_t *err = svn_client_info([path UTF8String],
										 NULL, 
										 NULL,
										 cg_svnobjc_info_receiver_func,
										 listArray,
										 recurse,
										 [self ctx], 
										 [[self pool] pool]);
	
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	[self setResultSet:listArray];
	
	return YES;
}

#pragma mark -
#pragma mark revert

- (BOOL)revert:(NSString *)path recurse:(BOOL)recurse
{
	apr_array_header_t *targets;
	
	targets = apr_array_make([[self pool] pool], 1, sizeof(const char *));
	APR_ARRAY_PUSH(targets, const char *) = [path UTF8String];
	
	svn_error_t *err = svn_client_revert(targets,
										 recurse,
										[self ctx], 
										[[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark cleanup

- (BOOL)cleanup:(NSString *)path
{
	svn_error_t *err = svn_client_cleanup(
									  [path UTF8String], 
									  [self ctx], 
									  [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark unlock

- (BOOL)unlock:(NSString *)path
{
	apr_array_header_t *targets = apr_array_make ([[self pool] pool], 1, sizeof (const char *));
	APR_ARRAY_PUSH (targets, const char *) = [path UTF8String];
	
	svn_error_t *err = svn_client_unlock(targets,
										 TRUE,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

#pragma mark -
#pragma mark log

- (BOOL)log:(NSString *)path 
{
	apr_array_header_t *targets;
	
	targets = apr_array_make([[self pool] pool], 1, sizeof(const char *));
	APR_ARRAY_PUSH(targets, const char *) = [path UTF8String];
	
	svn_opt_revision_t startRev;
	startRev.kind = svn_opt_revision_head;
    
	svn_opt_revision_t endRev;
    
	svn_error_t *err = svn_client_log(targets,
                                      &startRev,
                                      &endRev,
                                      NO,
                                      NO,
                                      cg_svnobjc_log_receiver_func,
                                      self,
                                      [self ctx], 
                                      [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[self errorMessage:err]];
		return NO;
	}
	
	return YES;
}

@end

#pragma mark -
#pragma mark callback funtions

static svn_error_t* cg_svnobjc_cancel_func(void *baton)
{
	Client *client = (Client *)baton;
	
	if (![client delegate])
		return SVN_NO_ERROR;
	
	if (![[client delegate] respondsToSelector:@selector(doCancel)])
		return SVN_NO_ERROR;
	
	if ([[client delegate] doCancel])
		return svn_error_create(SVN_ERR_CANCELLED, NULL, NULL);
	
	return SVN_NO_ERROR;
}

static void cg_svnobjc_wc_notify_func2(void *baton, const svn_wc_notify_t *cnotify, apr_pool_t *pool)
{
	Client *client = (Client *)baton;
	
	if (![client delegate])
		return;
	
	if (![[client delegate] respondsToSelector:@selector(notify:object:)])
		return;
	
	Notify *notify = [[Notify alloc] initWithCObject:cnotify];
	[[client delegate] notify:notify object:[client delegateObject]] ;
	[notify release];
}

static void cg_svnobjc_ra_progress_notify_func(apr_off_t progress, apr_off_t total, void *baton, apr_pool_t *pool)
{
	Client *client = (Client *)baton;
	id<ClientDelegate> clientDelegate = [client delegate];
	
	if (clientDelegate == nil)
		return;
	
	if (![clientDelegate respondsToSelector:@selector(progress:object:)])
		return;
	
	Progress *progressInfo = [[Progress alloc] init];
	[progressInfo setPosition:progress];
	[progressInfo setTotal:total];
	[[client delegate] progress:progressInfo object:[client delegateObject]] ;
	[progressInfo release];
}

static void cg_svnobjc_status_func(void *baton, const char *path, svn_wc_status_t *status)
{
	Client *client = (Client *)baton;
	id<ClientDelegate> clientDelegate = [client delegate];
	
	if (clientDelegate == nil)
		return;
	
	if (![clientDelegate respondsToSelector:@selector(status:object:)])
		return;
	
	Status *statusInfo = [[Status alloc] initWithCObject:status]; 
	[statusInfo setPath:[NSString stringWithUTF8String:path]];
	
	[[client resultSet] addObject:statusInfo];
	[[client delegate] status:statusInfo object:[client delegateObject]] ;
	
	[statusInfo release];
}

static svn_error_t * cg_svnobjc_log_msg_func(const char **log_msg, const char **tmp_file,  apr_array_header_t *commit_items, void *baton, apr_pool_t *pool)
{
	*tmp_file = NULL;
	*log_msg = baton;
	
	return SVN_NO_ERROR;
}

static svn_error_t* cg_svnobjc_info_receiver_func(void *baton, const char *path, const svn_info_t *info, apr_pool_t *pool)
{
	return SVN_NO_ERROR;
}

static svn_error_t* cg_svnobjc_log_receiver_func(void *baton, apr_hash_t *changed_paths, svn_revnum_t revision, const char *author, const char *date,const char *message, apr_pool_t *pool)
{
	Client *client = (Client *)baton;
	id<ClientDelegate> clientDelegate = [client delegate];
	
	if (clientDelegate == nil)
		return SVN_NO_ERROR;
	
	if (![clientDelegate respondsToSelector:@selector(log:object:)])
		return SVN_NO_ERROR;
	
	Log *logInfo = [[Log alloc] init];
    [logInfo setRevision:revision];
    [logInfo setAuthor:[NSString stringWithUTF8String:author]];
    [logInfo setDate:[NSString stringWithUTF8String:date]];
    [logInfo setMessage:[NSString stringWithUTF8String:message]];
	[[client delegate] log:logInfo object:[client delegateObject]];
	[logInfo release];
    
	return SVN_NO_ERROR;
}

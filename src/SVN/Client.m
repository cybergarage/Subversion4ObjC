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

#include <svn_client.h>
#include <svn_pools.h>
#include <svn_path.h>

@implementation Client

@synthesize ctx;
@synthesize auth;
@synthesize fs;
@synthesize delegate;
@synthesize delegateObject;
@synthesize lists;
@synthesize errorMessage;

static svn_error_t* cg_svnobjc_client_get_commit_log3(const char **log_msg, const char **tmp_file, const apr_array_header_t *commit_items, void *baton, apr_pool_t *pool);
static void cg_svnobjc_ra_progress_notify_func(apr_off_t progress, apr_off_t total, void *baton, apr_pool_t *pool);
static void cg_svnobjc_wc_notify_func2(void *baton, const svn_wc_notify_t *notify, apr_pool_t *pool);
static svn_error_t* cg_svnobjc_cancel_func(void *cancel_baton);

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
	
	ctx->log_msg_func3 = cg_svnobjc_client_get_commit_log3;
	ctx->log_msg_baton3 = self;
	
	ctx->cancel_func = cg_svnobjc_cancel_func;
	ctx->cancel_baton = self;

	ctx->progress_func = cg_svnobjc_ra_progress_notify_func;
	ctx->progress_baton = self;
	
	[self setAuth:[[[Auth alloc] initWithPool:aPool] autorelease]];
	if (![self auth]) {
		[self release];
		return nil;
	}	
	svn_auth_open (&ctx->auth_baton, [[self auth] providers], [[self pool] pool]);

	return self;	
}

- (id)init
{
	return [self initWithPool:[Pool sharedInstance]];
}

-(void)dealloc
{
	[super dealloc];
}

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
		[self setErrorMessage:[NSString stringWithUTF8String:err->message]];
		return NO;
	}

	NSMutableArray *listArray = [NSMutableArray array];
	for (apr_hash_index_t *hi = apr_hash_first ([[self pool] pool], dirents); hi; hi = apr_hash_next (hi)){
		const char *entryname;
		svn_dirent_t *val;
		apr_hash_this (hi, (void *) &entryname, NULL, (void *) &val);
		[listArray addObject:[NSString stringWithUTF8String:entryname]];
	}
	
	[self setLists:listArray];
		 
	return YES;
}

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
		[self setErrorMessage:[NSString stringWithUTF8String:err->message]];
		return NO;
	}
	
	return YES;
}

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
		[self setErrorMessage:[NSString stringWithUTF8String:err->message]];
		return NO;
	}
	
	return YES;
}

- (BOOL)cleanup:(NSString *)path
{
	svn_error_t *err = svn_client_cleanup(
									  [path UTF8String], 
									  [self ctx], 
									  [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[NSString stringWithUTF8String:err->message]];
		return NO;
	}
	
	return YES;
}

- (BOOL)unlock:(NSString *)path
{
	apr_array_header_t *targets = apr_array_make ([[self pool] pool], 1, sizeof (const char *));
	APR_ARRAY_PUSH (targets, const char *) = [path UTF8String];
	
	svn_error_t *err = svn_client_unlock(targets,
										 TRUE,
										 [self ctx], 
										 [[self pool] pool]);
	
	if (err ){
		[self setErrorMessage:[NSString stringWithUTF8String:err->message]];
		return NO;
	}
	
	return YES;
}

@end

static svn_error_t* cg_svnobjc_client_get_commit_log3(const char **log_msg, const char **tmp_file, const apr_array_header_t *commit_items, void *baton, apr_pool_t *pool)
{
	return SVN_NO_ERROR;
}

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


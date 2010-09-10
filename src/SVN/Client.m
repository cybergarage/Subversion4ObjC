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

static svn_error_t* cg_svnobjc_client_get_commit_log3(const char **log_msg, const char **tmp_file, const apr_array_header_t *commit_items, void *baton, apr_pool_t *pool);
static void cg_svnobjc_ra_progress_notify_func(apr_off_t progress, apr_off_t total, void *baton, apr_pool_t *pool);
static void cg_svnobjc_wc_notify_func2(void *baton, const svn_wc_notify_t *notify, apr_pool_t *pool);
static svn_error_t* cg_svnobjc_cancel_func(void *cancel_baton);

- (id)initWithPool:(Pool *)aPool
{
	svn_error_t *err;
	
	if (self = [super initWithPool:aPool])
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

-(void)dealloc
{
	[super dealloc];
}

- (BOOL)checkout
{
	//Apr *apr = [Apr sharedInstance];
	
	return YES;
}

- (BOOL)ls:(NSString *)url
{
	apr_hash_t *dirents;
	svn_opt_revision_t revision;
	
	/* Main call into libsvn_client does all the work. */
	svn_error_t *err = svn_client_ls (&dirents,
						 [url UTF8String], &revision,
						 FALSE, /* no recursion */
						 [self ctx], [[self pool] pool]);
	if (err ){
		svn_handle_error2 (err, stderr, FALSE, "minimal_client: ");
		return NO;
	}
	
	/* Print the dir entries in the hash. */
	for (apr_hash_index_t *hi = apr_hash_first ([[self pool] pool], dirents); hi; hi = apr_hash_next (hi)){
		const char *entryname;
		svn_dirent_t *val;
		
		apr_hash_this (hi, (void *) &entryname, NULL, (void *) &val);
		printf ("   %s\n", entryname);
		
		/* 'val' is actually an svn_dirent_t structure; a more complex
		 program would mine it for extra printable information. */
	}
	
	return YES;
}

@end

static svn_error_t* cg_svnobjc_client_get_commit_log3(const char **log_msg, const char **tmp_file, const apr_array_header_t *commit_items, void *baton, apr_pool_t *pool)
{
	return SVN_NO_ERROR;
}

static void cg_svnobjc_wc_notify_func2(void *baton, const svn_wc_notify_t *notify, apr_pool_t *pool)
{
}


static svn_error_t* cg_svnobjc_cancel_func(void *cancel_baton)
{
	return SVN_NO_ERROR;
}

static void cg_svnobjc_ra_progress_notify_func(apr_off_t progress, apr_off_t total, void *baton, apr_pool_t *pool)
{
}


//
//  Auth.h
//  iSubversion
//
//  Created by Satoshi Konno on 10/09/10.
//  Copyright 2010 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SVN/Core.h>

#include <svn_auth.h>

@interface AuthCred : NSObject {
	NSString *user;
	NSString *password;
}
@property(retain) NSString *user;
@property(retain) NSString *password;
- (id)init;
-(BOOL)hasUser;
-(BOOL)hasPassword;
@end

@protocol AuthDelegate
- (BOOL)simplePrompt:(AuthCred *)authCred object:(NSObject *)object;
- (BOOL)usernamePrompt:(AuthCred *)authCred object:(NSObject *)object;
@end

@interface Auth : Core {
	apr_array_header_t *providers;
	id<AuthDelegate> delegate;
	NSObject *delegateObject;
}

@property(nonatomic, assign) apr_array_header_t *providers;
@property(nonatomic, assign) id<AuthDelegate> delegate;
@property(retain) NSObject *delegateObject;

- (id)initWithPool:(Pool *)aPool;

@end


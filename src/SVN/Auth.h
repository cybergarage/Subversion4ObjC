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
	NSString *username;
	NSString *password;
}
@property(retain) NSString *username;
@property(retain) NSString *password;
- (id)init;
@end

@protocol AuthDelegate
- (BOOL)simplePrompt:(AuthCred *)authCred;
- (BOOL)usernamePrompt:(AuthCred *)authCred;
@end

@interface Auth : Core {
	apr_array_header_t *providers;
	id<AuthDelegate> delegate;
}
@property(nonatomic, assign) apr_array_header_t *providers;
@property(nonatomic, assign) id<AuthDelegate> delegate;
- (id)initWithPool:(Pool *)aPool;
@end


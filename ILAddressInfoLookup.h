//
//  ILAddressInfo.h
//
// Copyright (c) 2011 Ipanema Labs LLC (http://ipanemalabs.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "ILAddressInfo.h"


@protocol ILAddressInfoLookupDelegate;

@interface ILAddressInfoLookup : NSObject

@property (nonatomic, assign) NSObject<ILAddressInfoLookupDelegate> *delegate;

- (ILAddressInfoLookup *)initWithKey:(NSString *)apiKey andPlaceReference:(NSString *)placeReference;
- (void)startAsynchronous;
- (void)cancel;

@end


@protocol ILAddressInfoLookupDelegate

@optional
- (void)addressInfo:(ILAddressInfoLookup *)infoLookup didFindAddressInfo:(ILAddressInfo *)info;
- (void)addressInfo:(ILAddressInfoLookup *)infoLookup didFailWithError:(NSError *)error;

@end


//
//  ILGooglePlacesAutocomplete.m
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

#import "ILAddressAutocomplete.h"
#import "ILAddressPrediction.h"
#import "JSONKit.h"


@interface NSString (URLEncoding)
- (NSString *)encodedURLParameterString;
@end


@interface ILAddressAutocomplete ()

@property (nonatomic, assign) NSMutableData *responseData;
@property (nonatomic, assign) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableURLRequest *request;

@end


@implementation ILAddressAutocomplete

@synthesize delegate;
@synthesize request;
@synthesize urlConnection;
@synthesize responseData;


- (ILAddressAutocomplete *)initWithKey:(NSString *)apiKey andAddress:(NSString *)address
{
    if (self = [super init]) {
        self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/autocomplete/json"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"false" forKey:@"sensor"];
        [parameters setValue:[address encodedURLParameterString] forKey:@"input"];
        [parameters setValue:apiKey forKey:@"key"];

        NSMutableArray *paramStringsArray = [NSMutableArray arrayWithCapacity:[[parameters allKeys] count]];
        for(NSString *key in [parameters allKeys]) {
            NSObject *paramValue = [parameters valueForKey:key];
            [paramStringsArray addObject:[NSString stringWithFormat:@"%@=%@", key, paramValue]];
        }
        NSString *paramsString = [paramStringsArray componentsJoinedByString:@"&"];
        NSString *baseAddress = request.URL.absoluteString;
        baseAddress = [baseAddress stringByAppendingFormat:@"?%@", paramsString];
        [self.request setURL:[NSURL URLWithString:baseAddress]];
    }
    
    return self;
}

- (void)startAsynchronous
{
    responseData = [[NSMutableData alloc] init];
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)cancel
{
    self.request = nil;
    self.delegate = nil;

    [responseData release];
    [urlConnection cancel];
    [urlConnection release];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(autocompleter:didFailWithError:)]) {
        [delegate autocompleter:self didFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *responseDict = [responseData objectFromJSONData];

    NSArray *resultsArray = [responseDict valueForKey:@"predictions"];
    NSMutableArray *predictions = [NSMutableArray arrayWithCapacity:[resultsArray count]];
    
    if (responseDict == nil || resultsArray == nil || [resultsArray count] == 0) {
        [self connection:connection didFailWithError:nil];
        return;
    }
    
    for (NSDictionary *predictionDict in resultsArray) {
        ILAddressPrediction *prediction = [[[ILAddressPrediction alloc] init] autorelease];
        prediction.description = [predictionDict valueForKey:@"description"];
        prediction.identifier = [predictionDict valueForKey:@"id"];
        prediction.reference = [predictionDict valueForKey:@"reference"];
        [predictions addObject:prediction];
    }

    if ([delegate respondsToSelector:@selector(autocompleter:didFindPredictions:)]) {
        [delegate autocompleter:self didFindPredictions:predictions];
    }
}

@end


#pragma mark -

@implementation NSString (URLEncoding)

- (NSString *)encodedURLParameterString {
    NSString *result = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (CFStringRef)self,
                                                                          NULL,
                                                                          CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                          kCFStringEncodingUTF8);
    return [result autorelease];
}

@end


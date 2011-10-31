# ILAddressAutocomplete

ILAddressAutocomplete is a simple wrapper on top of Google Places Autocomplete API. It was created because I needed to provide a list of address suggestions based on user input. ILAddressAutocomplete is the class used to find the address suggestions via this API, but the results don't include the GPS coordinate of the address.

There's ILAddressInfoLookup for that purpose, which uses a different API call to fetch the GPS coordinate. Usage is very similar in both cases, with a couple of delegate methods that need to be implemented to receive the details.


## Example Usage

### Address autocomplete request

``` objective-c
- (void)showAutocompleteSuggestions
{
    NSString *mispelledAddress = @"Yoktown Street, Houston";
    ILAddressAutocomplete *autocompleter = [[ILAddressAutocomplete alloc] initWithKey:kGoogleAutocompleteApiKey andAddress:mispelledAddress];
    autocompleter.delegate = self;
    [autocompleter startAsynchronous];
}

\#pragma mark -
\#pragma mark ILAddressAutocompleteDelegate methods

- (void)autocompleter:(ILAddressAutocomplete *)autocompleter didFindPredictions:(NSArray *)predictions
{
    // array of ILAddressPrediction objects
}

- (void)autocompleter:(ILAddressAutocomplete *)autocompleter didFailWithError:(NSError *)error
{
    // show error to user?
}
```

### Address information lookup request

``` objective-c
- (void)fetchAddressInfo
{
    ILAddressPrediction *prediction;
    // ...
    // The prediction object is created via the ILAddressAutocomplete delegate method
    // ...

    ILAddressInfoLookup *lookup = [[ILAddressInfoLookup alloc] initWithKey:kGoogleAutocompleteApiKey andPlaceReference:prediction.reference];
    lookup.delegate = self;
    [lookup startAsynchronous];
}

\#pragma mark -
\#pragma mark ILAddressInfoLookupDelegate methods

- (void)addressInfo:(ILAddressInfoLookup *)infoLookup didFindAddressInfo:(ILAddressInfo *)info
{
    NSLog(@"address coordinate = %f,%f", info.coordinate.latitude, info.coordinate.longitude);
}

- (void)addressInfo:(ILAddressInfoLookup *)infoLookup didFailWithError:(NSError *)error
{
    // show error to user?
}
```


## Dependencies

* [JSONKit](https://github.com/johnezang/JSONKit)


## Contact

Joao Prado Maia

- http://ipanemalabs.com
- http://github.com/joaopmaia
- http://twitter.com/joaopmaia
- jpm@ipanemalabs.com


## License

ILAddressAutocomplete is available under the MIT license. See the LICENSE file for more info.


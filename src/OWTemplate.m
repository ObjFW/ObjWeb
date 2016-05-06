/*
 * Copyright (c) 2013, 2016, Jonathan Schleifer <js@webkeks.org>
 *
 * https://heap.zone/git/?p=objweb.git
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice is present in all copies.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "OWTemplate.h"

#import "OWTemplateMissingException.h"

static OFDictionary *templates = nil;

@implementation OWTemplate
@synthesize content = _content;

+ (void)initialize
{
	void *pool;
	OFFileManager *fileManager;
	OFArray *files;
	OFMutableDictionary *tmp;

	if (self != [OWTemplate class])
		return;

	pool = objc_autoreleasePoolPush();

	fileManager = [OFFileManager defaultManager];
	files = [fileManager contentsOfDirectoryAtPath: @"templates"];
	tmp = [OFMutableDictionary dictionaryWithCapacity: [files count]];

	for (OFString *file in files) {
		OFString *name, *path;
		OWTemplate *template;

		if (![file hasSuffix: @".html"])
			continue;

		name = [file stringByDeletingPathExtension];
		path = [@"templates" stringByAppendingPathComponent: file];

		template = [[[OWTemplate alloc] init] autorelease];
		template->_content = [[OFString alloc]
		    initWithContentsOfFile: path];

		[tmp setObject: template
			forKey: name];
	}

	[tmp makeImmutable];
	templates = [tmp retain];

	objc_autoreleasePoolPop(pool);
}

+ (instancetype)templateForName: (OFString*)name
{
	OWTemplate *template = [templates objectForKey: name];

	if (template == nil)
		@throw [OWTemplateMissingException exceptionWithName: name];

	return template;
}

- (void)dealloc
{
	[_content release];

	[super dealloc];
}

- (OFString*)contentWithVariables: (OFDictionary*)variables
{
	OFMutableString *ret = [OFMutableString string];
	void *pool = objc_autoreleasePoolPush();
	size_t i, last;

	if ([variables count] == 0)
		return [self content];

	i = [_content rangeOfString: @"${"].location;
	last = 0;

	while (i < _content.length) {
		OFString *name, *value;
		size_t end;

		[ret appendString:
		    [_content substringWithRange: of_range(last, i - last)]];

		end = [_content
		    rangeOfString: @"}"
			  options: 0
			    range: of_range(i, _content.length - i)].location;

		name = [_content
		    substringWithRange: of_range(i + 2, end - i - 2)];
		value = [[variables objectForKey: name] description];

		if (![name hasPrefix: @"="])
			value = [value stringByXMLEscaping];

		if (value == nil)
			value = @"";

		[ret appendString: value];

		last = end + 1;
		i = [_content
		    rangeOfString: @"${"
		    options: 0
		      range: of_range(end, _content.length - end)].location;
	}

	[ret appendString: [_content substringWithRange:
	    of_range(last, _content.length - last)]];

	[ret makeImmutable];

	objc_autoreleasePoolPop(pool);

	return ret;
}
@end

@implementation OFStream (OWTemplate)
- (void)writeTemplate: (OFString*)name
{
	[self writeString: [[OWTemplate templateForName: name] content]];
}

- (void)writeTemplate: (OFString*)name
	    variables: (OFDictionary*)variables
{
	[self writeString: [[OWTemplate templateForName: name]
	    contentWithVariables: variables]];
}
@end

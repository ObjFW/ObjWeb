/*
 * Copyright (c) 2016, Jonathan Schleifer <js@webkeks.org>
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

#import "TestsAppDelegate.h"

static OFString *module = @"OWTemplate";

@implementation TestsAppDelegate (OWTemplateTests)
- (void)templateTests
{
	void *pool = objc_autoreleasePoolPush();
	OWTemplate *tmpl;
	OFDictionary *vars;

	TEST(@"Initialization", [OWTemplate class])

	TEST(@"Loading a template",
	    (tmpl = [OWTemplate templateForName: @"test"]))

	EXPECT_EXCEPTION(@"Template missing exception",
	    OWTemplateMissingException,
	    (tmpl = [OWTemplate templateForName: @"missing"]))

	TEST(@"Template content",
	    [[tmpl content] isEqual: @"This is an ${=unescaped} ${test}.\n"])


	vars = [OFDictionary dictionaryWithKeysAndObjects:
	    @"test", @"<b>test</b>",
	    @"=unescaped", @"<i>unescaped</i>", nil];
	TEST(@"Variables and escaping",
	    [[tmpl contentWithVariables: vars] isEqual:
	    @"This is an <i>unescaped</i> &lt;b&gt;test&lt;/b&gt;.\n"])

	objc_autoreleasePoolPop(pool);
}
@end

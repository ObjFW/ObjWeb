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

#import <ObjFW/ObjFW.h>

#define TEST(test, ...)							\
	{								\
		[of_stdout writeFormat: @"[%@] %@: ", module, test];	\
									\
		if (__VA_ARGS__)					\
			[of_stdout writeLine: @"ok"];			\
		else {							\
			[of_stdout writeLine: @"FAILED"];		\
			_fails++;					\
		}							\
	}
#define EXPECT_EXCEPTION(test, exception, code)				\
	{								\
		bool caught = false;					\
									\
		[of_stdout writeFormat: @"[%@] %@: ", module, test];	\
									\
		@try {							\
			code;						\
		} @catch (exception *e) {				\
			caught = true;					\
		}							\
									\
		if (caught)						\
			[of_stdout writeLine: @"ok"];			\
		else {							\
			[of_stdout writeLine: @"FAILED"];		\
			_fails++;					\
		}							\
	}
#define R(...) (__VA_ARGS__, 1)

@interface TestsAppDelegate: OFObject <OFApplicationDelegate>
{
	int _fails;
}
@end

@interface TestsAppDelegate (OWTemplateTests)
- (void)templateTests;
@end

# python script

```
#!/usr/bin/env python3

def main():
	pass

if __name__ == "__main__":
    main()
```

# Assert equal
self.assertEqual(${1:${VISUAL:first}}, ${2:second})

# django test class

```
from django.test import TestCase

class Test${1:Class}(TestCase):
	def test_${2:name}(self):
		${3:${VISUAL:pass}}
```

# django graphql test
```
from oneview.tests.graphql import AdminUserMixin, GraphqlTestCase
from oneview.tests.model_mocks import TodoFactory

class Test${1:Class}(AdminUserMixin, GraphqlTestCase):
	def test_${2:name}(self):
		query = """
			mutation fooBar(
				$todoTodo: ID!,
				$todoTodo: Decimal!,
			) {
				todoTodo(
					todoTodo: $todoTodo,
					todoTodo: $todoTodo,
				) {
					ok
					errors
				}
			}
		"""

		variables = {
			"todoTodo": "todo",
			"todoTodo": "todo",
		}

		response = self.schema.execute(
			query,
			variables=variables,
			context_value=self.admin_context,
		)

		self.assertIsNone(response.errors)
        self.assertTrue(response.data["fooBar"]["ok"])
```

snippet classt "python unittest test class new file" b
from unittest import TestCase

class Test${1:Class}(TestCase):
    def test_${2:name}(self):
		${3:${VISUAL:pass}}

endsnippet

snippet subtest "python unittest subtest" b
for a, b in (("foo", "bar"), ("baz", "bazz")):
	with self.subTest(a=a, b=b):
		self.assertEqual(...)
endsnippet

snippet testdata "python unittest test data class method" b
	@classmethod
	def setUpTestData(cls):
	    pass
endsnippet

snippet logger_test "testing logger with python unittest" b
with self.assertLogs("foo.foo.foo", level="INFO") as logger_context_manager:
    # TODO

self.assertEqual(
	logger_context_manager.output,
	[
	    "INFO:foo.foo.foo:logger message"
	]
)
endsnippet

snippet error_raised_test "testing error with python unittest" b
with self.assertRaises("TODO_SOME_ERROR") as error_context_manager:
	function_that_raises_error()

self.assertTrue('This is broken' in str(error_context_manager.exception))
endsnippet

snippet error_raised_test_message "testing error message with django unittest" b
with self.assertRaisesMessage(ValueError, "invalid literal for int()"):
    pass
endsnippet

#########
# Print #
#########

snippet '([\w.]*)[.]~' "print with padding ~~~" r
`!p snip.rv = f" {match.group(1)} ".center(60, "~")`
endsnippet

#########
# Error #
#########

snippet requests "raise_for_status and logger exception" b
try:
	response = requests.post(url, headers=headers, data=json.dumps(data))
	response.raise_for_status()
except (HTTPError, Timeout) as error:
	_logger.exception(error)
	return FooBar(
		errors=[f"foo bar"],
		ok=False,
	)
endsnippet

snippet requests_all_errors "Catching all possible errors " b
from requests import RequestException
try:
    r = requests.get(url,timeout=3)
    r.raise_for_status()
except RequestException as err:
    print ("OOps: Something Else",err)
endsnippet


snippet mock_response_success "" b
json_response = json.dumps(
    {
        "url": "https://fake_bucket_name.aws.com/fake_file_key",
        "id": expected_document_client_portal_id,
    }
)
mock_response = Response()
mock_response.status_code = 200
mock_response._content = bytes(json_response, encoding="utf-8")

mock_requests.post.return_value = mock_response
endsnippet


snippet mock_response_raise_for_status "" b
mock_response = mock.Mock()
mock_response.raise_for_status.side_effect = HTTPError("Foo")

mock_requests.post.return_value = mock_response
endsnippet

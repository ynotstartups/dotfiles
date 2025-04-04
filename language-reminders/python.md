# python script
```python
#!/usr/bin/env python3

def main():
    pass

if __name__ == "__main__":
    main()
```

# test GraphQL endpoint
```python
from oneview.tests.graphql import AdminUserMixin, GraphqlTestCase
from oneview.tests.model_mocks import TodoFactory

class TestFoo(AdminUserMixin, GraphqlTestCase):
    def test_bar(self):
        query = """
            mutation query(
                $todoTodo: ID!,
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
        }

        response = self.schema.execute(
            query,
            variables=variables,
            context_value=self.admin_context,
        )

        self.assertIsNone(response.errors)
        self.assertTrue(response.data["fooBar"]["ok"])
```

# django test class
```python
from django.test import TestCase

class Test${1:Class}(TestCase):
    def test_${2:name}(self):
        ${3:${VISUAL:pass}}
```

# unittest subtest
```python
for a, b in (("foo", "bar"), ("baz", "bazz")):
    with self.subTest(a=a, b=b):
        self.assertEqual(...)
```

# test setUpTestData
```python
    @classmethod
    def setUpTestData(cls):
        pass
```

# test logger
```python
with self.assertLogs("foo.foo.foo", level="INFO") as logger_context_manager:
    # TODO
    pass

self.assertEqual(
    logger_context_manager.output,
    [
        "INFO:foo.foo.foo:logger message"
    ]
)
```

# test error raised with message
```python
with self.assertRaisesMessage(ValueError, "invalid literal for int()"):
    pass
```

# test freeze time

```python
from freezegun import freeze_time

with freeze_time("2000-01-01T00:00:00", tz_offset=0):
    # TODO: call some function
    pass

self.assertEqual(foo, datetime(2000, 1, 1, 0, 10, 0, tzinfo=pytz.UTC))
```


# mock response success 
```python
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
```

# mock response raised error
```python
mock_response = mock.Mock()
mock_response.raise_for_status.side_effect = HTTPError("Foo")

mock_requests.post.return_value = mock_response
```

# handle raise for status
```python
try:
    response = requests.post(url, headers=headers, data=json.dumps(data))
    response.raise_for_status()
except HTTPError as error:
    _logger.exception(error)
    return FooBar(
        errors=[f"foo bar"],
        ok=False,
    )
```

# catch all possible errors
```python
from requests import RequestException
try:
    r = requests.get(url,timeout=3)
    r.raise_for_status()
except RequestException as error:
    _logger.exception(error)
```

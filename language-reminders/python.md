# python function documentation

```
    Args:
        review (int): The first number.
        b (int): The second number.

    Returns:
        int: The sum of the two numbers.

    Raises:
        HTTPError: when call to Calendar API failed
```
# python script
```python
#!/usr/bin/env python3

def main():
    pass

if __name__ == "__main__":
    main()
```

# add logger

```python
import logging
_logger = logging.getLogger(__name__)
_logger.debug("foo")
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

class TestFoo(TestCase):
    def test_foo(self):
        pass
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

# test error raised
```python
with self.assertRaisesMessage(ValueError, "invalid literal for int()"):
    pass
```
```python
with self.assertRaises(ValueError):
    pass
```

# test freeze time

```python
from freezegun import freeze_time
import pytz

with freeze_time("2000-01-01T00:00:00", tz_offset=0):
    # TODO: call some function
    pass

self.assertEqual(foo, datetime(2000, 1, 1, 0, 0, 0, tzinfo=pytz.UTC))
```

# test with override_settings

```python
from django.test import override_settings

@override_settings(ENABLE_TRUSTS=True)
def test_foo(self):
    pass
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

# test multiple calls
```python
self.assertEqual(
    mock_submit_entity.call_args_list,
    [
        call(entity=pot, data=pot.to_curo(), info=mock.ANY),
        call(entity=task, data=task.to_curo(), info=mock.ANY),
    ],
)
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

# Graphene

## `required=True` and `NonNull`

- `required=True` means that the itself must not be null.

`risk_profiles = graphene.List(graphene.NonNull(lambda: RiskProfileType),
required=True)`

- `graphene.NonNull` means that each risk profile cannot be null.
- `required=True` means that the list itself must not be null.

Translate to graphql schema `riskProfiles: [RiskProfileType!]!`

"""
python utils functions to be used in Vim or Ultisnips

this file is soft linked to ~/.vim/python3/vim_python.py, so it's able to be imported to Vim or Ultisnips.

## Example of using this in Vim

```vim
function! JumpToTestFile()
py3 << EOF
import vim
from vim_python import get_or_create_alternative_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_alternative_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"edit {test_filepath}")
EOF
endfunction
```

command! JumpToTestFile call JumpToTestFile()

## Example of using this in Ultisnips

```python
global !p
from vim_python import write_section
endglobal

snippet "(.*).SS" "Create Section (postfix)" r
`!p snip.rv = write_section(text=match.group(1), comment_character='\"')`
endsnippet
```
"""

import os


def _file_exists(filepath: str) -> bool:
    return os.path.exists(filepath)


def get_alternative_filepath(filepath: str) -> str:
    # from "saltus/oneview/tests/graphql/test_fee.py"
    # to "saltus/oneview/graphql/api/fee.py"
    if "graphql" in filepath and "test_" in filepath:
        source_filepath = filepath.replace("test_", "").replace("tests/", "")
        splitted_filepath = source_filepath.split("/")
        splitted_filepath.insert(-1, "api")
        result_source_filepath = "/".join(splitted_filepath)
        if _file_exists(result_source_filepath):
            return result_source_filepath

    if "test_" in filepath.split("/")[-1]:
        # convert test filepath to filepath
        return filepath.replace("test_", "").replace("tests/", "")

    # convert filepath to test filepath
    if not filepath.startswith("saltus/"):
        splitted_filepath = filepath.split("/")
        splitted_filepath[-1] = f"test_{splitted_filepath[-1]}"
        result_filepath = "/".join(splitted_filepath)
        return result_filepath

    splitted_filepath = filepath.split("/")
    splitted_filepath.insert(2, "tests")
    splitted_filepath[-1] = f"test_{splitted_filepath[-1]}"
    result_filepath = "/".join(splitted_filepath)

    # from "saltus/oneview/graphql/api/fee.py"
    # to "saltus/oneview/tests/graphql/test_fee.py"
    result_filepath_without_api_folder = result_filepath.replace("api/", "")
    if _file_exists(result_filepath_without_api_folder):
        return result_filepath_without_api_folder

    return result_filepath


def get_or_create_alternative_file(filepath: str) -> None:
    alternative_filepath = get_alternative_filepath(filepath)
    if not os.path.exists(alternative_filepath):
        with open(alternative_filepath, "w"):
            pass
    return alternative_filepath


package_and_word = {
    "abc": ["ABC", "abstractmethod"],
    "collections": ["Counter", "defaultdict"],
    "copy": ["copy", "deepcopy"],
    "dataclasses": ["asdict", "dataclass"],
    "datetime": ["date", "datetime", "timedelta"],
    "decimal": ["Decimal"],
    "django.apps": ["AppConfig", "apps", "apps as django_apps"],
    "django.conf": ["settings"],
    "django.contrib": ["admin"],
    "django.contrib.auth": ["get_user_model"],
    "django.contrib.auth.hashers": ["make_password"],
    "django.contrib.auth.models": ["Group", "Permission", "UserManager"],
    "django.contrib.contenttypes.models": ["ContentType"],
    "django.contrib.postgres.fields": ["ArrayField"],
    "django.core": ["checks", "serializers"],
    "django.core.checks": ["register"],
    "django.core.exceptions": [
        "BadRequest",
        "FieldDoesNotExist",
        "FieldError",
        "ImproperlyConfigured",
        "ObjectDoesNotExist",
        "ValidationError",
    ],
    "django.core.mail": ["get_connection", "send_mail"],
    "django.core.management": [
        "BaseCommand",
        "CommandError",
        "CommandParser",
        "call_command",
        "execute_from_command_line",
    ],
    "django.core.management.base": ["BaseCommand", "CommandError", "SystemCheckError"],
    "django.core.serializers.json": ["DjangoJSONEncoder"],
    "django.core.validators": ["EmailValidator"],
    "django.core.wsgi": ["get_wsgi_application"],
    "django.db": [
        "IntegrityError",
        "connection",
        "migrations",
        "models",
        "transaction",
    ],
    "django.db.migrations.executor": ["MigrationExecutor"],
    "django.db.models": [
        "CheckConstraint",
        "ForeignKey",
        "Model",
        "Q",
        "QuerySet",
        "F",
    ],
    "django.db.models.signals": ["m2m_changed", "post_save", "pre_save"],
    "django.db.utils": ["IntegrityError"],
    "django.dispatch": ["receiver"],
    "django.http": ["HttpResponse", "JsonResponse", "HttpRequest"],
    "django.http.response": ["HttpResponseRedirect"],
    "django.shortcuts": ["HttpResponse"],
    "django.test": [
        "RequestFactory",
        "TestCase",
        "TransactionTestCase",
        "override_settings",
    ],
    "django.test.client": ["RequestFactory"],
    "django.test.utils": ["override_settings"],
    "django.urls": ["path", "reverse"],
    "django.utils": ["timezone"],
    "django.utils.decorators": ["method_decorator"],
    "django.utils.functional": ["classproperty", "lazy"],
    "django.utils.html": ["format_html"],
    "django.utils.timezone": ["make_aware"],
    "django.views.decorators.csrf": ["csrf_exempt"],
    "django_cognito_jwt": ["JSONWebTokenAuthentication"],
    "django_cognito_jwt.validator": ["TokenValidator"],
    "enum": ["Enum", "Enum as EnumOriginal"],
    "factory": ["Faker as FactoryFaker"],
    "factory.django": ["DjangoModelFactory"],
    "freezegun": ["freeze_time"],
    "functools": ["lru_cache", "reduce", "wraps"],
    "graphene": ["Enum", "Schema", "relay"],
    "graphene.test": ["Client"],
    "graphene_django": ["DjangoObjectType"],
    "graphene_django.debug": ["DjangoDebug"],
    "graphene_django.views": ["GraphQLView"],
    "graphql": ["GraphQLError"],
    "graphql_relay.connection.connectiontypes": ["Edge"],
    "guardian.shortcuts": ["assign_perm"],
    "hashlib": ["md5"],
    "http": ["HTTPStatus"],
    "io": ["BytesIO"],
    "itertools": ["chain", "groupby"],
    "jinja2": ["Template as Jinja2Template"],
    "json": ["JSONDecodeError"],
    "logging.handlers": ["TimedRotatingFileHandler"],
    "lxml": ["etree"],
    "moto": ["mock_cognitoidp", "mock_s3"],
    "my_app": ["views"],
    "os": ["path"],
    "other_app.views": ["Home"],
    "pathlib": ["Path"],
    "pprint": ["pp"],
    "promise": ["Promise"],
    "promise.dataloader": ["DataLoader"],
    "public_api.views": ["XperidocDataConnector"],
    "pymssql": ["OperationalError"],
    "pytz": ["UTC"],
    "re": ["compile"],
    "requests": ["HTTPError", "Response"],
    "requests.exceptions": ["Timeout"],
    "rest_framework": ["HTTP_HEADER_ENCODING", "serializers", "status"],
    "rest_framework.authentication": ["TokenAuthentication"],
    "rest_framework.authtoken.models": ["Token"],
    "rest_framework.exceptions": ["AuthenticationFailed", "NotFound"],
    "rest_framework.generics": ["GenericAPIView"],
    "rest_framework.permissions": ["BasePermission", "IsAuthenticated"],
    "rest_framework.request": ["Request"],
    "rest_framework.test": ["APIClient"],
    "rest_framework.views": ["APIView"],
    "sentry_sdk": ["capture_exception", "push_scope"],
    "sentry_sdk.integrations.celery": ["CeleryIntegration"],
    "sentry_sdk.integrations.django": ["DjangoIntegration"],
    "sentry_sdk.integrations.logging": ["ignore_logger"],
    "simple_history.admin": ["SimpleHistoryAdmin"],
    "simple_history.models": ["HistoricalRecords"],
    "simple_history.utils": ["update_change_reason"],
    "socket": ["socket"],
    "sshtunnel": ["SSHTunnelForwarder"],
    "tempfile": ["NamedTemporaryFile"],
    "threading": ["Thread"],
    "time": ["time_ns"],
    "typing": [
        "Any",
        "Callable",
        "Dict",
        "Iterable",
        "Iterator",
        "List",
        "Optional",
        "Tuple",
        "Type",
        "Union",
        "cast",
        "Literal",
        "TypedDict",
    ],
    "unittest": ["mock"],
    "unittest.mock": ["MagicMock", "Mock", "PropertyMock", "call", "patch"],
    "urllib.parse": ["urlparse"],
    "uuid": ["UUID", "uuid4"],
    "dateutil.relativedelta": ["relativedelta"],
    "boto3": [],
}


def get_import_path_given_word(vim: object) -> str | None:
    word = vim.eval('expand("<cword>")')

    for package, words in package_and_word.items():
        if word == package:
            import_string = f"import {word}"
            print(import_string)
            return import_string

        if word in words:
            import_string = f"from {package} import {word}"
            print(import_string)
            return import_string

    taglists = vim.eval(f'taglist("{word}")')
    if taglists:
        tag = taglists[0]
        filename = tag["filename"]
        from_string = (
            filename.removeprefix("saltus/")
            .removesuffix("/__init__.py")
            .removesuffix(".py")
            .replace("/", ".")
        )
        import_string = f"from {from_string} import {word}"
        print(import_string)
        return import_string


def format_markdown_table(vim: object) -> None:
    """
    Convert to

    |foo|bar|
    |-|-|
    |abc|def|

    | foo | bar |
    |-----|-----|
    | abc | def |
    """

    # assume range is used for now

    look_behind_index = vim.current.range.start
    while True:
        if not vim.current.buffer[look_behind_index].startswith("|"):
            table_start_row_number = look_behind_index + 1
            break
        look_behind_index -= 1

    look_ahead_index = vim.current.range.start
    while True:
        if not vim.current.buffer[look_ahead_index].startswith("|"):
            table_end_row_number = look_ahead_index
            break
        look_ahead_index += 1

    table_rows = vim.current.buffer[table_start_row_number:table_end_row_number]

    number_of_columns = table_rows[0].count("|") - 1
    for line_number, line in enumerate(table_rows):
        if line.count("|") - 1 > number_of_columns:
            print(
                f"Not support table with extra number of '|' seperator. Extra '|' in row {line_number}"
            )
            return

    formatted_table = [[] for i in range(number_of_columns)]
    # loop for each column
    for column_number in range(number_of_columns):
        max_words_length = 0
        # loop for each row
        for line_number, line in enumerate(table_rows):
            # ignores the title and table content seperator line
            if line_number == 1:
                continue
            word_in_column = line.split("|")[1:-1][column_number].strip()
            if len(word_in_column) > max_words_length:
                max_words_length = len(word_in_column)
        max_words_length = max_words_length + 2

        for line_number, line in enumerate(table_rows):
            # write the table content seperator line
            if line_number == 1:
                formatted_table[column_number].append("|" + "-" * max_words_length)
                continue

            word_in_column = line.split("|")[1:-1][column_number].strip()
            formatted_table[column_number].append(
                "| " + word_in_column.ljust(max_words_length - 1)
            )

    transposed_table = list(map(list, zip(*formatted_table)))
    for line_number, line in enumerate(transposed_table):
        vim.current.buffer[look_behind_index + 1 + line_number] = "".join(line) + "|"
    return formatted_table


def format_to_factory_style(
    vim: object, start_line_number: int, end_line_number: int
) -> None:
    """
    start_line_number: start line number of vim range (line number starts with 1)
    end_line_number:     end line number of vim range
    They are passed in from vim function FormatToFactoryStyle using `py3eval` trick.

    convert from
        ```
        parent_rec = Recommendation()
        parent_rec.product_scheme = product_4
        ```
    to
        ```
        parent_rec = RecommendationFactory(
        product_scheme = product_4,)
        ```
    """
    updated_lines = []
    for line in vim.current.buffer[start_line_number - 1 : end_line_number]:
        # first line
        if line == vim.current.buffer[start_line_number - 1]:
            # calculate the indentation for the rest of the lines
            number_of_indented_spaces = len(line) - len(line.lstrip(" "))
            indentation = " " * number_of_indented_spaces
            new_line = line
            new_line = new_line.replace("(", "Factory(").replace(")", "")
        else:
            # this simple logics removes the indentation at the front of the line logics
            new_line = "".join(line.split(".")[2:])
            new_line = indentation + new_line
            new_line += ","
            # closes the Factory class with ')'
            if line == vim.current.buffer[end_line_number - 1]:
                new_line += ")"

        updated_lines.append(new_line)

    for lines in updated_lines:
        print(lines)
    vim.current.buffer[start_line_number - 1 : end_line_number] = updated_lines
    return None

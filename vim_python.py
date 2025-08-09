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


def write_section(text: str, comment_character: str = "#") -> str:
    """
    from:
    example text

    to:
    ################
    # example text #
    ################
    """

    COMMENT_CHARACTER = comment_character

    length_text = len(text)
    top_border = bottom_border = COMMENT_CHARACTER * (length_text + 4) + "\n"
    left_border = f"{COMMENT_CHARACTER} "
    right_border = f" {COMMENT_CHARACTER}\n"
    return f"{top_border}{left_border}{text}{right_border}{bottom_border}"

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
    result_filepath_without_api_folder = result_filepath.replace('api/', '')
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
    "django.db.models": ["CheckConstraint", "ForeignKey", "Model", "Q", "QuerySet"],
    "django.db.models.signals": ["m2m_changed", "post_save", "pre_save"],
    "django.db.utils": ["IntegrityError"],
    "django.dispatch": ["receiver"],
    "django.http": ["HttpResponse", "JsonResponse"],
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

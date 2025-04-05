# String single quote vs double quote

- `''` - no escaping and no interpolation
- `""` - escaping and interpolation

# String Interpolation

`$"interpolate variable {foo}"`

Note: I need to escape `\` like this `\\`. So if there are lots of `\\` don't
use `$` interpolations, use single quote like this
`':s/\(\w*\)[:=,].*/\1=\1,/g' .. "\<cr>"`.

# option v.s. Ex / command line mode special characters

`filetype` is a vim option, this vim option tells vim what kind of file you
are editing.
`<cword>` is a Ex command line special character.

```vim
:echo &filetype
var filetype = &filetype

:echo expand('<cword>')
var word_under_cursor = expand('<cword>')
```

# catch exception

```vim
try
    tabmove +
catch /E475:/
    # error when this is the last tab
    # move the tab to the very left
    tabmove 0
endtry
```

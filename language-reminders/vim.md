# String single quote vs double quote

- `''` - no escaping and no interpolation
- `""` - escaping and interpolation

# String Interpolation

`$"interpolate variable {foo}"`

Note: I need to escape `\` like this `\\`. So if there are lots of `\\` don't
use `$` interpolations, use single quote like this
`':s/\(\w*\)[:=,].*/\1=\1,/g' .. "\<cr>"`.


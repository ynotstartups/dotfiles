if exists("b:current_syntax")
  finish
endif

syn region jiraString oneline start='.' end='$' contained

syntax match jiraHeader "\vh1.*$"

syn keyword jiraKeyword TITLE COMPONENT EPIC LABELS nextgroup=jiraString

let b:current_syntax = "jira"

hi def link jiraKeyword Todo
hi def link jiraString String
hi def link jiraHeader Label

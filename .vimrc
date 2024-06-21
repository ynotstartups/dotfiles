vim9script
##################
# Documentations #
##################

# vim's library is at /usr/share/vim/vim90/

set nocompatible

# auto install vim plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

plug#begin('~/.vim/plugged')
Plug 'Raimondi/delimitMate'            # automatic closing of quotes, parenthesis, brackets, etc.
Plug 'SirVer/ultisnips'                # snippets, snippet files are in `Documents/dotfiles/UltiSnips`
Plug '~/Documents/completor.vim'       # fuzzy completor
Plug 'markonm/traces.vim'              # preview substitute and regex pattern
Plug 'osyo-manga/vim-anzu'             # `n` shows the number of searches
Plug 'haya14busa/vim-asterisk'         # `*` stays where it is instead of jumping to next match
Plug 'junegunn/fzf'                    # fzf
Plug 'junegunn/fzf.vim'                # fzf vim
Plug 'liuchengxu/vista.vim'            # `:Vista` for tag viewer & markdown table of contents
Plug 'easymotion/vim-easymotion'       # `,` to jump around the code
Plug 'preservim/nerdtree', { 'on': 'NERDTreeFind' } # tree folder explorers, `<leader>n` to open
Plug 'inkarkat/vim-visualrepeat'       # in visual mode, use . to repeat in selected lines
Plug 'tpope/vim-repeat'                # repeat vim-surround with .
Plug 'tpope/vim-surround'              # `ds` to delete, `cs` to change and `ys` to add surroundings ', ", ` 

# git
Plug 'airblade/vim-gitgutter'          # shows git add/modify/remove symbols on the left
Plug 'tpope/vim-fugitive'              # view git blame in vim
Plug 'tpope/vim-rhubarb'               # `:GBrowse` to open code in github

# additional `g` commands
Plug 'junegunn/vim-easy-align'         # `ga=` align first =, ga2= align second =, ga*= align all =
Plug 'tpope/vim-commentary'            # `gc` for making comments
Plug 'vim-scripts/ReplaceWithRegister' # `gr` go replace
Plug 'arthurxavierx/vim-caser'         # `gs` changes word casing e.g. `gsc` FooBar, `gs_` foo_bar, `gsu` FOO_BAR

# syntax highlight
Plug 'ekalinin/Dockerfile.vim'         # dockerfile syntax
Plug 'jparise/vim-graphql'             # graphql syntax highlight
Plug 'plasticboy/vim-markdown'         # add markdown syntax

# additional text objects
Plug 'jeetsukumaran/vim-pythonsense'   # ac, ic, af, if, ad, id python text object
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'           # al     for this line
Plug 'kana/vim-textobj-entire'         # ie     for entire file
Plug 'sgur/vim-textobj-parameter'      # i, a,  for parameters
Plug 'lucapette/vim-textobj-underscore' # i_ a_ for underscore

# for markdown files
Plug 'img-paste-devs/img-paste.vim'    # `<leader>p` to paste image from system clipboard to markdown file 
Plug 'godlygeek/tabular'               # `:TableFormat` to format table

Plug 'tomasr/molokai'                  # molokar colorscheme
plug#end()

# change default leader \ to space, this setting needs to be in the beginning
nnoremap <space> <nop>
g:mapleader = " "

# detect filetype
# use plugins for that filetype
# turn on indent files
# see more in `:help vimrc-filetype`
filetype plugin indent on

# better setting
set number
set relativenumber
set shortmess+=IW # ignore Intro, Written
set laststatus=2 # status bar always on
set wildmenu
set wildmode=longest:full,full # start on the longest option when you hit tab
set hidden # files leave the screen become hidden buffer
set backspace=indent,eol,start
set tabstop=4 # show existing tab with 4 spaces width
set expandtab # In Insert mode: Use the appropriate number of spaces to insert a <tab>
set hlsearch # highlight search result such as when using *
set scrolloff=1 # shows one more line above and below the cursor
set sidescrolloff=5 # similar to above but on the right
set display+=lastline # otherwise last line that doesn't fit is replaced with @ lines, see :help 'display'
set formatoptions+=j # Delete comment character when joining commented lines
set splitright # when using :vsp put the split window to the right
set autoread # automatically apply changes from outside of Vim
set complete-=i # remove included files, it is slow
set shiftwidth=4 # set shiftwidth - default indent
set mouse=a # support mouse in iTerm
set noswapfile
set regexpengine=0 # fix tsx files too slow
set incsearch # incremental search
set belloff=all # no spell from vim
set spellcapcheck= # turn off spell check says first character not captical as error
# set the default errorfile, so that vim -q automatically open quickfix.vim
set errorfile=quickfix.vim

set undodir=~/.vim/undo-dir
set undofile
# search
set ignorecase
set smartcase

# show invisible charaters
# use `:set list`
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:␣,nbsp:+

###############
# Colorscheme #
###############

syntax on
set termguicolors
set background=light
colorscheme molokai

# make the single quote works like a backtick
# puts the cursor on the column of a mark, instead of first non-blank
# character
nnoremap ' `
# instead of using '' to jump to previous mark use '' to jump to last edit
nnoremap '' `.

# qq to record, Q to replay
nnoremap Q @q

# Y to yank to the end of the line, mimic other capital commands
nnoremap Y y$

# copy/paste
# https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamed # vim uses system clipboard

# copy absolute path  e.g. ~/Documents/src/foo.txt
nnoremap <leader>ya :let @+=expand("%:p")<cr>:echo 'yanked' @+<cr>
# copy relative path  e.g. src/foo.txt
nnoremap <leader>yp :let @+=expand("%")<cr>:echo 'yanked' @+<cr>
# copy file name      e.g. foo.txt
nnoremap <leader>yn :let @+=expand("%:t")<cr>:echo 'yanked' @+<cr>

# copy python function & class name
# use with pytest -k FUNCTION NAME
nnoremap <leader>yf ?^[<space>]*\zsdef<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>
# nnoremap <leader>yd ?^[<space>]*\zsdef<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>

nnoremap <leader>yc ?^class<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>

# set vim's comment string to be # 
autocmd FileType vim setlocal commentstring=#\ %s
autocmd FileType gitconfig setlocal commentstring=#\ %s

#############
# GitGutter #
#############

def g:GitGutterNextHunkCycle()
    var line = line('.')
    execute "normal! :silent! GitGutterNextHunk\<cr>"
enddef

def g:GitGutterPrevHunkCycle()
    var line = line('.')
    execute "normal! :silent! GitGutterPrevHunk\<cr>"
    if line('.') == line
        # go to last line
        :$
        execute "normal! :\<c-u>GitGutterPrevHunk\<cr>"
    endif
enddef

# see help (shortcut K) for gitgutter-mappings
set updatetime=100 # how long (in milliseconds) the plugin will wait for GitGutter
g:gitgutter_map_keys = 0 # disable gitgutter map
nnoremap <leader>hp <plug>(GitGutterPreviewHunk)
nnoremap <leader>ha <plug>(GitGutterStageHunk)
nnoremap <leader>hs <plug>(GitGutterStageHunk)
nnoremap <leader>hu <plug>(GitGutterUndoHunk)

nnoremap <leader>hq :GitGutterQuickFix <bar> copen<cr>

var git_conflict_markers_regex = "^<<<<<<< .*$\\|^||||||| .*$\\|^>>>>>>> .*$\\|^=======$"

def g:GoToGitConflictNext()
    execute $"normal! /{git_conflict_markers_regex}\<cr>"
enddef
def g:GoToGitConflictPrevious()
    execute $"normal! ?{git_conflict_markers_regex}\<cr>"
enddef

############
# markdown #
############

# default ftplugin vim-markdown
# in /opt/homebrew/Cellar/vim/9.0.1800/share/vim/vim90/ftplugin/markdown.vim
# Syntax highlight is synchronized in 50 lines. It may cause collapsed
# highlighting at large fenced code block. In the case, please set larger
# value in your vimrc:  
g:markdown_minlines = 100
g:no_markdown_maps = 1

# conceal characters such as bold, italic and link
autocmd FileType markdown set conceallevel=2

autocmd FileType markdown set colorcolumn=80
autocmd FileType markdown set textwidth=78

# hack: uses `>` to act as comments so that I can use gq to format it
autocmd FileType markdown setlocal comments=:>
# r: Automatically insert the current comment leader after hitting <Enter> in
# Insert mode.
# o: Automatically insert the current comment leader after hitting 'o' or 'O'
# in Normal mode.
# j: Where it makes sense, remove a comment leader when joining lines.
# c: Auto-wrap comments using 'textwidth', inserting the current comment
# leader automatically.
# q: Allow formatting of comments with `gq`
# n: gq to format list e.g. - , using formatlistpat below
# t: Auto-wrap text using 'textwidth'
autocmd FileType markdown setlocal formatoptions=rojcqnt
# pattern for list e.g. - 
# explanation: each \ needs to becomes \\ so patten '^\\s*[-]\\s' is actually '^\s*[-]\s'
autocmd FileType markdown setlocal formatlistpat=^\\s*[-]\\s
# pattern for todo list e.g. + [ ]
autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*[+]\\s[[]\\s[]]\\s
# pattern for completed todo list e.g. + [x]
autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*[+]\\s[[]x[]]\\s
# pattern for number list e.g. 1. 
autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*\\d\\+[.]\\s

# don't hide/conceal code blocks
g:vim_markdown_conceal_code_blocks = 0
# disable folding
g:vim_markdown_folding_disabled = 1
# diable indent on new list item
g:vim_markdown_new_list_item_indent = 0

autocmd FileType markdown nnoremap gx <Plug>Markdown_OpenUrlUnderCursor

# unmap all mappings need to for my custom map [[ and ]] 
g:vim_markdown_no_default_key_mappings = 1
# default filetype plugin maps [[ and ]], unmap it
g:no_markdown_maps = 1

def g:GoToCountHeaderNext()
    execute $"normal! {v:count}/^#\<cr>"
enddef
def g:GoToCountHeaderPrevious()
  execute $"normal! {v:count}?^#\<cr>"
enddef

# da3 to delete all contents in current header with header line
# di3 to delete all contents in current header without header line
# 3 is because shift 3 is #, but 3 is easy to type
augroup markdown_textobjs
  autocmd!
  autocmd FileType markdown call textobj#user#plugin('markdown', {
  \   'header': {
  \     'select-a-function': 'g:AMarkdownHeader',
  \     'select-a': 'a3',
  \     'select-i-function': 'g:InMarkdownHeader',
  \     'select-i': 'i3',
  \   },
  \   'codeblock': {
  \     'select-i-function': 'g:InMarkdownCodeblock',
  \     'select-i': 'ic',
  \   },
  \ })
augroup END

def EndOfFileOrOneLineAboveHeader()
  # cursor goes to oneline above the next header
  # or end of file to if cursor is in last header
  # regex explaination
  # /^# next header
  # \|  or
  # \%$ end of file 
  # needed the \\ to get a literal \
  execute "normal! /^#\\|\\%$\<cr>"
  # if current line is a header line put cursor to one line above
  # else it's end of the file so we don't need to put cursor to one line
  # above
  if getline('.') =~ '^#'
      execute "normal! \<up>"
  endif
enddef

def g:AMarkdownHeader(): list<any>
  set nowrapscan
  # cursor goes to the last header
  # or the start of file
  execute "normal! $"
  execute "normal! ?^#\<cr>"

  var head_pos = getpos('.')
  EndOfFileOrOneLineAboveHeader()
  var tail_pos = getpos('.')
  set wrapscan

  return ['V', head_pos, tail_pos]
enddef

def g:InMarkdownHeader(): list<any>
  set nowrapscan
  execute "normal! $"
  execute "normal! ?^#?+1\<cr>"

  var head_pos = getpos('.')
  EndOfFileOrOneLineAboveHeader()
  var tail_pos = getpos('.')
  set wrapscan
  return ['V', head_pos, tail_pos]
enddef

# modified from 
# https://github.com/coachshea/vim-textobj-markdown/blob/master/autoload/textobj/markdown/chunk.vim
def g:InMarkdownCodeblock(): list<any>
  var tail = search('```$', 'Wc') - 1
  var head = search('^```', 'Wb') + 1 
  return ['V', [0, head, 1, 0], [0, tail, 1, 0]]
enddef

def g:TableConvert(
    start_line_number: number,
    end_line_number: number,
)
    # covert a list into a markdown table
    # limitation: only accepts list with 2 items
    # e.g. - `foo` - foo description
    var range = $':{start_line_number},{end_line_number}'
    # changes first - to |
    silent execute $"{range} substitute/-/|/"
    # changes second - to |
    silent execute $"{range} substitute/-/|/"
    # add | to the end of line
    silent execute $"{range} substitute/$/|/"
    execute "normal! {"
    execute "normal! i|||\<esc>"
    execute "normal! o|-|-|\<esc>"
    silent execute "normal! :TableFormat\<esc>"
enddef

# range allowed, default is current line
command! -range -nargs=0 TableConvertTakesRange call g:TableConvert(<line1>, <line2>)

def g:ToggleMarkdownTODO()
    # complete or uncomplete TODO in markdown
    # - [ ] foo 
    # - [x] foo 
    var current_line = getline('.')

    if current_line =~# '^[ ]*- \[ \]'
        var updated_line = substitute(current_line, '- \[ \]', '- [x]', '')
        setline(".", updated_line)
    elseif current_line =~# '^[ ]*- \[x\]'
        var updated_line = substitute(current_line, '- \[x\]', '- [ ]', '')
        setline(".", updated_line)
    else
        echom 'Unknown line type!' current_line
    endif
enddef

# use <enter> to put x into readme todo [ ]
autocmd FileType markdown nnoremap <cr> :call g:ToggleMarkdownTODO()<cr>

#########
# Spell #
#########

set spellfile=$HOME/Documents/personal-notes/spell/en.utf-8.add
# spell check for markdown and git commit message
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType txt setlocal spell

# Enable dictionary auto-completion in Markdown files and Git Commit Messages
autocmd FileType gitcommit setlocal complete+=kspell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType txt setlocal complete+=kspell

# don't break a word in the middle
autocmd FileType gitcommit setlocal linebreak
autocmd FileType markdown setlocal linebreak
autocmd FileType txt setlocal linebreak

# set indent
autocmd FileType markdown setlocal foldmethod=manual

# use ctrl j to scroll down one line
nnoremap <C-J> <C-E>
# use ctrl k to scroll up one line
nnoremap <C-K> <C-Y>

# use leader c to clear search highlight
nnoremap <silent> <leader>c :nohlsearch<cr>

# leader z to autocorrect words and move cursor to the end of the word
nnoremap <silent> <leader>z 1z=<cr>g;e

# this makes file autocomplete in notes auto completes other notes even when I am in the root directory `~/notes`
autocmd BufRead,BufNewFile $HOME/Documents/notes/* set autochdir

autocmd BufRead,BufNewFile $HOME/Documents/personal-notes/*.md set nospell

# restore cursor last position
# from usr_05.txt
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   execute "normal! g`\""
  \ | endif

#######
# tab #
#######

def g:OpenCurrentFileInNewTabInSameLine()
    set lazyredraw
    # open current file in new tab position after the last tab
    execute "normal! :$tabedit %\<cr>"
    execute "normal! \<c-o>"
    redraw
    set nolazyredraw
enddef

nnoremap <leader>t :call g:OpenCurrentFileInNewTabInSameLine()<cr>
# By default, L, H are just jump to bottom or top of screen, not very useful
# so remaps L to go to next tab, H to go to previous tab
nnoremap L gt
nnoremap H gT

def g:TabmoveRightWrap()
    try
        tabmove +
    catch /E475:/
        # error when this is the last tab
        # move the tab to the very left
        tabmove 0
    endtry
enddef

def g:TabmoveLeftWrap()
    try
        tabmove -
    catch /E475:/
        # error when this is the first tab
        # move the tab to the very left
        tabmove $
    endtry
enddef

# move tabpage to the left
nnoremap <c-h> :call g:TabmoveLeftWrap() <cr>
nnoremap <c-l> :call g:TabmoveRightWrap() <cr>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

#######
# fzf #
#######

# Tips:
# use bang to open in full screen, e.g. `:Rg! foo` opens fzf rg in full screen
# in fzf interface, use <ctrl-/> to toggle preview

nnoremap <leader>fs :Snippets<cr>
nnoremap <leader><leader> :Files<cr>
# leader b to jump to previous buffer
nnoremap <leader>b :Buffers<cr>
# nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fc :Commands<cr>
nnoremap <leader>ff :Files<cr>
# search all lines in open buffers
nnoremap <leader>fl :Lines<cr>
nnoremap <leader>fm :Marks<cr>
# nnoremap <leader>fm :Maps<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fw :Rg --word-regexp <c-r><c-w><cr>
nnoremap <leader>fh :History<cr>
nnoremap <leader>fv :Helptags<cr>

# this allows vim command Rg to be invoked with the same as how rg is invoked
# in the command line e.g.
# :Rg -w foo i.e. -w is --word-regexp
# :Rg -s foo i.e. -s is --case-sensitive
# :Rg 'a.*b' i.e. arbitrary regular expression
# copied from https://github.com/junegunn/fzf.vim/issues/838#issuecomment-509902575
command! -bang -nargs=* Rg g:fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " .. <q-args>, 1, <bang>0)

################
# Git Fugitive #
################

set diffopt=vertical  
# use wrap for diff
set diffopt+=followwrap

def g:BindOff()
    # disable the moving together in git diff tab with vertical split
    windo set nocursorbind
    windo set noscrollbind
enddef

command! -bang -nargs=0 BindOff :call g:BindOff()

nnoremap <leader>gb :Git blame<cr>
# show a list of git diff files
nnoremap <leader>ge :Gedit<cr>

###################
# Source And Edit #
###################

nnoremap <leader>ev :$tabedit ~/.vimrc<cr>
nnoremap <leader>sv :source ~/.vimrc<cr>

nnoremap <leader>eb :$tabedit ~/Documents/personal-notes/.bashrc<cr>
nnoremap <leader>ef :$tabedit ~/.config/fish/config.fish<cr>
nnoremap <leader>ed :$tabedit ~/Documents/personal-notes/dev_notes.md<cr>
nnoremap <leader>eg :$tabedit ~/.gitconfig<cr>

nnoremap <leader>el :cfile saltus/quickfix.vim <bar> copen<cr><c-r><c-r>

nnoremap <leader>eu :UltiSnipsEdit<cr>
nnoremap <leader>es :UltiSnipsEdit<cr>

nnoremap <leader>ea :JumpToTestFileSplit<cr>
# nnoremap <leader>eas :JumpToTestFileSplit<cr>

nnoremap <leader>en :$tabedit ~/Documents/notes/notes/<cr>

#############
# UltiSnips #
#############
g:UltiSnipsSnippetDirectories = [$HOME .. '/Documents/dotfiles/UltiSnips']
g:UltiSnipsEditSplit = "vertical"

# by default UltiSnipsExpandTrigger uses Tab, disable it for completor
g:UltiSnipsExpandTrigger = "<cr>"

##########
# Python #
##########

# Don't autowrap in python files
# t: Auto-wrap text using 'textwidth'
# see `:help fo-t`
autocmd FileType python setlocal formatoptions-=t

# disable python mappings such as [[ and ]] from vim source code
# https://github.com/vim/vim/blob/master/runtime/ftplugin/python.vim
g:no_python_maps = 1


def g:ImportWordUnderCursor()
py3 <<EOF
from vim_python import get_import_path_given_word

import_string = get_import_path_given_word(vim)

vim.current.buffer.append(import_string, 0)
EOF
enddef
command! -nargs=0 ImportWord call g:ImportWordUnderCursor()

def g:JumpToTestFile()
py3 << EOF
from vim_python import get_or_create_alternative_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_alternative_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"tabnew {test_filepath}")
EOF
enddef

command! JumpToTestFile call g:JumpToTestFile()

def g:JumpToTestFileSplit()
py3 << EOF
from vim_python import get_or_create_alternative_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_alternative_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"vsplit {test_filepath}")
EOF
enddef

command! JumpToTestFileSplit call g:JumpToTestFileSplit()

def GetPythonFileImportPath(): string
    var posix_file_path = @%
    var remove_prefix = substitute(posix_file_path, '^saltus/', '', 'g')
    var remove_suffix = substitute(remove_prefix, '.py$', '', 'g')
    var python_import_path   = substitute(remove_suffix, '/', '.', 'g')
    return python_import_path
enddef

def YankPythonImport()
    var name = @0
    var python_import_path = GetPythonFileImportPath()
    var statement = printf('from %s import %s', python_import_path, name)
    echomsg printf('yanked "%s"', statement)
    # puts statement into default yank register
    setreg('*', statement)
enddef

def YankPythonPatch()
    var name = @0
    var python_import_path = GetPythonFileImportPath()
    var statement = printf('@mock.patch("%s.%s")', python_import_path, name)
    echomsg printf('yanked "%s"', statement)
    # puts statement into default yank register
    setreg('*', statement)
enddef

# known bug
# this import function name doesn't work if the function is a method in a class
def g:ImportFunction()
    # after jump to tag ctrl-]
    # the cursor is position at the start of def or class
    # puts cursor to the end of line to get the def or class in this line
    execute "normal! $"

    execute "normal! ?def\<cr>wyiw\<c-o>"
    YankPythonImport()
enddef

def g:ImportClass()
    execute "normal! $"
    execute "normal! ?^class\<cr>wyiw\<c-o>"
    YankPythonImport()
enddef

def g:ImportWord()
    execute "normal! yiw"
    YankPythonImport()
enddef

def g:PatchFunction()
    execute "normal! $"
    execute "normal! ?def\<cr>wyiw\<c-o>"
    YankPythonPatch()
enddef

def g:PatchWord()
    execute "normal! yiw"
    YankPythonPatch()
enddef

nnoremap <leader>yif :call g:ImportFunction()<cr>
nnoremap <leader>yic :call g:ImportClass()<cr>
nnoremap <leader>yiw :call g:ImportWord()<cr>

nnoremap <leader>ymw :call g:PatchWord()<cr>

def g:YankFilenameAndPositionInVimQuickfixFormat()
    var file_path = @%
    var cursor_position = getcurpos()
    var line_number = cursor_position[1]
    var column_number = cursor_position[2]
    var quickfix_format_string = $"{file_path}:{line_number}:{column_number}"

    var message = printf('yanked "%s"', quickfix_format_string)
    echomsg message
    # puts import_statement into default yank register
    setreg('*', quickfix_format_string, 'V')
enddef

nnoremap <leader>yq :call g:YankFilenameAndPositionInVimQuickfixFormat()<cr>

autocmd FileType python nnoremap <leader>w <Plug>(PythonsensePyWhere)

############
# NERDTree #
############

var NERDTreeIgnore = ['__pycache__']
var NERDTreeShowHidden = 1
nnoremap <leader>n :NERDTreeFind<cr>

#################
# completor.vim #
#################

# prints logs, use `make logs` in ~/Documents/completors 
g:completor_debug = 1
# Use TAB to complete when typing words, else inserts TABs as usual.  Uses
# dictionary, source files, and completor to find matching words to complete.

# Note: usual completion is on <C-n> but more trouble to press all the time.
# Never type the same word twice and maybe learn a new spellings!
# Use the Linux dictionary when spelling is in doubt.
def g:TabOrComplete(): string
  # If completor is already open the `tab` cycles through suggested completions.
  if pumvisible()
    return "\<C-N>"
  # If completor is not open and we are in the middle of typing a word then
  # `tab` opens completor menu.
  elseif col('.') > 1 && strpart(getline('.'), col('.') - 2, 3) =~ '^[[:keyword:][:ident:]]'
    return "\<C-R>=completor#do('complete')\<cr>"
  else
    # If we aren't typing a word and we press `tab` simply do the normal `tab`
    # action.
    return "\<tab>"
  endif
enddef

# Use `tab` key to select completions.  Default is arrow keys.

# Use tab to trigger auto completion.  Default suggests completions as you type.
inoremap <expr> <tab> g:TabOrComplete()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

# removes the preview window
g:completor_auto_trigger = 0
g:completor_complete_options = 'menuone,preview'

# if auto trigger, I have to use noselect complete option
# otherwise it's auto completing
# g:completor_auto_trigger = 1
# g:completor_complete_options = 'menuone,noselect,preview'

# change from default 2 chars to 1 char
g:completor_min_chars = 1

##################
# Vim EasyMotion #
##################

g:EasyMotion_do_mapping = 0 # Disable default mappings
# `s{char}{char}{label}`
nmap , <plug>(easymotion-overwin-f2)

g:EasyMotion_smartcase = 1

####################
# img paste plugin #
####################
g:mdip_imgdir = 'images'
# <leader>i - i stands for image to insert image in normal mode
autocmd FileType markdown nnoremap <buffer> <silent> <leader>i :call mdip#MarkdownClipboardImage()<cr>

################
# vim-asterisk #
################

# * stays at the current cursor position, instead of jumpping to next
map *  <plug>(asterisk-z*)
map #  <plug>(asterisk-z#)
# g* is * search without word boundary \< \> 
map g* <plug>(asterisk-gz*)
map g# <plug>(asterisk-gz#)

map n <plug>(anzu-n-with-echo)
map N <plug>(anzu-N-with-echo)

###############
# Man Command #
###############

# Usage: 
#     `Man git`
#     `Man 7 git-tutorial`

runtime! ftplugin/man.vim

##############################
# get syntax highlight group #
##############################

def SynStack()
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
enddef

command! -bang -nargs=0 Syntax call SynStack()

##############
# diff color #
##############

# #C91B00 red from iterm ansi red
hi diffRemoved guifg=#C91B00
# #00C200 green from iterm ansi green
hi diffAdded   guifg=#00C200

#####################
# Printing Hardcopy #
#####################

set printheader=%<%f%h\ %{GetHelpSectionName()}%=Page\ %N

def g:SaveAsHtmlToPrintInDownloads()
  # save as to_print.html with delek colorscheme 
  # delek colorscheme has a white background, more printer friendly
  # Known bug: cannot use TOPrintHtml twice with error, 
  # #139: file is loaded in another buffer
  var current_colorscheme = g:colors_name
  colorscheme delek
  execute "normal! :TOhtml\<cr>"
  var filename = expand('%:t:r')
  var export_path = $"~/Downloads/{filename}.html"
  execute $"normal! :saveas! {export_path}\<cr>"
  sleep 100m
  execute $"colorscheme {current_colorscheme}"
enddef
command! TOPrintHtml call g:SaveAsHtmlToPrintInDownloads()

def g:SaveAsPDFToPrintInDownloads()
  # save as to_print.html with delek colorscheme 
  # delek colorscheme has a white background, more printer friendly
  # Known bug: cannot use TOPrintHtml twice with error, 
  # #139: file is loaded in another buffer
  var current_colorscheme = g:colors_name
  colorscheme delek
  var filename = expand('%:t:r') .. '.ps'
  var export_path = $"~/Downloads/{filename}"
  execute $"normal! :hardcopy! > {export_path}\<cr>"
  execute $"normal! :cd ~/Downloads\<cr>"
  execute $"normal! :!ps2pdf {export_path}\<cr>"
  execute $"colorscheme {current_colorscheme}"
enddef
command! TOPrintPDF call g:SaveAsPDFToPrintInDownloads()

#########
# Vista #
#########

g:vista#renderer#enable_icon = 0

autocmd FileType vista,vista_markdown nnoremap <buffer> <silent> / :<c-u>call vista#finder#fzf#Run()<CR>

g:vista_sidebar_width = 80

nnoremap <leader>v :Vista<cr>

##############
# Statusline #
##############

def g:NearestMethodOrFunction(): string
  return get(b:, 'vista_nearest_method_or_function', '')
enddef

# By default vista.vim never run if you don't call it explicitly.
#
# If you want to show the nearest function in your statusline automatically,
# you can add the following line to your vimrc
# autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

def g:GetHelpSectionName(): string
    # 'b'	search Backward instead of forward
    # 'n'	do Not move the cursor
    # 'W'	don't Wrap around the end of the file
    var section_header_line_number = search('^=\{70,}', 'bnW')
    var section_header: string
    if section_header_line_number != 0
        section_header = getline(section_header_line_number + 1)
        section_header = substitute(
            section_header,
            '^\([.*0-9a-zA-Z ]*\)\t*.*',
            '\=submatch(1)',
            ''
        )
    else
        section_header = ''
    endif
    return section_header
enddef

def g:GitStatus(): string
  var [added, modified, removed] = g:GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', added, modified, removed)
enddef

# left section
set statusline=\ %f    # filename
set statusline+=\ %{GetHelpSectionName()}

# middle section
set statusline+=%=
set statusline+=%{NearestMethodOrFunction()}

# By default vista.vim never run if you don't call it explicitly.
#
# If you want to show the nearest function in your statusline automatically,
# you can add the following line to your vimrc
autocmd FileType python call vista#RunForNearestMethodOrFunction()

# right section
set statusline+=%=
set statusline+=\ [%{expand(&filetype)}]
set statusline+=\ L:%03l/%03L # line number / total number or lines
set statusline+=\ C:%03c    # column number

##########
# Python #
##########


#######
# Tag #
#######

# `<leader>]` to open tag in preview window
nnoremap <leader>] :ptag <c-r><c-w><cr>

###########
# Preview #
###########

set previewheight=20

#############
# vim-caser #
#############

g:caser_no_mappings = 1

# change to class casing FooBarBaz
nnoremap gsc <Plug>CaserMixedCase

# change to variable casing foo_bar_baz
nnoremap gs_ <Plug>CaserSnakeCase

# change to constant casing e.g. FOO_BAR_BAZ
nnoremap gsu <Plug>CaserUpperCase

##############
# [ Mappings #
##############

# git
nnoremap [h :<c-u>call g:GitGutterPrevHunkCycle()<cr>
nnoremap ]h :<c-u>call g:GitGutterNextHunkCycle()<cr>
nnoremap [g :<c-u>call g:GoToGitConflictPrevious()<cr>
nnoremap ]g :<c-u>call g:GoToGitConflictNext()<cr>

# quickfix 
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap [Q :cfirst<cr>
nnoremap ]Q :clast<cr>

# files from argument list
nnoremap [a :previous<cr>
nnoremap ]a :next<cr>
nnoremap [A :first<cr>
nnoremap ]A :last<cr>

# move to incorrect spelling words
nnoremap <silent> [z [s
nnoremap <silent> ]z ]s

# python functions and classes
autocmd FileType python nnoremap [c <Plug>(PythonsenseStartOfPythonClass)
autocmd FileType python nnoremap ]c <Plug>(PythonsenseStartOfNextPythonClass)
autocmd FileType python nnoremap [f <Plug>(PythonsenseStartOfPythonFunction)
autocmd FileType python nnoremap ]f <Plug>(PythonsenseStartOfNextPythonFunction)

# markdown headers
autocmd FileType markdown nnoremap [[ :<c-u>call g:GoToCountHeaderPrevious()<cr>
autocmd FileType markdown nnoremap ]] :<c-u>call g:GoToCountHeaderNext()<cr>

###############
# pythonsense #
###############

g:is_pythonsense_suppress_motion_keymaps = 1
g:is_pythonsense_suppress_location_keymaps = 1

#########################
# Vim9 Compile Function #
#########################

# Uncomment the next line to compile the functions for tests 
defcompile

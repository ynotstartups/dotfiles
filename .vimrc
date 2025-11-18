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
Plug 'tpope/vim-unimpaired'           # [f, ]f to go to file in same directory

# git
Plug 'airblade/vim-gitgutter'          # shows git add/modify/remove symbols on the left
Plug 'tpope/vim-fugitive'              # view git blame in vim
Plug 'tpope/vim-rhubarb'               # `:GBrowse` to open code in github

# additional `g` commands
Plug 'tpope/vim-commentary'            # `gc` for making comments
Plug 'vim-scripts/ReplaceWithRegister' # `gr` go replace
Plug 'inkarkat/vim-ReplaceWithSameIndentRegister' # grR to keep indent
Plug 'arthurxavierx/vim-caser'         # `gs` changes word casing e.g. `gsc` FooBar, `gs_` foo_bar, `gsu` FOO_BAR

# syntax highlight
Plug 'ekalinin/Dockerfile.vim'         # dockerfile syntax
Plug 'plasticboy/vim-markdown'         # add markdown syntax
Plug 'hashivim/vim-terraform'          # add terraform syntax

# additional text objects
Plug 'jeetsukumaran/vim-pythonsense'   # ac, ic, af, if, ad, id python text object
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'           # al     for this line
Plug 'kana/vim-textobj-entire'         # ie     for entire file
Plug 'sgur/vim-textobj-parameter'      # i, a,  for parameters
Plug 'lucapette/vim-textobj-underscore' # i_ a_ for underscore

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
set belloff=all # no bell from vim
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

def GetWordAfterPrefix(prefix_string: string): string
  # search for the line number and column number for the prefix_string
  # e.g. the line and column of character 'f' in `def \zsfoo` 
  # flag `b` - search backward  
  # flag `n` - do not move the cursor
  # see also `:help search()`

  # escaping the \ , so output is 'foo \zs'
  var prefix_regular_expression = $"{prefix_string} \\zs"
  var [match_line_number, match_col_number] = prefix_regular_expression->searchpos('bn')
  var line = getline(match_line_number)
  # get the word with matching column position - 1, `-1` is needed to include
  # the first character of the word, e.g. word would be `foo`
  var word = line->matchstr('\w*', match_col_number - 1)
  return word
enddef

def g:YankWordAfterPrefix(prefix_string: string)
  var word = GetWordAfterPrefix(prefix_string)
  echom 'yanked' word
  setreg('+', word)
enddef

# yank last function name
nnoremap <leader>yf :call YankWordAfterPrefix("def")<cr>

# yank last class name
# `^` is added to avoid the following case
# class Foo(graphene.Mutation):
#    class Arguments:
#        ...
nnoremap <leader>yc :call YankWordAfterPrefix("^class")<cr>

# set vim's comment string to be # 
autocmd FileType vim setlocal commentstring=#\ %s
autocmd FileType gitconfig setlocal commentstring=#\ %s

#############
# GitGutter #
#############

def g:GitGutterNextHunkCycle()
    var line = line('.')
    GitGutterNextHunk
    if line('.') == line
        # if line doesn't changed meaning this is the last hunk,
        # move cursor back to first line and find next hunk
        :0
        GitGutterNextHunk
    endif
enddef

def g:GitGutterPrevHunkCycle()
    var line = line('.')
    GitGutterPrevHunk
    if line('.') == line
        # if line doesn't changed meaning this is the last hunk,
        # move cursor back to first line and find next hunk
        :$
        GitGutterPrevHunk
    endif
enddef

nnoremap [h :call g:GitGutterPrevHunkCycle()<cr>
nnoremap ]h :call g:GitGutterNextHunkCycle()<cr>

# see help (shortcut K) for gitgutter-mappings
set updatetime=100 # how long (in milliseconds) the plugin will wait for GitGutter
g:gitgutter_map_keys = 0 # disable gitgutter map
nnoremap <leader>hp <plug>(GitGutterPreviewHunk)
nnoremap <leader>gp <plug>(GitGutterUndoHunk)
nnoremap <leader>hu <plug>(GitGutterUndoHunk)

nnoremap <leader>hq :GitGutterQuickFix <bar> copen<cr>

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
autocmd BufRead,BufNewFile */personal-notes/* set textwidth=0

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

# `yic` to yank all code in code block ```  
# modified from 
# https://github.com/coachshea/vim-textobj-markdown/blob/master/autoload/textobj/markdown/chunk.vim
def g:InMarkdownCodeblock(): list<any>
  var tail = search('```$', 'Wc') - 1
  var head = search('^```', 'Wb') + 1 
  return ['V', [0, head, 1, 0], [0, tail, 1, 0]]
enddef

augroup markdown_textobjs
  autocmd!
  autocmd FileType markdown call textobj#user#plugin('markdown', {
  \   'codeblock': {
  \     'select-i-function': 'g:InMarkdownCodeblock',
  \     'select-i': 'ic',
  \   },
  \ })
augroup END

# covert a list into a markdown table
# limitation: only accepts list with 2 items
# e.g. - `foo` - foo description
def g:TableConvert(
    start_line_number: number,
    end_line_number: number,
)
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
    FormatTable
enddef

# range allowed, default is current line
command! -range -nargs=0 TableConvertTakesRange call g:TableConvert(<line1>, <line2>)

#########
# Spell #
#########

autocmd BufRead,BufNewFile $HOME/Documents/personal-notes/*.md set nospell

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
    tabedit %
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

# ctrl+h and ctrl+l to move tabpage 
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
nnoremap <leader>m :Marks<cr>
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
command! -nargs=* Rg g:fzf#vim#grep($"rg --column --line-number --no-heading --color=always --smart-case {<q-args>}", 1, <bang>0)

# disable fzf preview
g:fzf_preview_window = []

################
# Git Fugitive #
################

set diffopt=vertical  
# use wrap for diff
set diffopt+=followwrap

nnoremap <leader>gb :Git blame<cr>
# show a list of git diff files
nnoremap <leader>ge :Gedit<cr>

###################
# Source And Edit #
###################

nnoremap <leader>ev :$tabedit ~/.vimrc<cr>

nnoremap <leader>eb :$tabedit ~/Documents/personal-notes/.bashrc<cr>
nnoremap <leader>ed :$tabedit ~/Documents/personal-notes/dev_notes.md<cr>
nnoremap <leader>ef :$tabedit ~/.config/fish/config.fish<cr>
nnoremap <leader>eg :$tabedit ~/.gitconfig<cr>
nnoremap <leader>ek :$tabedit ~/.config/kitty/kitty.conf<cr>
nnoremap <leader>ep :$tabedit ~/Documents/dotfiles/language-reminders/python.md<cr>

# helps `<leader>el` to read linting output saved in `saltus/quickfix.vim`
set errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
nnoremap <leader>el :cfile quickfix.vim <bar> copen<cr><c-r><c-r>

def g:OpenLanguageReminderFile()
    var filetype = &filetype
    var path = $"~/Documents/dotfiles/language-reminders/{filetype}.md"
    execute $"vsplit {path}"
enddef

nnoremap <leader>er :call g:OpenLanguageReminderFile()<cr>

nnoremap <leader>ea :JumpToTestFileSplit<cr>

nnoremap <leader>en :$tabedit ~/Documents/personal-notes/project_notes.py<cr>
nnoremap <leader>em :$tabedit ~/Documents/learn-chalice/menu/app.py<cr>

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

if vim.current.buffer[0] == '"""' or vim.current.buffer[1] == '"""':
    if vim.current.buffer[0] == '"""':
        line_number = 1
    else:
        line_number = 2
    for line in vim.current.buffer[line_number:]:
        if line == '"""':
            vim.current.buffer.append(import_string, line_number + 1)
        line_number += 1
else:
    vim.current.buffer.append(import_string, 0)

EOF
enddef
command! -nargs=0 ImportWord call g:ImportWordUnderCursor()
autocmd FileType python nnoremap <buffer> <silent> <leader>i :call ImportWordUnderCursor()<cr>

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
    var posix_file_path = expand("%")
    var python_import_path = posix_file_path
                                ->substitute('^saltus/', '', 'g')
                                ->substitute('.py$', '', 'g')
                                ->substitute('/', '.', 'g')
    return python_import_path
enddef

def YankPythonImport(name: string)
    var python_import_path = GetPythonFileImportPath()
    var statement = printf('from %s import %s', python_import_path, name)
    echomsg 'yanked' statement
    # puts statement into default yank register
    # `V` indicate line mode, so when I paste, it pastes as a line
    setreg('+', statement, "V")
enddef

def YankPythonPatch(name: string)
    var python_import_path = GetPythonFileImportPath()
    var statement = printf('@mock.patch("%s.%s")', python_import_path, name)
    echomsg 'yanked' statement
    # puts statement into default yank register
    setreg('+', statement, "V")
enddef

def g:ImportFunction()
    var word = GetWordAfterPrefix("def ")
    YankPythonImport(word)
enddef

def g:ImportClass()
    var word = GetWordAfterPrefix("class ")
    YankPythonImport(word)
enddef

def g:ImportWord()
    var word = expand("<cword>")
    YankPythonImport(word)
enddef

def g:PatchFunction()
    var word = GetWordAfterPrefix("def ")
    YankPythonPatch(word)
enddef

def g:PatchClass()
    var word = GetWordAfterPrefix("class ")
    YankPythonPatch(word)
enddef

def g:PatchWord()
    var word = expand("<cword>")
    YankPythonPatch(word)
enddef

nnoremap <leader>yif :call g:ImportFunction()<cr>
nnoremap <leader>yic :call g:ImportClass()<cr>
nnoremap <leader>yiw :call g:ImportWord()<cr>

nnoremap <leader>ymf :call g:PatchFunction()<cr>
nnoremap <leader>ymc :call g:PatchClass()<cr>
nnoremap <leader>ymw :call g:PatchWord()<cr>

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

# change from default 2 chars to 1 char
g:completor_min_chars = 1

##################
# Vim EasyMotion #
##################

g:EasyMotion_do_mapping = 0 # Disable default mappings
# `s{char}{char}{label}`
nmap , <plug>(easymotion-overwin-f2)

g:EasyMotion_smartcase = 1

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

command! -nargs=0 Syntax call SynStack()

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

def g:SaveAsHtmlToPrintInDownloads(
    start_line_number: number,
    end_line_number: number,
)
  # save as to_print.html with delek colorscheme 
  # delek colorscheme has a white background, more printer friendly
  # Known bug: cannot use TOPrintHtml twice with error, 
  # #139: file is loaded in another buffer
  var current_colorscheme = g:colors_name
  colorscheme delek
  execute $"normal :{start_line_number},{end_line_number} TOhtml\<cr>"
  var filename = expand('%:t:r')
  var time_in_seconds = strftime("%Y-%b-%d-%X")
  execute $"saveas! ~/Downloads/{filename}_{time_in_seconds}.html"
  sleep 100m
  # reset to previous colorscheme
  execute $"colorscheme {current_colorscheme}"
enddef
command! -range=% TOPrintHtml call g:SaveAsHtmlToPrintInDownloads(<line1>, <line2>)

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

# left section
set statusline=\ %f    # filename

# right section
set statusline+=%=
set statusline+=\ [%{expand(&filetype)}]
set statusline+=\ L:%03l/%03L # line number / total number or lines
set statusline+=\ C:%03c    # column number

#######
# Tag #
#######

def g:OpenTagInVerticalSplit()
    vsp
    execute $"normal! :tag {expand('<cword>')}\<cr>"
enddef

# `<leader>]` to open tag in vertical split
nnoremap <leader>] :call OpenTagInVerticalSplit()<cr>

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

nnoremap gs<space> <Plug>CaserSpaceCase

# change to variable casing foo_bar_baz
nnoremap gs_ <Plug>CaserSnakeCase

# change to constant casing e.g. FOO_BAR_BAZ
nnoremap gsu <Plug>CaserUpperCase

##############
# [ Mappings #
##############

var git_conflict_markers_regex = "^<<<<<<< .*$\\|^||||||| .*$\\|^>>>>>>> .*$\\|^=======$"

def g:GoToGitConflictNext()
    execute $"normal! /{git_conflict_markers_regex}\<cr>"
enddef
def g:GoToGitConflictPrevious()
    execute $"normal! ?{git_conflict_markers_regex}\<cr>"
enddef

nnoremap [g :call g:GoToGitConflictPrevious()<cr>
nnoremap ]g :call g:GoToGitConflictNext()<cr>

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


##############
# / Mappings #
##############

autocmd FileType python nmap <leader>/f vif<esc><esc>/\%V
autocmd FileType python nmap <leader>/c vic<esc><esc>/\%V

###############
# pythonsense #
###############

# remove the default motion key mappings
# See https://github.com/jeetsukumaran/vim-pythonsense?tab=readme-ov-file#python-object-motions
g:is_pythonsense_suppress_motion_keymaps = 1
# remove the defult localtion key mappings
# See https://github.com/jeetsukumaran/vim-pythonsense?tab=readme-ov-file#python-location-information
g:is_pythonsense_suppress_location_keymaps = 1

########
# grep #
########

# set command `grep` to use system rg
# see `:help :grepprg`
if executable('rg')
  set grepprg=rg\ --with-filename\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

##################
# Documentations #
##################

# To make `autoread` vim option works to autoreload changed files
# https://stackoverflow.com/a/53860166
g:CheckUpdateStarted = false
if ! g:CheckUpdateStarted
    g:CheckUpdateStarted = true
    timer_start(1, 'g:CheckUpdate')
endif
def g:CheckUpdate(timer_id: number)
    silent! checktime
    timer_start(1000, 'g:CheckUpdate')
enddef

##############################
# search with magic mode on #
##############################

# with magic mode on, I don't need to use \ to prefix the regular expressions'
# special character

nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/

###############
# FormatTable #
###############

def g:FormatTable()
py3 <<EOF
from vim_python import format_markdown_table
format_markdown_table(vim)
EOF
enddef

command! -nargs=0 FormatTable call g:FormatTable()

#########################
# Vim9 Compile Function #
#########################
# Uncomment the next line to compile the functions for tests 
# defcompile

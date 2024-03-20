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
Plug 'SirVer/ultisnips'                # snippets
Plug 'airblade/vim-gitgutter'          # shows a git diff in the sign column
Plug 'arthurxavierx/vim-caser'         # `gs_` changes word casing: `gst` Foo Bar, `gs_` foo_bar, `gsm` FooBar
# Plug 'davidhalter/jedi-vim'            # vim python, leader k to go to doc, leader d to definition
Plug 'easymotion/vim-easymotion'       # use , to jump around the code
Plug 'ekalinin/Dockerfile.vim'         # dockerfile syntax
Plug 'haya14busa/vim-asterisk'         # * stays where it is
Plug 'img-paste-devs/img-paste.vim'    # leader p to paste image to markdown file
Plug 'inkarkat/vim-visualrepeat'       # use . in selected lines in visual mode
Plug 'jeetsukumaran/vim-pythonsense'   # ac, ic, af, if, ad, id python text object
Plug 'jparise/vim-graphql'             # graphql syntax highlight
Plug 'junegunn/fzf'                    # fzf
Plug 'junegunn/fzf.vim'                # fzf vim
Plug 'junegunn/vim-easy-align'         # `ga=` align first =, ga2= align second =, ga*= align all =
Plug 'liuchengxu/vista.vim'            # :Vista for tag viewer & markdown table of contents
# Plug 'maralla/completor.vim'           # fuzzy complete, type 'fzcl' then <tab> to complete to 'fuzzy complete'
Plug '~/Documents/completor.vim'           # fuzzy complete, type 'fzcl' then <tab> to complete to 'fuzzy complete'
Plug 'markonm/traces.vim'              # Range, pattern and substitute preview for Vim
Plug 'osyo-manga/vim-anzu'             # n, N show the number of searches
Plug 'plasticboy/vim-markdown' | Plug 'godlygeek/tabular' # add markdown syntax and :TableFormat to format table
Plug 'preservim/nerdtree', { 'on': 'NERDTreeFind' }             # tree explorers
Plug 'tpope/vim-commentary'            # add shortcut gc for making a comment
Plug 'tpope/vim-fugitive'              # using git in vim
Plug 'tpope/vim-repeat'                # repeat vim-surround with .
Plug 'tpope/vim-rhubarb'               # supports for :GBrowse to github
Plug 'tpope/vim-surround'              # The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-unimpaired'            # adds mapping like [q ]q
Plug 'vim-scripts/ReplaceWithRegister' # gr{motion} go replace

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
# set wildignore=*.class,*.o,*~,*.pyc,.git  # Ignore certain files when finding files
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
# set path+=** # recursive by default when using :find
set autoread # automatically apply changes from outside of Vim
# this makes autoread work, doesn't work on command-line window
# au CursorHold * checktime # check one time after 4s of inactivity in normal mode
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

# https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
# keep undo history after file is closed
# if !isdirectory($HOME."/.vim/undo-dir")
#     mkdir($HOME."/.vim/undo-dir", "", 0700)
# endif
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
# colorscheme gruvbox
# colorscheme solarized8
# autocmd vimenter * ++nested colorscheme solarized8_flat

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

# jump to tags
# prompt to select if there are multiple matching tags
# jump to the only tag
# for python tags, it works well to always jumpt to the first tag
# nnoremap <C-]> g<C-]>

# copy/paste
# https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamed # vim uses system clipboard

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
    if line('.') == line
        # go to first line
        :1
        execute "normal! :\<c-u>GitGutterNextHunk\<cr>"
    endif
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
nnoremap ]h :<c-u>call g:GitGutterNextHunkCycle()<cr>
nnoremap [h :<c-u>call g:GitGutterPrevHunkCycle()<cr>
nnoremap <leader>hp <plug>(GitGutterPreviewHunk)
nnoremap <leader>ha <plug>(GitGutterStageHunk)
nnoremap <leader>hs <plug>(GitGutterStageHunk)
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

# leader l create link with link from clipboard
# <esc> exit visual mode
# a() insert () after the last word of visual selection
# <esc><left> move cursor to be in the middle of ()
# p paste link from clipboard
# gv go back to the visual select
# "ac[] change the visual select to [] & save to visual select to register a
# <left><esc>"ap paste visual select from register a in the middle of []
# P.S. register a is used to avoid changing the clipboard 
autocmd FileType markdown,gitcommit vnoremap <leader>l <esc>a()<esc><left>pgv"ac[]<left><esc>"ap

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

def g:FoldLineRespectingLeadingSpace()
    set textwidth=70
    substitute/^\s*//g
    execute "normal! gqq"
    execute "normal! :\<c-u>'[,']substitute/^/          /g\<cr>"
enddef


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

def g:GoToCountHeaderBelow()
    execute $"normal! {v:count}/^#\<cr>"
enddef
# 5]] to goes to fifth header below
autocmd FileType markdown nnoremap ]] :<c-u>call g:GoToCountHeaderBelow()<cr>
def g:GoToCountHeaderAbove()
  execute $"normal! {v:count}?^#\<cr>"
enddef
# 5]] to goes to fifth header below
autocmd FileType markdown nnoremap [[ :<c-u>call g:GoToCountHeaderAbove()<cr>

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

def g:CycleListType()
    # cycle three types of list in markdown, namely
    # - foo 
    # + [ ] foo 
    # + [x] foo 
    # execute "normal! " .v:count. "/^#\<cr>"
    var current_line = getline('.')

    if current_line =~# '^[ ]*-'
        var updated_line = substitute(current_line, '-', '+ [ ]', '')
        setline(".", updated_line)
    elseif current_line =~# '^[ ]*+ \[ \]'
        var updated_line = substitute(current_line, '+ \[ \]', '+ [x]', '')
        setline(".", updated_line)
    elseif current_line =~# '^[ ]*+ \[x\]'
        var updated_line = substitute(current_line, '+ \[x\]', '-', '')
        setline(".", updated_line)
    else
        echom 'Unknown line type!' current_line
    endif
enddef

# use <enter> to put x into readme todo [ ]
autocmd FileType markdown nnoremap <cr> :call g:CycleListType()<cr>

# modified from 
# https://github.com/coachshea/vim-textobj-markdown/blob/master/autoload/textobj/markdown/chunk.vim
def g:InMarkdownCodeblock(): list<any>
  var tail = search('```$', 'Wc') - 1
  var head = search('^```', 'Wb') + 1 
  return ['V', [0, head, 1, 0], [0, tail, 1, 0]]
enddef

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
nnoremap <silent> [z [s
nnoremap <silent> ]z ]s

# this makes file autocomplete in notes auto completes other notes even when I am in the root directory `~/notes`
autocmd BufRead,BufNewFile $HOME/Documents/notes/* set autochdir

autocmd BufRead,BufNewFile $HOME/Documents/personal-notes/*.md set nospell

# insert filename in title case, used for personal notes
# "%p - paste current filename (in register %)
# gst - gst uses vim-caser to turn word in title mode
# il  - il uses kana/vim-textobj-line to apply on whole line
# <delete><delete> - remove the md in markdown file extension
# I#  - adds markdown title with a space at the front
nmap <silent> <leader>it "%pgstil<delete><delete>I# <esc>

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

# <c-o> hacks to jumps to last position
nnoremap <leader>t :call g:OpenCurrentFileInNewTabInSameLine()<cr>
# L, H are just jump to bottom or top of screen, not very useful
# next tab
nnoremap L gt
# previous tab
nnoremap H gT
# move tabpage to the left

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
nnoremap <c-h> :call g:TabmoveLeftWrap() <cr>
nnoremap <c-l> :call g:TabmoveRightWrap() <cr>
# leader number to go to tab
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
# nnoremap <leader>fm :Marks<cr>
nnoremap <leader>fm :Maps<cr>
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

# command! -bang -nargs=* EchoShellQAargs echom shellescape(<q-args>)
# command! -bang -nargs=* EchoQAargs echom <q-args>

# inoremap <expr> <C-n> fzf#vim#complete(fzf#wrap({
#     \ 'source': uniq(sort(split(join(getline(1, '$'), "\n"), '\W\+'))),
#     \ }))

nnoremap <leader>q <esc>:qa<cr>

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
nnoremap <leader>gf :Git diff --name-only origin/master...<cr>
nnoremap <leader>ge :Gedit<cr>
# this G c relies on .gitconfig which is `git commit --verbose`
nnoremap <leader>gc :$tab Git c<cr>
# nnoremap <leader>gd :tab Git diff<cr>

###################
# Source And Edit #
###################

nnoremap <leader>ev :$tabedit ~/.vimrc<cr>
nnoremap <leader>sv :source ~/.vimrc<cr>

nnoremap <leader>eb :$tabedit ~/Documents/personal-notes/.bashrc<cr>
nnoremap <leader>ef :$tabedit ~/.config/fish/config.fish<cr>
nnoremap <leader>ed :$tabedit ~/Documents/personal-notes/dev_notes.md<cr>
nnoremap <leader>eg :$tabedit ~/.gitconfig<cr>

nnoremap <leader>eu :UltiSnipsEdit<cr>
nnoremap <leader>es :UltiSnipsEdit<cr>

nnoremap <leader>et :JumpToTestFile<cr>

#############
# UltiSnips #
#############
g:UltiSnipsSnippetDirectories = [$HOME .. '/Documents/dotfiles/UltiSnips']
g:UltiSnipsEditSplit = "vertical"

# by default UltiSnipsExpandTrigger uses Tab, disable it for completor
g:UltiSnipsExpandTrigger = "<cr>"


#######################
# using python in vim #
#######################

def g:JumpToTestFile()
py3 << EOF
import vim
from vim_python import get_or_create_test_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_test_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"tabnew {test_filepath}")
EOF
enddef

command! JumpToTestFile call g:JumpToTestFile()

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
# nnoremap <leader>yid :call g:ImportFunction()<cr>
nnoremap <leader>yic :call g:ImportClass()<cr>
nnoremap <leader>yiw :call g:ImportWord()<cr>

nnoremap <leader>ypf :call g:ImportFunction()<cr>
# nnoremap <leader>ypd :call g:PatchFunction()<cr>
nnoremap <leader>ypw :call g:PatchWord()<cr>

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


########
# Jedi #
########

g:jedi#completions_enabled = 0
# disable docstring window to popup during completion
g:jedi#show_call_signatures = 0
g:jedi#usages_command = "<leader>u"

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
nmap , <plug>(easymotion-overwin-f)

g:EasyMotion_smartcase = 1

####################
# img paste plugin #
####################
g:mdip_imgdir = 'images'
# <leader>i - i stands for image to insert image in normal mode
autocmd FileType markdown nnoremap <buffer> <silent> <leader>i :call mdip#MarkdownClipboardImage()<cr>

###############
# delimitMate #
###############

# don't complete " in vim file
# didn't find a way so exclude the whole file
g:delimitMate_excluded_ft = "vim"

################
# vim-asterisk #
################

# * stays at the current cursor position, instead of jumpping to next
map *  <plug>(asterisk-z*)
map #  <plug>(asterisk-z#)
# g* is * search without word boundary \< \> 
map g* <plug>(asterisk-gz*)
map g# <plug>(asterisk-gz#)

################
# vim-asterisk #
################

map n <plug>(anzu-n-with-echo)
map N <plug>(anzu-N-with-echo)

g:asterisk#keeppos = 1

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

command! -bang -nargs=0 SynStack call SynStack()

##############
# diff color #
##############

# #C91B00 red from iterm ansi red
hi diffRemoved guifg=#C91B00
# #00C200 gren from iterm ansi green
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

##############################
# command line mode mappings #
##############################

cnoremap <c-j>   <down>
cnoremap <c-k>   <up>
cnoremap <c-h>   <left>
cnoremap <c-l>   <right>
cnoremap <up>    <nop>
cnoremap <down>  <nop>
cnoremap <left>  <nop>
cnoremap <right> <nop>

############
# Surround #
############

# :echo char2nr("b")
# 98
g:surround_98 = "**\r**"
# :echo char2nr("c")
# 99
g:surround_99 = "`\r`"

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

def g:GetPageNumberTotalPage(): string
    const LINES_PER_PAGE = 68
    const current_page_in_buffer = line('.') / LINES_PER_PAGE
    const total_number_of_pages_in_buffer = line('$') / LINES_PER_PAGE
    return printf("P:%02s/%02s",
        current_page_in_buffer,
        total_number_of_pages_in_buffer
   )
enddef

def g:GetHelpSectionName(): string
    # 'b'	search Backward instead of forward
    # 'n'	do Not move the cursor
    # 'W'	don't Wrap around the end of the file
    const section_header_line_number = search('^=\{70,}', 'bnW')
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
  const [added, modified, removed] = g:GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', added, modified, removed)
enddef

# left section
set statusline=\ %f    # filename
set statusline+=\ %{GetHelpSectionName()}

# middle section
set statusline+=%=
set statusline+=%{NearestMethodOrFunction()}
# set statusline+=%{GitStatus()}

# right section
set statusline+=%=
set statusline+=\ [%{expand(&filetype)}]
set statusline+=\ L:%03l/%03L # line number / total number or lines
set statusline+=\ C:%03c    # column number
set statusline+=\ %{GetPageNumberTotalPage()}

#########
# Black #
#########

# command! -range Black silent !black --quiet -

#########################
# Vim9 Compile Function #
#########################

# Uncomment the next line to compile the functions for tests 
defcompile

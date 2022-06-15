set nocompatible

" auto install vim plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
Plug '~/Documents/vim-slack-format' " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate' " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'airblade/vim-gitgutter' " shows a git diff in the sign column
Plug 'arthurxavierx/vim-caser' " changes word to Title Case `gst`
Plug 'djoshea/vim-autoread' " auto load changed file
Plug 'godlygeek/tabular' " Used in vim-markdown to align markdown table
Plug 'google/vim-searchindex' " shows number of search
Plug 'hashivim/vim-terraform' " basic vim/terraform integration
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire'
Plug 'markonm/traces.vim' " Range, pattern and substitute preview for Vim
Plug 'ntpeters/vim-better-whitespace' " highlight trailing whitespace
Plug 'plasticboy/vim-markdown' " add markdown syntax
Plug 'tomasr/molokai' " molokar color scheme
Plug 'tpope/vim-commentary' " add shortcut gc for making a comment
Plug 'tpope/vim-fugitive' " using git in vim
Plug 'tpope/vim-repeat' " repeat vim-surround with .
Plug 'tpope/vim-rhubarb' " supports github enterprise
Plug 'tpope/vim-surround' " The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-unimpaired' " adds mapping like [q ]q
Plug 'vim-scripts/ReplaceWithRegister' " gr{motion} go replace
Plug 'wellle/targets.vim' " adds textobjects e.g. i*, i_ usefll in markdown
call plug#end()

" change default leader \ to space, this setting needs to be in the beginning
nnoremap <space> <nop>
let mapleader = " "

" detect filetype
" use plugins for that filetype
" turn on indent files
" see more in `:help vimrc-filetype`
filetype plugin indent on

" better setting
set shortmess+=IW " ignore Intro, Written
set laststatus=2 " status bar always on
set wildmenu
set wildmode=longest:full,full " start on the longest option when you hit tab
set wildignore=*.class,*.o,*~,*.pyc,.git  " Ignore certain files when finding files
set hidden " files leave the screen become hidden buffer
set backspace=indent,eol,start
set tabstop=4 " show existing tab with 4 spaces width
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set hlsearch " highlight search result such as when using *
set scrolloff=1 " shows one more line above and below the cursor
set sidescrolloff=5 " similar to above but on the right
set display+=lastline " otherwise last line that doesn't fit is replaced with @ lines, see :help 'display'
set formatoptions+=j " Delete comment character when joining commented lines
set splitright " when using ctrl-w, split the window to the right
set path+=** " recursive by default when using :find
set autoread " automatically apply changes from outside of Vim
" this makes autoread work, doesn't work on command-line window
" au CursorHold * checktime " check one time after 4s of inactivity in normal mode
set complete-=i " remove included files, it is slow


" https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
" keep undo history after file is closed
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" color
syntax on
colorscheme molokai
" better Match parentheses, otherwise it looks like the current cursor is on
" the matched parenthesis
hi MatchParen      ctermfg=208  ctermbg=233 cterm=bold


" search
set ignorecase
set smartcase

" make the single quote works like a backtick
" puts the cursor on the column of a mark, instead of first non-blank
" character
nnoremap ' `

" qq to record, Q to replay
nnoremap Q @q

" Y to yank to the end of the line, mimic other capital commands
nnoremap Y y$

" copy/paste
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamedplus " vim uses system clipboard

" copy file path
nmap <leader>yp :let @+=expand("%")<cr>

" GitGutter
" see help (shortcut K) for gitgutter-mappings
set updatetime=100 " how long (in milliseconds) the plugin will wait for GitGutter
let g:gitgutter_map_keys = 0 " disable gitgutter map
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

" hunk text object
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" use G for git grep
" TODO: figure out how to slient the output to terminal
func GitGrep(...)
  " search for string, populate quickfix window with cursor at the begining
  " of search pattern
  let save = &grepprg
  set grepprg=git\ grep\ --line-number\ --column\ $*
  " grep format is file name:line number:column number:error message
  set grepformat=%f:%l:%c:%m
  let s = 'grep!' " ! to not jump to first result
  for i in a:000 " arguments in array
    let s = s . ' ' . i
  endfor
  silent execute s
  silent cwin
  redraw!
  let &grepprg = save
endfun
command -nargs=? G call GitGrep(<f-args>)

function! GrepWord()
  normal! "zyiw
  call GitGrep('--word-regexp', getreg('z'))
endf

command -nargs=? GW call GrepWord()

" Put swapfiles `$HOME/.vim/tmp/`
if !isdirectory($HOME."/.vim/tmp")
    call mkdir($HOME."/.vim/tmp", "", 0700)
endif
set directory^=$HOME/.vim/tmp/

" vim-markdown

" don't hide/conceal characters
let g:vim_markdown_conceal_code_blocks = 0
" disable folding
let g:vim_markdown_folding_disabled = 1
" diable indent on new list item
let g:vim_markdown_new_list_item_indent = 0

" vim-rhubarb
" for GBrowse github enterprice
let g:github_enterprise_urls = ['https://git.lystit.com']

set spellfile=$HOME/Documents/private_dotfiles/spell/en.utf-8.add
" spell check for markdown and git commit message
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType slack setlocal spell
autocmd FileType txt setlocal spell

" Enable dictionary auto-completion in Markdown files and Git Commit Messages
autocmd FileType gitcommit setlocal complete+=kspell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType slack setlocal complete+=kspell
autocmd FileType txt setlocal complete+=kspell

" don't break a word in the middle
autocmd FileType gitcommit setlocal linebreak
autocmd FileType markdown setlocal linebreak
autocmd FileType slack setlocal linebreak
autocmd FileType txt setlocal linebreak

" set shiftwidth
autocmd FileType markdown setlocal shiftwidth=4
autocmd FileType sh setlocal shiftwidth=4

" use ctrl j to scroll down one line
nnoremap <C-J> <C-E>
" use ctrl k to scroll up one line
nnoremap <C-K> <C-Y>

" use leader f to :find
nnoremap <silent> <leader>f <esc>:find<space>
" Abbreviation for vertical split find
cabbrev vsf vert sfind

" use leader c to clear search highlight
nnoremap <silent> <leader>c :nohlsearch<cr>

" leader z to autocorrect words and move cursor to the end of the word
nnoremap <silent> <leader>z 1z=<cr>g;e

" sort this paragraph
nnoremap <silent> <leader>s Vip:sort<cr>
vnoremap <silent> <leader>s :sort<cr>

" this makes file autocomplete in notes auto completes other notes even when I am in the root directory `~/notes`
autocmd BufRead,BufNewFile $HOME/Documents/notes/* set autochdir

" insert filename in title case, used for personal notes
" "%p - paste current filename (in register %)
" gst - gst uses vim-caser to turn word in title mode
" il  - il uses kana/vim-textobj-line to apply on whole line
" <delete><delete> - remove the md in markdown file extension
" I#  - adds markdown title with a space at the front
nmap <silent> <leader>it "%pgstil<delete><delete>I# <esc>

" insert agenda
nnoremap <silent> <leader>ia :read !agenda<cr>

" insert formatted git branch as git commit message
" 0 in 0read to insert on the same line with cursor otherwise the message is
" added to line below cursor
nnoremap <silent> <leader>im :0read !git_commit_message<cr>

"" Surround
" Works globally, because it won't affect any other filetype really
" Useful in markdown and git commit messages
" `code`
let b:surround_{char2nr("c")} = "`\r`"
" **bold**
let b:surround_{char2nr("b")} = "**\r**"
" [link](url)
let b:surround_{char2nr("l")} = "[\r]()"
" _italic_
let b:surround_{char2nr("i")} = "_\r_"

autocmd FileType slack let b:surround_{char2nr("b")} = "*\r*"

"" vim-textobj-user

" use `al` to represent a link in markdown
call textobj#user#plugin('link', {
\   'angle': {
\     'pattern': ['[', ')'],
\     'select-a': 'al',
\   },
\ })

" restore cursor last position
" from usr_05.txt
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


function! OpenJIRA()
  " open jira ticket under cursor
  let l:ticket = matchstr(expand("<cWORD>"), "[A-Z]*-[0-9]*")
  if l:ticket != ""
    silent execute "!google-chrome-stable https://jira.lystit.com/browse/'".l:ticket."'"
    redraw!
  else
    echo "No Ticket found in line."
  endif
endfunction
nnoremap <leader>j :call OpenJIRA()<cr>

" Deprecated by git_commit_message
" insert jira ticket by extracting from git branch name, e.g. FOO-123-bar
" nnoremap <leader>t :read !git rev-parse --abbrev-ref HEAD \| cut -d "-" -f 1,2<cr>

" jira filetype
autocmd BufNewFile,BufRead *.jira set filetype=jira

" abbreviates
autocmd FileType markdown abbreviate ttt \|\|\|<cr>\|-\|-\|<cr>\|\|\|
autocmd FileType python abbreviate pparam @pytest.mark.parametrize()

abbreviate :+1: 👍
abbreviate :-1: 👎
abbreviate :idea: 💡
abbreviate :tada: 🎉
abbreviate :focus: 🔎

" show table of content for markdown file
nnoremap <leader>t :Toch<cr>

" vimrc
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>


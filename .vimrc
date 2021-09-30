set nocompatible
filetype off

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
Plug 'Raimondi/delimitMate' " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'Yggdroot/indentLine' " hightlight indentations
Plug 'airblade/vim-gitgutter' " shows a git diff in the sign column
Plug 'google/vim-searchindex' " shows number of search
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire'
Plug 'markonm/traces.vim' " Range, pattern and substitute preview for Vim
Plug 'tomasr/molokai' " molokar color scheme
Plug 'tpope/vim-commentary' " add shortcut gc for making a line comment
Plug 'tpope/vim-surround' " The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-unimpaired' " adds mapping like [q ]q
Plug 'vim-scripts/ReplaceWithRegister' " gr{motion} go replace
call plug#end()

" change leader to space, this setting needs to be in the beginning
nnoremap <SPACE> <nop>
let mapleader = " "

" better setting
set shortmess+=IWA " ignore Intro, Written and swapfile exists
set laststatus=2 " status bar always on
set wildmenu
set wildignore=*.class,*.o,*~,*.pyc,.git  " Ignore certain files when finding files
set autoread " automatically apply changes from outside of Vim
set hidden " files leave the screen become hidden buffer
set backspace=indent,eol,start
set number " add line number before each line in vim
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>

" finding files
set path+=** " recursive by default when using :find

" color
syntax on
colorscheme molokai
" better Match parentheses, otherwise it looks like the current cursor is on
" the matched parenthesis
hi MatchParen      ctermfg=208  ctermbg=233 cterm=bold


" search
set ignorecase
set smartcase

" qq to record, Q to replay
nnoremap Q @q

" Y to yank to the end of the line, mimic other capital commands
nnoremap Y y$

" copy/paste
set clipboard+=unnamed " vim uses system clipboard

" ctags
" ctags -R **/*.py    " create ctags for python file only
" <ctrl>]       " jump to tag
" % cat ~/.ctags 
" --recurse=yes
" --exclude=.git
" --exclude=vendor/*
" --exclude=node_modules/*
" --exclude=db/*
" --exclude=log/*
" --python-kinds=-i

" GitGutter
" see help (shortcut K) for gitgutter-mappings
set updatetime=100 " how long (in milliseconds) the plugin will wait for GitGutter
" <Leader>hp              Preview the hunk under the cursor.
" <Leader>hs              Stage the hunk under the cursor.
" <Leader>hu              Undo the hunk under the cursor.
" ]c                      Jump to the next [count] hunk.
" [c                      Jump to the previous [count] hunk.
" Hunk text object:
" 'ic' operates on the current hunk's lines.  'ac' does the same but also includes
" trailing empty lines.

" indentLine
let g:indentLine_fileTypeExclude = ['help']

" folding all classes method and functions in python
" set foldmethod=indent
" set foldnestmax=2
" set foldlevel=1

" use G for git grep
function! GitGrep(arg)
  setlocal grepprg=git\ grep\ --no-color\ -n\ $*
  silent execute ':grep '.a:arg
  silent cwin
  redraw!
endfunction

command -nargs=? G call GitGrep(<f-args>)

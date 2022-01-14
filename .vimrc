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
Plug '~/Documents/vim-slack-format' " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate' " automatic closing of quotes, parenthesis, brackets, etc.
" Plug 'Yggdroot/indentLine' " hightlight indentations
Plug 'airblade/vim-gitgutter' " shows a git diff in the sign column
Plug 'arthurxavierx/vim-caser' " changes word to Title Case `gst`
Plug 'godlygeek/tabular' " Used in vim-markdown to align markdown table
Plug 'google/vim-searchindex' " shows number of search
Plug 'hashivim/vim-terraform' " basic vim/terraform integration
Plug 'junegunn/vim-peekaboo' " see contents of registers
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
call plug#end()

" change leader to space, this setting needs to be in the beginning
nnoremap <SPACE> <nop>
let mapleader = " "

" better setting
set shortmess+=IWA " ignore Intro, Written and swapfile exists
set laststatus=2 " status bar always on
set wildmenu
set wildmode=longest:full,full " start on the longest option when you hit tab
set wildignore=*.class,*.o,*~,*.pyc,.git  " Ignore certain files when finding files
set hidden " files leave the screen become hidden buffer
set backspace=indent,eol,start
set number " add line number before each line in vim
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set hlsearch " highlight search result such as when using *
set scrolloff=1 " shows one more line above and below the cursor
set sidescrolloff=5 " similar to above but on the right
set display+=lastline " otherwise last line that doesn't fit is replaced with @ lines, see :help 'display'
set formatoptions+=j " Delete comment character when joining commented lines
set linebreak " prevents breaking up the last word in lines exceeding the vim window width, useful for writing and reading in markdown
set splitright " when using ctrl-w, split the window to the right
set path+=** " recursive by default when using :find
set autoread " automatically apply changes from outside of Vim
" this makes autoread work
au CursorHold * checktime " check one time after 4s of inactivity in normal mode
set complete-=i " remove included files, it is slow

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
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamedplus " vim uses system clipboard

" GitGutter
" see help (shortcut K) for gitgutter-mappings
set updatetime=100 " how long (in milliseconds) the plugin will wait for GitGutter
let g:gitgutter_map_keys = 0
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
func GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
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
  call GitGrep('-w -e ', getreg('z'))
endf

command -nargs=? GW call GrepWord()

" vim-markdown

" don't hide/conceal characters
" let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" disable folding
let g:vim_markdown_folding_disabled = 1

" required by tpope/vim-rhubarb for github enterprice, for GBrowse
let g:github_enterprise_urls = ['https://git.lystit.com']

set spellfile=$HOME/Documents/private_dotfiles/spell/en.utf-8.add
" spell check for markdown and git commit message

autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType slack setlocal spell

" Enable dictionary auto-completion in Markdown files and Git Commit Messages
autocmd FileType gitcommit setlocal complete+=kspell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType slack setlocal complete+=kspell

" If you are using the 'indentLine' plugin or other plugins that can change 'conceal' features in vim. It is because these plugin enables the Vim 'conceal' feature which automatically hides stretches of text based on syntax highlighting. This setting will apply to all syntax items. Specifically, in 'indentLine' plugin, it will overwrite "concealcursor" and "conceallevel" to:
" let g:indentLine_concealcursor = 'inc'
" let g:indentLine_conceallevel = 2
let g:indentLine_concealcursor = ""

" use leader c to clear search highlight
nnoremap <silent> <leader>c :nohlsearch<CR>

" use leader w to save
nnoremap <silent> <leader>w :w<CR>
" use leader x to save and close
nnoremap <silent> <leader>x :x<CR>

" leader z to autocorrect words and move cursor to the end of the word
nnoremap <silent> <leader>z 1z=<CR>g;e

" open file under cursor in vertical window
nnoremap <C-W><C-F> <C-W>vgf

" Simulate Ranger Interface
" leader l to open link undercursor in the right window
nnoremap <silent> <leader>l <C-W>vgf
" leader h to quit the link
nnoremap <silent> <leader>h :q<CR>

" this makes file autocomplete in notes auto completes other notes even when I am in the root directory `~/notes`
autocmd BufRead,BufNewFile $HOME/Documents/notes/* set autochdir

" <leader>it - insert filename in title case, used for notes
" "%p - paste current filename (in register %)
" gst - gst uses vim-caser to turn word in title mode
" il  - il uses kana/vim-textobj-line to apply on whole line
" <delete><delete> - remove the md in markdown file extension
" I#  - adds markdown title with a space at the front
nmap <silent> <leader>it "%pgstil<delete><delete>I# <esc>

"" Surround
" Works globally, because it won't affect any other filetype really
" Useful in markdown and git commit messages
let b:surround_{char2nr("*")} = "**\r**"
let b:surround_{char2nr("l")} = "[\r]()"

autocmd FileType slack let b:surround_{char2nr("*")} = "*\r*"

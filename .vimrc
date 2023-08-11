set nocompatible

" auto install vim plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'Raimondi/delimitMate'            " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'airblade/vim-gitgutter'          " shows a git diff in the sign column
Plug 'arthurxavierx/vim-caser'         " changes word to Title Case `gst`
Plug 'davidhalter/jedi-vim'            " vim python, leader d to go to definition
Plug 'ekalinin/Dockerfile.vim'         " dockerfile syntax
Plug 'google/vim-searchindex'          " shows number of search
Plug 'SirVer/ultisnips'                " snippets
Plug 'jparise/vim-graphql'             " graphql syntax highlight
Plug 'junegunn/fzf'                    " ca# to change after # used in markdown
Plug 'junegunn/fzf.vim'                " ca# to change after # used in markdown
Plug 'inkarkat/vim-visualrepeat'       " use . in selected lines in visual mode
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire'
Plug 'markonm/traces.vim'              " Range, pattern and substitute preview for Vim
Plug 'maralla/completor.vim'           " fuzzy complete, type 'fzcl' then <Tab> to complete to 'fuzzy complete'
Plug 'plasticboy/vim-markdown'         " add markdown syntax
Plug 'preservim/nerdtree'              " tree explorers
Plug 'tomasr/molokai'                  " molokar color scheme
Plug 'tommcdo/vim-lion'                " use gl<motion>: to align sentences with :
Plug 'tpope/vim-commentary'            " add shortcut gc for making a comment
Plug 'tpope/vim-fugitive'              " using git in vim
Plug 'tpope/vim-repeat'                " repeat vim-surround with .
Plug 'tpope/vim-rhubarb'               " supports for :GBrowse to github
Plug 'tpope/vim-surround'              " The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-unimpaired'            " adds mapping like [q ]q
Plug 'vim-scripts/ReplaceWithRegister' " gr{motion} go replace
Plug 'wellle/targets.vim'              " adds textobjects e.g. i*, i_ usefll in markdown
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
set number
set shortmess+=IW " ignore Intro, Written
set laststatus=2 " status bar always on
set wildmenu
set wildmode=longest:full,full " start on the longest option when you hit tab
" set wildignore=*.class,*.o,*~,*.pyc,.git  " Ignore certain files when finding files
set hidden " files leave the screen become hidden buffer
set backspace=indent,eol,start
set tabstop=4 " show existing tab with 4 spaces width
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set hlsearch " highlight search result such as when using *
set scrolloff=1 " shows one more line above and below the cursor
set sidescrolloff=5 " similar to above but on the right
set display+=lastline " otherwise last line that doesn't fit is replaced with @ lines, see :help 'display'
set formatoptions+=j " Delete comment character when joining commented lines
set splitright " when using :vsp put the split window to the right
" set path+=** " recursive by default when using :find
set autoread " automatically apply changes from outside of Vim
" this makes autoread work, doesn't work on command-line window
" au CursorHold * checktime " check one time after 4s of inactivity in normal mode
set complete-=i " remove included files, it is slow
set shiftwidth=4 " set shiftwidth - default indent
set mouse=a " support mouse in iTerm
set noswapfile
set regexpengine=0 " fix tsx files too slow



" https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
" keep undo history after file is closed
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
" search
set ignorecase
set smartcase


" color
syntax on
colorscheme molokai
" better Match parentheses, otherwise it looks like the current cursor is on
" the matched parenthesis
hi MatchParen      ctermfg=208  ctermbg=233 cterm=bold


" make the single quote works like a backtick
" puts the cursor on the column of a mark, instead of first non-blank
" character
nnoremap ' `

" qq to record, Q to replay
nnoremap Q @q

" Y to yank to the end of the line, mimic other capital commands
nnoremap Y y$

" jump to tags
" prompt to select if there are multiple matching tags
" jump to the only tag
nnoremap <C-]> g<C-]>

" copy/paste
" https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
set clipboard=unnamed " vim uses system clipboard

" copy relative path  e.g. src/foo.txt
nnoremap <leader>yp :let @+=expand("%")<cr>:echo 'yanked' @+<cr>
" copy file name      e.g. foo.txt
nnoremap <leader>yn :let @+=expand("%:t")<cr>:echo 'yanked' @+<cr>

" copy python function & class name
" use with pytest -k FUNCTION NAME
nnoremap <leader>yf ?def<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>
nnoremap <leader>yd ?def<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>

nnoremap <leader>yc ?^class<cr>wyiw<c-o>:nohlsearch<cr>:echo 'yanked' @+<cr>

"""""""""""""
" GitGutter "
"""""""""""""

" see help (shortcut K) for gitgutter-mappings
set updatetime=100 " how long (in milliseconds) the plugin will wait for GitGutter
let g:gitgutter_map_keys = 0 " disable gitgutter map
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)

""""""""""""""""
" vim-markdown "
""""""""""""""""

" conceal characters such as bold, italic and link
autocmd FileType markdown set conceallevel=2

" gives italic, bold and italic bold fonts a more noticeable white color
" needed to change htmlBold because plugin vim-markdown uses HTML Syntax
" https://github.com/preservim/vim-markdown/blob/df4be8626e2c5b2a42eb60e1f100fce469b81f7d/syntax/markdown.vim#L11
autocmd FileType markdown hi htmlBold        ctermfg=15
autocmd FileType markdown hi htmlItalic      ctermfg=15
autocmd FileType markdown hi htmlBoldItalic  ctermfg=15

" don't hide/conceal code blocks
"
let g:vim_markdown_conceal_code_blocks = 0
" disable folding
let g:vim_markdown_folding_disabled = 1
" diable indent on new list item
let g:vim_markdown_new_list_item_indent = 0

set spellfile=$HOME/Documents/saltus-notes/spell/en.utf-8.add
" spell check for markdown and git commit message
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType txt setlocal spell

" Enable dictionary auto-completion in Markdown files and Git Commit Messages
autocmd FileType gitcommit setlocal complete+=kspell
autocmd FileType markdown setlocal complete+=kspell
autocmd FileType txt setlocal complete+=kspell

" don't break a word in the middle
autocmd FileType gitcommit setlocal linebreak
autocmd FileType markdown setlocal linebreak
autocmd FileType txt setlocal linebreak

" set indent
autocmd FileType markdown setlocal foldmethod=manual

" use ctrl j to scroll down one line
nnoremap <C-J> <C-E>
" use ctrl k to scroll up one line
nnoremap <C-K> <C-Y>

" leader b to jump to previous buffer
nnoremap <leader>b :bprevious<cr>

" use leader c to clear search highlight
nnoremap <silent> <leader>c :nohlsearch<cr>

" leader z to autocorrect words and move cursor to the end of the word
nnoremap <silent> <leader>z 1z=<cr>g;e

" this makes file autocomplete in notes auto completes other notes even when I am in the root directory `~/notes`
autocmd BufRead,BufNewFile $HOME/Documents/notes/* set autochdir

autocmd BufRead,BufNewFile $HOME/Documents/saltus-notes/*.md set nospell

" insert filename in title case, used for personal notes
" "%p - paste current filename (in register %)
" gst - gst uses vim-caser to turn word in title mode
" il  - il uses kana/vim-textobj-line to apply on whole line
" <delete><delete> - remove the md in markdown file extension
" I#  - adds markdown title with a space at the front
nmap <silent> <leader>it "%pgstil<delete><delete>I# <esc>

" use <enter> to put x into readme todo [ ]
autocmd FileType markdown nnoremap <silent> <cr> ^f[lrx

" restore cursor last position
" from usr_05.txt
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

"""""""
" tab "
"""""""
" open current file in new tab
nnoremap <leader>t :tabedit %<cr>
" L, H are just jump to bottom or top of screen, not very useful
" next tab
nnoremap L gt
" previous tab
nnoremap H gT
" leader number to go to tab
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt

"""""""
" fzf "
"""""""
nnoremap <leader>fs :Snippets<cr>
nnoremap <leader><leader> :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fc :Commands<cr>
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fl :BLines<cr>
" nnoremap <leader>fm :Marks<cr>
nnoremap <leader>fm :Maps<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fw :Rg <c-r><c-w><cr>

" disable preview window
" let g:fzf_preview_window = []

nnoremap <leader>q :wqa<cr>

"""""""""""""""""""""""""
" Git Fugutive Commands "
"""""""""""""""""""""""""

" :Gd for open each changed file
command! -bang -nargs=? TGd  :Git difftool
" -y for open in new tab
command! -bang -nargs=? TGdt  :Git difftool -y

" :Gdo for open each changed file compared to origin/master
command! -bang -nargs=? TGdo :Git difftool origin/master...
command! -bang -nargs=? TGdot :Git difftool -y origin/master...

function! BindOff()
    " disable the moving together in git diff tab with vertical split
    windo set nocursorbind
    windo set noscrollbind
endfunction

command! -bang -nargs=? TBindOff :call BindOff()

"""""""""""""""""""
" Source And Edit "
"""""""""""""""""""

command! -bang -nargs=? SourceVimrc :source ~/.vimrc
command! -bang -nargs=? EVimrc :$tabedit ~/.vimrc
command! -bang -nargs=? EZshrc :$tabedit ~/.zshrc
command! -bang -nargs=? ESaltusBashrc :$tabedit ~/saltus-notes/.bashrc
command! -bang -nargs=? EUltiSnips :UltiSnipsEdit

"""""""""""""
" UltiSnips "
"""""""""""""
let g:UltiSnipsSnippetDirectories=[$HOME.'/Documents/dotfiles/UltiSnips']
let g:UltiSnipsEditSplit="vertical"

" by default UltiSnipsExpandTrigger uses Tab, disable it for completor
let g:UltiSnipsExpandTrigger="<cr>"

"""""""""""""""""
" format & lint "
"""""""""""""""""

let g:flake8_command="flake8 --config ~/Documents/oneview/saltus/.flake8 --ignore E721,W503 "

function! Lint()
    " run black in the background
    call job_start('black '.shellescape(expand('%')))

    " TODO convert this system to job_start to run in the background
    let l:error_list = system(g:flake8_command . shellescape(expand('%')))
    cexpr l:error_list
endfunction

function! LintAll()
    " run black in the background
    call job_start('black .')

    let l:error_list = system(g:flake8_command. '.')
    cexpr l:error_list
endfunction

command! -bang -nargs=? Black    :!black %
command! -bang -nargs=? Lint    :call Lint()
command! -bang -nargs=? TLintAll :call LintAll()

"""""""""""""""""""""""
" using python in vim "
"""""""""""""""""""""""

function! JumpToTestFile()
py3 << EOF
import vim
from vim_python import get_or_create_test_file

# vim.eval("@%") gets the filepath in current buffer
test_filepath = get_or_create_test_file(filepath=vim.eval("@%"))

# open test_filepath in current window
vim.command(f"edit {test_filepath}")
EOF
endfunction

command! JumpToTestFile call JumpToTestFile()

""""""""
" Jedi "
""""""""

let g:jedi#completions_enabled = 0
" disable docstring window to popup during completion
let g:jedi#show_call_signatures = 0

""""""""""""
" NERDTree "
""""""""""""

let NERDTreeIgnore=['__pycache__']
nnoremap <leader>f :NERDTreeFind<cr>

"""""""""""""""""
" completor.vim "
"""""""""""""""""

" Use TAB to complete when typing words, else inserts TABs as usual.  Uses
" dictionary, source files, and completor to find matching words to complete.

" Note: usual completion is on <C-n> but more trouble to press all the time.
" Never type the same word twice and maybe learn a new spellings!
" Use the Linux dictionary when spelling is in doubt.
function! Tab_Or_Complete() abort
  " If completor is already open the `tab` cycles through suggested completions.
  if pumvisible()
    return "\<C-N>"
  " If completor is not open and we are in the middle of typing a word then
  " `tab` opens completor menu.
  elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^[[:keyword:][:ident:]]'
    return "\<C-R>=completor#do('complete')\<CR>"
  else
    " If we aren't typing a word and we press `tab` simply do the normal `tab`
    " action.
    return "\<Tab>"
  endif
endfunction

" Use `tab` key to select completions.  Default is arrow keys.
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use tab to trigger auto completion.  Default suggests completions as you type.
let g:completor_auto_trigger = 0
inoremap <expr> <Tab> Tab_Or_Complete()

let g:completor_complete_options = 'menu,preview'

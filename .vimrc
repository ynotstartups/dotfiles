""""""""""""""""""
" Documentations "
""""""""""""""""""

" vim's library is at /usr/share/vim/vim90/
"
set nocompatible

" auto install vim plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'Raimondi/delimitMate'            " automatic closing of quotes, parenthesis, brackets, etc.
Plug 'SirVer/ultisnips'                " snippets
Plug 'airblade/vim-gitgutter'          " shows a git diff in the sign column
Plug 'arthurxavierx/vim-caser'         " changes word casing: `gst` Foo Bar, `gs_` foo_bar, `gsm` FooBar
Plug 'davidhalter/jedi-vim'            " vim python, leader k to go to doc, leader d to definition
Plug 'easymotion/vim-easymotion'       " use a + character to jump around the code
Plug 'ekalinin/Dockerfile.vim'         " dockerfile syntax
Plug 'haya14busa/is.vim'               " Automatically clear highlight 
Plug 'haya14busa/vim-asterisk'         " * stays where it is
Plug 'img-paste-devs/img-paste.vim'    " leader p to paste image to markdown file
Plug 'inkarkat/vim-visualrepeat'       " use . in selected lines in visual mode
Plug 'jparise/vim-graphql'             " graphql syntax highlight
Plug 'junegunn/fzf'                    " fzf
Plug 'junegunn/fzf.vim'                " fzf vim
Plug 'junegunn/goyo.vim'               " :Goyo for distraction free writing and reading mode
Plug 'junegunn/vim-easy-align'         " ga= align first =, ga2= align second =, ga*= align all =
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-entire' | Plug 'thinca/vim-textobj-between' " dif_ to delete foo in _ foo _
Plug 'liuchengxu/vista.vim'            " :Vista for tag viewer & markdown table of contents
Plug 'maralla/completor.vim'           " fuzzy complete, type 'fzcl' then <tab> to complete to 'fuzzy complete'
Plug 'markonm/traces.vim'              " Range, pattern and substitute preview for Vim
Plug 'osyo-manga/vim-anzu'             " works with is.vim to show the number of searches
Plug 'plasticboy/vim-markdown' | Plug 'godlygeek/tabular' " add markdown syntax and :TableFormat to format table
Plug 'preservim/nerdtree'              " tree explorers
Plug 'tomasr/molokai'                  " molokar color scheme
Plug 'tpope/vim-commentary'            " add shortcut gc for making a comment
Plug 'tpope/vim-fugitive'              " using git in vim
Plug 'tpope/vim-repeat'                " repeat vim-surround with .
Plug 'tpope/vim-rhubarb'               " supports for :GBrowse to github
Plug 'tpope/vim-surround'              " The plugin provides mappings to easily delete, change and add such surroundings in pairs.
Plug 'tpope/vim-unimpaired'            " adds mapping like [q ]q
Plug 'vim-scripts/ReplaceWithRegister' " gr{motion} go replace
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
set expandtab " In Insert mode: Use the appropriate number of spaces to insert a <tab>
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
set incsearch " incremental search
set belloff=all " no spell from vim
set spellcapcheck= " turn off spell check says first character not captical as error

set statusline =\ %n    " buffer number
set statusline+=\ %f    " filename
set statusline+=%=      " right align
set statusline+=\ %{expand(&filetype)}
set statusline+=\ %l/%L " line number / total number or lines
set statusline+=\ %c    " column number
set statusline+=\ %p%%  " percentage


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

"""""""""""""""
" Colorscheme "
"""""""""""""""

syntax on
set termguicolors
colorscheme molokai

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
" note that updatetime is also used by autosave on save per second
set updatetime=1000 " how long (in milliseconds) the plugin will wait for GitGutter
let g:gitgutter_map_keys = 0 " disable gitgutter map
nmap ]h <plug>(GitGutterNextHunk)
nmap [h <plug>(GitGutterPrevHunk)
nmap <leader>hp <plug>(GitGutterPreviewHunk)
nmap <leader>ha <plug>(GitGutterStageHunk)
nmap <leader>hs <plug>(GitGutterStageHunk)
nmap <leader>hu <plug>(GitGutterUndoHunk)

" Do I want GitGutterQuickFixCurrentFile too?
command! GitGutterQ GitGutterQuickFix | copen
nnoremap <leader>hq :GitGutterQ<cr>

""""""""""""
" markdown "
""""""""""""

" default ftplugin vim-markdown
" in /opt/homebrew/Cellar/vim/9.0.1800/share/vim/vim90/ftplugin/markdown.vim
" Syntax highlight is synchronized in 50 lines. It may cause collapsed
" highlighting at large fenced code block. In the case, please set larger
" value in your vimrc:  
let g:markdown_minlines = 100
let g:no_markdown_maps = 1

" leader l create link with link from clipboard
" <esc> exit visual mode
" a() insert () after the last word of visual selection
" <esc><left> move cursor to be in the middle of ()
" p paste link from clipboard
" gv go back to the visual select
" "ac[] change the visual select to [] & save to visual select to register a
" <left><esc>"ap paste visual select from register a in the middle of []
" P.S. register a is used to avoid changing the clipboard 
autocmd FileType markdown,gitcommit vnoremap <leader>l <esc>a()<esc><left>pgv"ac[]<left><esc>"ap

" conceal characters such as bold, italic and link
autocmd FileType markdown set conceallevel=2

autocmd FileType markdown set colorcolumn=80
autocmd FileType markdown set textwidth=78

" hack: uses `>` to act as comments so that I can use gq to format it
autocmd FileType markdown setlocal comments=:>
" r: Automatically insert the current comment leader after hitting <Enter> in
" Insert mode.
" o: Automatically insert the current comment leader after hitting 'o' or 'O'
" in Normal mode.
" j: Where it makes sense, remove a comment leader when joining lines.
" c: Auto-wrap comments using 'textwidth', inserting the current comment
" leader automatically.
" q: Allow formatting of comments with `gq`
" n: gq to format list e.g. - , using formatlistpat below
" t: Auto-wrap text using 'textwidth'
autocmd FileType markdown setlocal formatoptions=rojcqnt
" pattern for list e.g. - 
" explanation: each \ needs to becomes \\ so patten '^\\s*[-]\\s\\+' is actually '^\s*[-]\s\+'
autocmd FileType markdown setlocal formatlistpat=^\\s*[-]\\s\\+
" pattern for todo list e.g. - [ ]
" autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*[-]\\s[[]\\s[]]\\s\\+
" pattern for completed todo list e.g. - [x]
" autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*[-]\\s[[]x[]]\\s\\+
" pattern for number list e.g. - 1. 
autocmd FileType markdown setlocal formatlistpat+=\\\|^\\s*\\d[.]\\s\\+

" don't hide/conceal code blocks
let g:vim_markdown_conceal_code_blocks = 0
" disable folding
let g:vim_markdown_folding_disabled = 1
" diable indent on new list item
let g:vim_markdown_new_list_item_indent = 0

autocmd FileType markdown nnoremap gx <Plug>Markdown_OpenUrlUnderCursor

" unmap all mappings need to for my custom map [[ and ]] 
let g:vim_markdown_no_default_key_mappings = 1
" default filetype plugin maps [[ and ]], unmap it
let g:no_markdown_maps = 1

function! GoToCountHeaderBelow() range
  execute "normal! " .v:count. "/^#\<cr>"
endfunction
" 5]] to goes to fifth header below
autocmd FileType markdown nnoremap ]] :<c-u>call GoToCountHeaderBelow()<cr>
function! GoToCountHeaderAbove() range
  execute "normal! " .v:count. "?^#\<cr>"
endfunction
" 5]] to goes to fifth header below
autocmd FileType markdown nnoremap [[ :<c-u>call GoToCountHeaderAbove()<cr>

" da3 to delete all contents in current header with header line
" di3 to delete all contents in current header without header line
" 3 is because shift 3 is #, but 3 is easy to type
augroup markdown_textobjs
  autocmd!
  autocmd FileType markdown call textobj#user#plugin('markdown', {
  \   'header': {
  \     'select-a-function': 'AMarkdownHeader',
  \     'select-a': 'a3',
  \     'select-i-function': 'InMarkdownHeader',
  \     'select-i': 'i3',
  \   },
  \ })
augroup END

function! EndOfFileOrOneLineAboveHeader()
  " cursor goes to oneline above the next header
  " or end of file to if cursor is in last header
  " regex explaination
  " /^# next header
  " \|  or
  " \%$ end of file 
  " needed the \\ to get a literal \
  execute "normal! /^#\\|\\%$\<cr>"
  " if current line is a header line put cursor to one line above
  " else it's end of the file so we don't need to put cursor to one line
  " above
  if getline('.') =~ '^#'
      execute "normal! \<up>"
  endif
endfunction

function! AMarkdownHeader()
  set nowrapscan
  " cursor goes to the last header
  " or the start of file
  execute "normal! $"
  execute "normal! ?^#\<cr>"

  let head_pos = getpos('.')
  call EndOfFileOrOneLineAboveHeader()
  let tail_pos = getpos('.')
  set wrapscan

  return ['V', head_pos, tail_pos]
endfunction

function! InMarkdownHeader()
  set nowrapscan
  execute "normal! $"
  execute "normal! ?^#?+1\<cr>"

  let head_pos = getpos('.')
  call EndOfFileOrOneLineAboveHeader()
  let tail_pos = getpos('.')
  set wrapscan
  return ['V', head_pos, tail_pos]
endfunction

"""""""""
" Spell "
"""""""""

set spellfile=$HOME/Documents/personal-notes/spell/en.utf-8.add
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

autocmd BufRead,BufNewFile $HOME/Documents/personal-notes/*.md set nospell

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
" move tabpage to the left
nnoremap <c-s-h> :tabmove -<cr>
" move tabpage to the right
nnoremap <c-s-l> :tabmove +<cr>
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
" search all lines in open buffers
nnoremap <leader>fl :Lines<cr>
" nnoremap <leader>fm :Marks<cr>
nnoremap <leader>fm :Maps<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fw :Rg <c-r><c-w><cr>
nnoremap <leader>fh :History<cr>

" disable preview window
" let g:fzf_preview_window = []

nnoremap <leader>q <esc>:qa<cr>

""""""""""""""""
" Git Fugitive "
""""""""""""""""

set diffopt=vertical  
" use wrap for diff
set diffopt+=followwrap

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

nnoremap <leader>ev :$tabedit ~/.vimrc<cr>
command! -bang -nargs=? Ev :$tabedit ~/.vimrc

nnoremap <leader>ez :$tabedit ~/.zshrc<cr>
command! -bang -nargs=? Ez :$tabedit ~/.zshrc

nnoremap <leader>ed :$tabedit ~/Documents/personal-notes/dev_notes.md<cr>
command! -bang -nargs=? Ed :$tabedit ~/Documents/personal-notes/dev_notes.md

nnoremap <leader>eu :UltiSnipsEdit<cr>
command! -bang -nargs=? Eu :UltiSnipsEdit

nnoremap <leader>et :JumpToTestFile<cr>

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
command! -bang -nargs=? Lint     :call Lint()
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
vim.command(f"tabnew {test_filepath}")
EOF
endfunction

command! JumpToTestFile call JumpToTestFile()

" known bug
" this import function name doesn't work if the function is a method in a class
function! ImportFunctionName()
execute "normal! ?def\<cr>wyiw\<c-o>"
py3 << EOF
import vim
from vim_python import get_import_statement
import_statement = get_import_statement(
    # vim.eval("@%") gets the filepath in current buffer
    filepath=vim.eval("@%"),
    # vim.eval("@0") gets the last yanked text, which is a function name
    function_or_class_name=vim.eval("@0"),
)
vim.command(f"echom 'yanked {import_statement}'")
EOF
endfunction

function! ImportClassName()
execute "normal! ?^class\<cr>wyiw\<c-o>"
py3 << EOF
import vim
from vim_python import get_import_statement
import_statement = get_import_statement(
    # vim.eval("@%") gets the filepath in current buffer
    filepath=vim.eval("@%"),
    # vim.eval("@0") gets the last yanked text, which is a class name
    function_or_class_name=vim.eval("@0"),
)
vim.command(f"echom 'yanked {import_statement}'")
EOF
endfunction

command! YankImportFunctionName call ImportFunctionName()
command! YankImportClassName    call ImportClassName()

nnoremap <leader>yif :YankImportFunctionName<cr>
nnoremap <leader>yid :YankImportFunctionName<cr>
nnoremap <leader>yic :YankImportClassName<cr>


""""""""
" Jedi "
""""""""

let g:jedi#completions_enabled = 0
" disable docstring window to popup during completion
let g:jedi#show_call_signatures = 0
let g:jedi#usages_command = "<leader>u"

""""""""""""
" NERDTree "
""""""""""""

let NERDTreeIgnore=['__pycache__']
nnoremap <leader>n :NERDTreeFind<cr>

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
    return "\<C-R>=completor#do('complete')\<cr>"
  else
    " If we aren't typing a word and we press `tab` simply do the normal `tab`
    " action.
    return "\<tab>"
  endif
endfunction

" Use `tab` key to select completions.  Default is arrow keys.

" Use tab to trigger auto completion.  Default suggests completions as you type.
let g:completor_auto_trigger = 0
inoremap <expr> <tab> Tab_Or_Complete()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" removes the preview window
let g:completor_complete_options = 'menu'

" change from default 2 chars to 1 char
let g:completor_min_chars = 1

" TODO: trying out
" let g:completor_auto_trigger = 0
" inoremap <expr> <tab>   pumvisible() ? "<C-N>" : "<C-R>=completor#do('complete')<cr>"
" inoremap <expr> <S-Tab> pumvisible() ? "<C-p>" : "<S-Tab>"

""""""""""""""""""
" Vim EasyMotion "
""""""""""""""""""

let g:EasyMotion_do_mapping = 0 " Disable default mappings
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap a <plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

""""""""""""""""""""
" img paste plugin "
""""""""""""""""""""
let g:mdip_imgdir = 'images'
" <leader>i - i stands for image to insert image in normal mode
autocmd FileType markdown nnoremap <buffer><silent> <leader>i :call mdip#MarkdownClipboardImage()<cr>

"""""""""""""""
" delimitMate "
"""""""""""""""

" don't complete " in vim file
" didn't find a way so exclude the whole file
let g:delimitMate_excluded_ft = "vim"

""""""""""""""""
" vim-asterisk "
""""""""""""""""

" * stays at the current cursor position, instead of jumpping to next
map *  <plug>(asterisk-z*)
map #  <plug>(asterisk-z#)
" g* is * search without word boundary \< \> 
map g* <plug>(asterisk-gz*)
map g# <plug>(asterisk-gz#)

""""""""""
" is.vim "
""""""""""
" display search position like (2/10) for n/N commands.
" https://github.com/haya14busa/is.vim#integration-of-vim-anzu
map n <plug>(is-nohl)<plug>(anzu-n-with-echo)
map N <plug>(is-nohl)<plug>(anzu-N-with-echo)


"""""""""""""""
" Man Command "
"""""""""""""""

" Usage: 
"     `Man git`
"     `Man 7 git-tutorial`

runtime! ftplugin/man.vim

""""""""""""""""""""""""""""""
" get syntax highlight group "
""""""""""""""""""""""""""""""

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

command! -bang -nargs=? SynStack call SynStack()

""""""""""""""
" diff color "
""""""""""""""

" #C91B00 red from iterm ansi red
hi diffRemoved guifg=#C91B00
" #00C200 gren from iterm ansi green
hi diffAdded   guifg=#00C200

"""""""""""""""""""""
" Printing Hardcopy "
"""""""""""""""""""""

" use command :Print to use printer to print with colorscheme delek
command! -bang -nargs=? Print :colorscheme delek<bar>:hardcopy<bar>:colorscheme molokai

"""""""""
" Vista "
"""""""""

let g:vista_sidebar_width=80

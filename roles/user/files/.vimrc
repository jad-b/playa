set nocompatible              " be iMproved, required
set t_Co=256
set ff=unix

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.local/share/nvim/plugged')
" ~~~~~~~~~~~~~~ Vim Itself ~~~~~~~~~~~~~~
"
Plug 'chrisbra/unicode.vim'
" Colorscheme
" Plug 'altercation/vim-colors-solarized'
" Netrw improvements
Plug 'tpope/vim-vinegar'
" gpg inside vim
Plug 'jamessan/vim-gnupg'
" Commonly-used mappings
Plug 'tpope/vim-unimpaired'
" Allows toggling between relative and absolute line numbers with C-n
Plug 'jeffkreeftmeijer/vim-numbertoggle'
" Improve the status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" List open buffers
Plug 'bling/vim-bufferline'
" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Commands for working with surrounding text objects
Plug 'tpope/vim-surround'
" Quick (un)comment commands
Plug 'scrooloose/nerdcommenter'
" Smarter code folding
Plug 'tmhedberg/SimpylFold'
" Display tmux status bar
" Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-dispatch'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neomake/neomake'

" ~~~~~~~~~~~~~~ LSP ~~~~~~~~~~~~~~
" Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'

" ~~~~~~~~~~~~~~ Language support ~~~~~~~~~~~~~~
" https://github.com/ElmCast/elm-vim
Plug 'elmcast/elm-vim'
" Plug 'dense-analysis/ale'
Plug 'chase/vim-ansible-yaml'
" Python
Plug 'tell-k/vim-autopep8' " Python - automatic pep8 fixes
Plug 'vim-scripts/indentpython.vim' " Python PEP8 Indenting
" HCL
Plug 'hashivim/vim-hashicorp-tools' " HCL format
" Julia
" Plug 'JuliaEditorSupport/julia-vim'
Plug 'godlygeek/tabular' " Quickly align text
" Markdown
Plug 'plasticboy/vim-markdown' " Markdown
" TOML
Plug 'cespare/vim-toml'
" Plug 'derekwyatt/vim-scala' " Scala
" Rust
Plug 'rust-lang/rust.vim'
" Haskell
Plug 'neovimhaskell/haskell-vim'
" Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'GEverding/vim-hocon'
" Java
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-jdtls'

" ~~~~~~~~~~~~~~ Front-end Development ~~~~~~~~~~~~~~
" Close HTML/XML tags with ctrl-_
Plug 'vim-scripts/closetag.vim'
Plug 'hail2u/vim-css3-syntax'
" JavaScript Syntax
Plug 'pangloss/vim-javascript'
" TypeScript
" Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Quramy/tsuquyomi'

call plug#end()

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

" ---------------------------------------
"  Global NeoVim Configuration
" ---------------------------------------
" -- disable language provider support (lua and vimscript plugins only)
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_python_provider = 0
let g:loaded_python3_provider = 0

" ------------------------------------------------------------------------------
"  Plugin Configuration
" ------------------------------------------------------------------------------
"  vim-airline
" let g:airline_theme='solarized'
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"  ALE
" Jump between errors
" nmap <C-[> <Plug>(ale_previous_wrap)
" nmap <C-]> <Plug>(ale_next_wrap)
let g:ale_set_quickfix = 0
" Display error info in Airline status bar
let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1

" ansible
let g:ansible_options = {'ignore_blank_lines': 0}

" fzf
set rtp+=~/src/github.com/junegunn/fzf
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <M-b> :Buffers<CR>

" ripgrep
nnoremap <C-f> :Rg!

" UltiSnips setting
" mae vim recognizing snippets dir
set runtimepath+=~/.vim/my-snippets/
" use different snippets dir
let g:UltiSnipsSnippetsDir='~/.vim/my-snippets/'
let g:UltiSnipsSnippetDirectories=["my-snippets"]
" use vertical split to edit snippets
let g:UltiSnipsEditSplit='vertical'
" trigger snippet with Ctrl-l
" let g:UltiSnipsExpandTrigger='<C-l>'
" go to next snippet with Ctrl-j
let g:UltiSnipsJumpForwardTrigger='<M-j>'
" go to previous snippet with Ctrl-k
let g:UltiSnipsJumpBackwardTrigger='<M-k>'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

let g:netrw_liststyle=3
let g:netrw_winsize=30
" Preventing netrw from NEVER CLOSING
" https://github.com/tpope/vim-vinegar/issues/13#issuecomment-489440040
let g:netrw_fastbrowse=0

" Show docstrings for folded code
" let g:SimpylFold_docstring_preview=1

"
" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
"
" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')
"
" " Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)
"
" " Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
"
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
"
" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
"
" " Remap keys for applying codeAction to the current line.
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)
"
" " Introduce function text object
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)
"
" " Use <TAB> for selections ranges.
" " NOTE: Requires 'textDocument/selectionRange' support from the language server.
" " coc-tsserver, coc-python are the examples of servers that support it.
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
"
" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')
" nnoremap <leader> F :call CocAction('format')<CR>
"
" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"
" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
" " Mappings using CoCList:
" " Show all diagnostics.
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
"
" function! FloatScroll(forward) abort
"   let float = coc#util#get_float()
"   if !float | return '' | endif
"   let buf = nvim_win_get_buf(float)
"   let buf_height = nvim_buf_line_count(buf)
"   let win_height = nvim_win_get_height(float)
"   if buf_height < win_height | return '' | endif
"   let pos = nvim_win_get_cursor(float)
"   if a:forward
"     if pos[0] == 1
"       let pos[0] += 3 * win_height / 4
"     elseif pos[0] + win_height / 2 + 1 < buf_height
"       let pos[0] += win_height / 2 + 1
"     else
"       let pos[0] = buf_height
"     endif
"   else
"     if pos[0] == buf_height
"       let pos[0] -= 3 * win_height / 4
"     elseif pos[0] - win_height / 2 + 1  > 1
"       let pos[0] -= win_height / 2 + 1
"     else
"       let pos[0] = 1
"     endif
"   endif
"   call nvim_win_set_cursor(float, pos)
"   return ''
" endfunction
"
" inoremap <silent><expr> <down> coc#util#has_float() ? FloatScroll(1) : "\<down>"
" inoremap <silent><expr>  <up>  coc#util#has_float() ? FloatScroll(0) :  "\<up>"
"
" nnoremap <silent><expr> <down> coc#util#has_float() ? FloatScroll(1) : "\<down>"
" nnoremap <silent><expr>  <up>  coc#util#has_float() ? FloatScroll(0) :  "\<up>"

" Language-specific features
" --- Go ---
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" -------- linting --------
" ------------------------------------------------------------------------------
set omnifunc=syntaxcomplete#Complete
" Converts italicized,bold,etc. into the actual appearance.
set conceallevel=2

" Solarized
syntax enable
" set background=dark
set background=light
" colorscheme solarized

" Mouse
" set mouse=a

" Files and buffers
" Hide instead of closing buffers
set hidden

" Prevent Vim from backing up your files
set nobackup
set nowritebackup
set noswapfile

" Whitespacing
set backspace=indent,eol,start
" show matching parentheses
set showmatch

" Trying to avoid 'Press ENTER...' prompts
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" ----------------------------------------
" 2) moving around, searching and patterns
" ----------------------------------------
" Uppercase letters triggers case sensitivity
set smartcase
" Tab complete by LCS, then fullest match (:help wildmode)
" src: https://stackoverflow.com/a/11583850
set wildmode=list:longest,full
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
" inoremap <C-j> <ESC>:m .+1<CR>==gi
" inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv"

" ----------------------------------------
" 6) multiple windows
" ----------------------------------------
set wmh=0   " Minimum window is zero, so minimized files are less obtrusive

" Move between windows with Ctrl + j/k
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Alt-{hjkl} for navigating panes
" <C-\><C-n> is neovim's escape sequence
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

set splitright
set splitbelow

" Delete buffer without closing split
nmap ,d :b#<bar>bd#<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar (also 'za')
nnoremap <space> za

" -----------------------------------------------------------------------------
" 7) multiple tab pages
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" 14) tabs and indenting
" -----------------------------------------------------------------------------
set autoindent
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=4
set tabstop=4
set textwidth=79

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch

" History
set undolevels=1000
"set title

" Sounds
set visualbell
set noerrorbells
set showmode

" -----------------------------------------------------------------------------
" 18) reading and writing files
" -----------------------------------------------------------------------------
"  Work around of vim-vinegar causing netrw buffers to never die
autocmd FileType netrw setl bufhidden=wipe
"  Change current directory to currently open file
" autocmd BufEnter * silent! lcd %:p:h

" Remove trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

autocmd Filetype yaml,html,htmldjango,ruby,kivy,tmpl,css,hbs,scss,sh,markdown setlocal autoindent tabstop=2 shiftwidth=2 expandtab
autocmd BufRead,BufNewFile *.ts set filetype=typescript
autocmd BufRead,BufNewFile *.conf set filetype=conf autoindent tabstop=2 shiftwidth=2 expandtab
autocmd BufRead,BufNewFile *.scss set filetype=css
autocmd BufRead,BufNewFile *.deploy set filetype=yaml
autocmd BufRead,BufNewFile *.yml set filetype=yaml
autocmd BufRead,BufNewFile Vagrantfile* set filetype=ruby
autocmd BufRead,BufNewFile *.txt set filetype=markdown
autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile
autocmd BufNewFile,BufRead *.groovy  set filetype=groovy
autocmd BufNewFile,BufRead *.jl  set filetype=julia

" Automatically close the HTML tag once you type '</ SPACE'
" http://vim.wikia.com/wiki/Auto_closing_an_HTML_tag
:iabbrev </ </<C-X><C-O>

" Turn on spell-checking in text files
au BufRead,BufNewFile *.txt,*.rst setlocal sw=2 ts=2 expandtab tw=0
"
" Auto-recognize groovy scripts by the shebang
if did_filetype() " Already recognized filetype
	finish
endif
if getline(1) =~ '^#!.*[/\\]groovy\>' " #!/path/things/groovy
	setf groovy
endif

" --------------------------------------
" Plugins
" --------------------------------------
" Taken f/ beautiful_vim cheat sheet;
" Should make `%%` refer to current file's directory
" cnoremap %% <C-R>=expand(‘%:h’).’/’<CR>

" Relative line numbers
function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

"toggles whether or not the current window is automatically zoomed
function! ToggleMaxWins()
  if exists('g:windowMax')
    au! maxCurrWin
    wincmd =
    unlet g:windowMax
  else
    augroup maxCurrWin
        " au BufEnter * wincmd _ | wincmd |
        "
        " only max it vertically
        au! WinEnter * wincmd _
    augroup END
    do maxCurrWin WinEnter
    let g:windowMax=1
  endif
endfunction
nnoremap <Leader>max :call ToggleMaxWins()<CR>

:au FocusLost * :set number
:au FocusGained * :set relativenumber

autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" ------------------------------------------------------------------------------
"  Custom mappings
" ------------------------------------------------------------------------------
" Move to the previous buffer with "gp"
nnoremap gp :bp<CR>
nnoremap gn :bn<CR>
nnoremap gl :ls<CR>
nnoremap gb :ls<CR>:b

" replace currently selected text with default register with yanking it
vnoremap <leader>p "_dP

" Shortcut for clearing search highlighting
" Remapping <esc> has led to Vim opening in Replace mode. Shitty.
noremap <C-c> :noh<return>

" source $MYVIMRC
:nmap <Leader>s :source $MYVIMRC
" Open vimrc for editing
:nmap <Leader>v :e ~/.vimrc

" Use 'q' to close netrw window
" autocmd FileType netrw nnoremap q :bd

" Look for a tags file going up to root
set tags=./tags;/
:nmap <Leader>cr :!ctags -R . $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")<CR>

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

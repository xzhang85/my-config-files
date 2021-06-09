set nocompatible

" set vim-plug
call plug#begin()

" git wrapper
Plug 'tpope/vim-fugitive'
" vcs mark shower
Plug 'mhinz/vim-signify'
" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" auto close quotes, brackets
Plug 'Raimondi/delimitMate'
" comments shortcuts
Plug 'preservim/nerdcommenter'
" gruvbox colorscheme
Plug 'morhetz/gruvbox'
" show all functions in current file
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" completer
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clangd-completer' }
" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

filetype plugin indent on

set laststatus=2
set number
set ruler
set showcmd
set smartindent
set autoindent
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
set hlsearch

set foldmethod=syntax
set foldcolumn=4
match ErrorMsg '\s\+$'
set scrolloff=5

"color, font, etc.
syntax enable
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
set background=dark
colorscheme default
set cursorline
set colorcolumn=80,120
highlight CursorLine term=bold cterm=bold ctermbg=black
highlight SpellBad term=bold cterm=bold ctermbg=red "this is for warning words by youcompleteme

"set up dictionary
set dictionary+=/usr/share/dict/words

"remember and open at the pos of the file when last time closed
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

set completeopt=longest,menu
set tags=./.tags;,.tags

"set very magic for regular expression
nnoremap / /\v
vnoremap / y/<C-r>"<CR>
nnoremap ? ?\v
vnoremap ? y?<C-r>"<CR>
cnoremap s/ s/\v

let mapleader = " "

"setup quickfix window size
augroup qfwin
    autocmd!
    autocmd FileType qf call AdjustWindowHeight(3, 20)
augroup END
function! AdjustWindowHeight(minheight, maxheight)
    execute max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

"per language
set tabstop=8 expandtab shiftwidth=4 softtabstop=4
"autocmd FileType c setlocal tabstop=8 noexpandtab shiftwidth=8 softtabstop=8
"autocmd FileType cpp setlocal tabstop=8 noexpandtab shiftwidth=8 softtabstop=8
autocmd FileType python setlocal foldmethod=indent foldignore=

"terminal
:tnoremap <Esc> <C-\><C-n>

"plugin setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'
let g:airline_solarized_bg = 'dark'
let g:airline#extensions#tabline#enabled = 1

"UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

"YCM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>g :YcmCompleter GoTo<CR>
nnoremap <Leader>d :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>h :YcmCompleter GoToInclude<CR>
nnoremap <Leader>r :YcmCompleter GoToReferences<CR>
nnoremap <Leader>G :YcmCompleter GoToSymbol<Space>
nnoremap <Leader>2 :YcmCompleter RefactorRename<Space>

"vim-signify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>6 :SignifyDiff<CR>

"LeaderF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <Leader>p :LeaderfFunction!<CR>
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1

"fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>7 :BCommits<CR>
nnoremap <Leader>8 :Commits<CR>
"ripgrep string
nnoremap <Leader>s :call RipgrepFzf(expand("<cword>"), 0)<CR>
nnoremap <Leader>ss :call RipgrepFzf(expand("<cword>"), 0)<CR>
"ripgrep word
nnoremap <Leader>sw :call RipgrepFzf('-w '.expand("<cword>"), 0)<CR>
command! -nargs=* -bang RipgrepFZF call RipgrepFzf(<q-args>, <bang>0)
"ripgrep with given second half of command line (options, patterns, paths)
nnoremap <Leader>S :RipgrepFZF<Space>
nnoremap <Leader>F :Files<Space>
"FZF with current file's folder set as query, so user can search directly from
"the current file's folder first
nnoremap <Leader>f :call FilesFromDirname(0)<CR>

function! FilesFromDirname(fullscreen)
    let dir = ''
    let spec = {}
    let cwd = getcwd()
    let abspath = fnamemodify(expand('%'), ':p:h')
    let matched = matchstrpos(abspath, cwd)
    if abspath ==# cwd
        let dir = ''
    elseif matched[0] !=# ""
        let spec.options = ['-q', abspath[matched[2]+1:].'/']
    else
        let dir = abspath
    endif
    call fzf#vim#files(dir, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

function! RipgrepFzf(string, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let args = split(a:string)
    for i in args
        if i[0] !=# '-'
            let query = i
            break
        endif
    endfor
    let initial_command = printf(command_fmt, a:string)
    let reload_command = substitute(initial_command, query, '{q}', '')
    let spec = {'options': ['--phony', '--query', query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

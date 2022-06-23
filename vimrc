if has("syntax")
  syntax on
endif

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("autocmd")
  filetype plugin indent on
endif

" Detect OS more reliably than `has("...")`
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

set nocompatible
" Show (partial) command in status line.
set showcmd
" Do not highlight search matches
set nohlsearch
" Do case insensitive matching
set ignorecase
" Do smart case matching, i.e., do not ignore case if there's uppercases
set smartcase
" Incremental search
set incsearch
set autowrite             " Automatically save before commands like :next and :make
set hidden                " Hide buffers when they are abandoned
set mouse=a           " Enable mouse usage (all modes)
set number
set wildmenu              " show matches, so that <C-d> is not generally needed
set history=1000
" set swapfile to save unsaved changes
set swapfile
" swap file directories:
" 1. To avoid cluter working directory, save swap file under $HOME, prepend
" full path. This is acceptable since this vimrc is for my PC, not shared by
" multiple people, where working directory should have highest priority to be
" able to warn multiple people editing conflict.
" 2. Use working directory if swap/ under $HOME was not available.
" 3. Try /var/tmp, this is persistent, but unsecure, publicly readable.
" 4. Try /tmp, this is nonpersistent, and unsecure.
set directory=~/.vim/tmp/swap//,.,/var/tmp,/tmp
set undofile
set undolevels=1000
" see my preceding comment for 'swapfile'.
set undodir=~/.vim/tmp/undo//,.,/var/tmp,/tmp
set backup
" see my preceding comment for 'swapfile'.
set backupdir=~/.vim/tmp/backup//,.,/var/tmp,/tmp
set scrolloff=3           " detect reaching bottom
set keywordprg=:help
set grepprg=grep\ -nH\ $*
"when editing file, expand '\t' char to spaces. it won't touch '\t's that
"are saved already in file
set expandtab
"tabstop and shiftwidth should be the same, default value is 8, maybe too big
set tabstop=4
set shiftwidth=4
"softtabstop controls how many columns to use when hitting Tab and backspace (to delete spaces) in insert mode
set softtabstop=4
"disable beeping and window flashing
set noerrorbells visualbell t_vb=
"I don't know why gui vim need this separately
autocmd GUIEnter * set visualbell t_vb=
"ad-hoc folding configuration for python
autocmd Filetype python set foldnestmax=2
autocmd Filetype python set foldmethod=indent
"ad-hoc fix for using pydoc3
autocmd Filetype python set keywordprg=pydoc3
"weird key code commiting timeout issue when editting in terminal
set ttimeoutlen=0
"bash path
if g:os == "Darwin"
    set shell=/usr/local/bin/bash
endif
"bash doesn't load .bashrc if it's not invoked interactively. Hence the '-i' flag
"set shellcmdflag=-ic
set shellcmdflag=-c
" enable project-specific vimrc|exrc file
set exrc
" secure mode for project-specific `.vimrc|.exrc` file
set secure
" set behavior of backspace keys
set backspace=indent,eol,start
set termguicolors
" - add m flag to default format options (may vary between filetypes), allowing
"   formatting text containing multi-byte characters
" - add B flag to prevent space between multi-byte characters when joining
"   lines
set formatoptions+=mB
" not sure what it does, but seems able to switch to displayed buffer
set switchbuf=useopen,usetab

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" Better display for messages
set cmdheight=2

" Truncate the very long lines and mark `@@@`, instead of hiding its content
" altogether. This maximizes utility of screen area.
set display=lastline

" highlight cursor line and column for text alignment
set cursorline
set cursorcolumn

" ignore files
set wildignore+=*.so,*.swp,*.zip  " macos/linux
set wildignore+=*.exe             " windows
set wildignore+=*.class,*.jar     " java
set wildignore+=*.pyc             " python
set wildignore+=*/target/*        " compilation target

" Set up short messages
" Enable search result index
set shortmess-=S

execute pathogen#infect()

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

if g:os == "Linux"
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 14
    set guifontwide=Noto\ Sans\ Mono\ CJK\ SC\ 14
elseif g:os == "Darwin"
    " See macvim #1135
    set guifont=MenloForPowerline-Regular:h16
    set guifontwide=Hiragino\ Sans\ GB\ W3:h16
endif
set guioptions=egt
if has("gui_running")
    " set dimension only in gui mode (floating window)
    set lines=30 columns=100
endif

if g:os == "Darwin"
    set pythonthreedll=/usr/local/opt/python@3.9/Frameworks/Python.framework/Versions/Current/lib/libpython3.9.dylib
    set pythonthreehome=/usr/local/opt/python@3.9/Frameworks/Python.framework/Versions/Current
endif

" -------- colorschemes ---------
let g:onedark_terminal_italics = 1
colorscheme onedark
set background=dark

nmap Y y$
" easy file save, TODO I wish insert mode <C-s> can work well
" in MacVim with IME
nnoremap <C-s> :w<CR>
" easy copy and paste, TODO I wish Win/Super/Command key can be
" used here, so we can stop messing with already fully-occupied
" Ctrl mappings
vnoremap <C-c> "+y
" sorry <C-v> is block visual mode
vnoremap <C-p> "+p
inoremap <C-v> <C-r>+

"-------------cscope--------------
" use :cstag instead of :tag, thus including cscope databases as well
" when searching tags files
set cscopetag
" verbose message on success/failure of cscope invocations
set cscopeverbose
" only display the last N components of matched fullpath
" shouldn't there be something trailing the $PWD?
set cscopepathcomp=3
" convenient mappings, character meanings see :h if_cscop.txt
nmap <Leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
" improper usages
"nmap <Leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <Leader>ci :cs find i <C-R>=expand("<cfile>")<CR><CR>
"nmap <Leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>

"latex quotes (use q and Q) as surrounding chars in tex filetype
autocmd FileType tex let g:surround_39 = "`\r'"
autocmd FileType tex let g:surround_34 = "``\r''"

" remap <C-p> & <C-n> as <Up> and <Down>.
" To autocomplete command-line, use <Tab> and <S-Tab>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Search for selected text, forwards (*) or backwards (#).
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"-----------Gundo plugin------------
nnoremap <F9> :GundoToggle<CR>

"-------ultisnips plugin------------
"private snippets dir
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
"name of all snippet directories
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" -------- coc.nvim -----------
" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Remap for do codeAction of current line
nmap <leader>ac <Plug>(coc-codeaction)

" Remap for do action format
nnoremap <silent> <leader>F :call CocAction('format')<CR>

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""-------YouCompleteMe plugin----------
""<Tab> belongs to UltiSnips, YCM will use <C-n> for its work
"let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
""disable preview window
"set completeopt=menu
"let g:ycm_add_preview_to_completeopt = 0
"" completion for python3
"let g:ycm_python_binary_path = 'python3'
"let g:ycm_server_python_interpreter = 'python3'
""default compilation config file
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
""map two exec command combinations
"nmap <Leader>gD :YcmCompleter GoToDefinition<CR>
"nmap <Leader>gd :YcmCompleter GoToDeclaration<CR>
"let g:ycm_filetype_blacklist = {
"            \ 'markdown': 1,
"            \ 'tex': 1,
"            \ 'rst': 1,
"            \ 'html': 1,
"            \ 'text': 1,
"            \ 'gitcommit': 1,
"            \ 'scala': 1,
"            \ }
"let g:ycm_confirm_extra_conf = 0

"-------eclim plugin-----------
"necessary for YouCompleteMe and Eclim work well?
"let g:EclimCompletionMethod = 'omnifunc'

"-------delimitMate plugin-----------
"expand <CR> in various brackets, so that cursor is put on an empty line
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_autoclose = 1
"map <C-l> to jump out of pairs
imap <C-l> <Plug>delimitMateS-Tab
let g:delimitMate_jump_expansion = 0
let g:delimitMate_matchpairs = "(:),{:},[:]"
"set exception rule
autocmd FileType html,xml,markdown let b:delimitMate_matchpairs = "(:),{:},[:],<:>"
autocmd FileType m4 let b:delimitMate_quotes = "\""
"it should works in comment regions
let delimitMate_excluded_regions = "String"
" markdown MathJax enable match pair insertion before $
autocmd Filetype markdown let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|[£]\|[^[:space:][:punct:]]\)'
autocmd FileType markdown let b:delimitMate_quotes = "\" ' ` $"

"-------ctrlp plugin------------
"enable regular expression search by default
let g:ctrlp_regexp = 1
"restore <c-h> to its original behavior, i.e. the same as <BS>
"also diable <c-]> for 'PrtBS()'
let g:ctrlp_prompt_mappings = {
                        \ 'PrtBS()':              ['<c-h>', '<bs>'],
                        \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
                        \ }

" ignore vim backup files, python bytecodes
let g:ctrlp_custom_ignore = {
            \ 'file': '\v(.*\~|.*\.pyc)',
            \ }

"-------vim-javascript plugin---------
"enable html/css syntax highlighting in javascript file
let javascript_enable_domhtmlcss = 1

"-------vim-table-mode plugin---------
"use reStructuredText table style
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="

"------- haskell-vim plugin ------------
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

"------- python-syntax plugin ----------
let g:python_highlight_file_headers_as_comments = 1 " no special effect for shebang line
let g:python_highlight_string_templates = 0         " turn off hightlight `$var` template
let g:python_highlight_all = 1                      " turn on all highlighting effects

"------- vim-python-pep8-indent plugin -
" suppose to provide proper multiline string indentation
let g:python_pep8_indent_multiline_string = -2

"------- vim-markdown plugin ---------
let g:markdown_fenced_languages = ['c', 'cpp', 'html', 'python', 'bash=sh', 'json', 'tex']
let g:vim_markdown_folding_disabled = 1

"------- powerline plugin ------------
" specify that use python3 to load powerline when both versions are present
let g:powerline_pycmd = "py3"
let g:powerline_pyeval = "py3eval"
" always draw status line
set laststatus=2
" still show mode line because powerline output does not cover all vim modes.
set showmode
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

"-------space <--> tab ---------------
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

"------------ RstFold.vim ----------------
let g:rst_fold_enabled = 1

"------------ syntastic ------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ["flake8", "mypy", "pylint", "python"]

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function SubSpaceInUnittest()
    .s/\v(^ *def|^ *)@<! /_/g
endfunction
" source local vimrc
source $HOME/.vimrc.local

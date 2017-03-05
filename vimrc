runtime! debian.vim

if has("syntax")
  syntax on
endif

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("autocmd")
  filetype plugin indent on
endif

set nocompatible
set nohlsearch
set showcmd               " Show (partial) command in status line.
set ignorecase            " Do case insensitive matching
set smartcase             " Do smart case matching
set incsearch             " Incremental search
set autowrite             " Automatically save before commands like :next and :make
set hidden                " Hide buffers when they are abandoned
if has("gui_running")
    set mouse=a           " Enable mouse usage (all modes)
endif
set number
set wildmenu              " show matches, so that <C-d> is not generally needed
set history=1000
set undofile
set undolevels=1000
set scrolloff=3           " detect reaching bottom
set keywordprg=:help
set grepprg=grep\ -nH\ $*
set backup
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
"bash doesn't load .bashrc if it's not invoked interactively. Hence the '-i' flag
set shellcmdflag=-ic
" enable project-specific vimrc|exrc file
set exrc
" secure mode for project-specific `.vimrc|.exrc` file
set secure

execute pathogen#infect()

set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
  set guioptions=egt
  set lines=30 columns=100
  colorscheme solarized
  "some script neutralized solarized's bold highlighting functionality.
  autocmd GUIEnter * colo solarized
  "remap <F1> to toggle background. I don't use <F1> to open help doc.
  call togglebg#map("<F1>")
else
  colorscheme pablo
endif

set background=dark

map Y y$

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

"change to current directory
command Cdc cd %:p:h

"-----------Gundo plugin------------
nnoremap <F9> :GundoToggle<CR>

"---------airline plugin------------
"always have status line for airline plugin
set laststatus=2
"automatically populate powerline symbols
let g:airline_powerline_fonts = 1

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

"-------YouCompleteMe plugin----------
"<Tab> belongs to UltiSnips, YCM will use <C-n> for its work
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
"disable preview window
set completeopt=menu
let g:ycm_add_preview_to_completeopt = 0
" completion for python3
let g:ycm_python_binary_path = '/usr/bin/python3'
"default compilation config file
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"map two exec command combinations
nmap <Leader>gD :YcmCompleter GoToDefinition<CR>
nmap <Leader>gd :YcmCompleter GoToDeclaration<CR>
let g:ycm_filetype_blacklist = {
            \ 'markdown': 1,
            \ 'tex': 1,
            \ 'rst': 1,
            \ 'html': 1,
            \ 'text': 1,
            \ 'gitcommit': 1,
            \ }
let g:ycm_confirm_extra_conf = 0

"-------eclim plugin-----------
"necessary for YouCompleteMe and Eclim work well?
"let g:EclimCompletionMethod = 'omnifunc'

"-------delimitMate plugin-----------
"expand <CR> in various brackets, so that cursor is put on an empty line
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
"disable autoclose in case of intrusion
let g:delimitMate_autoclose = 1
"map <C-j> to jump out of pairs
imap <C-l> <Plug>delimitMateS-Tab
let g:delimitMate_jump_expansion = 0
let g:delimitMate_matchpairs = "(:),{:},[:]"
"set exception rule
autocmd FileType html,xml let b:delimitMate_matchpairs = "(:),{:},[:],<:>"
autocmd FileType m4 let b:delimitMate_quotes = "\""
"it should works in comment regions
let delimitMate_excluded_regions = "String"

"-------ctrlp plugin------------
"enable regular expression search by default
let g:ctrlp_regexp = 1
"restore <c-h> to its original behavior, i.e. the same as <BS>
"also diable <c-]> for 'PrtBS()'
let g:ctrlp_prompt_mappings = {
                        \ 'PrtBS()':              ['<c-h>', '<bs>'],
                        \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
                        \ }

"-------vim-javascript plugin---------
"enable html/css syntax highlighting in javascript file
let javascript_enable_domhtmlcss = 1
"ignore bullshit bin/**/bin/* directory
let g:ctrlp_custom_ignore = {
            \ 'dir': '.*bin.*bin.*',
            \ 'file': '.*\~',
            \ }

"-------vim-table-mode plugin---------
"use reStructuredText table style
let g:table_mode_corner_corner="+"
let g:table_mode_header_fillchar="="

"-------haskell-vim ------------------
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

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

"------------for now, let's disable imap plugin
"let g:enable_imap = 0

"-------------------------latex-related-------------------------------------------
"text objects for latex
"function! NextEnd()
"    let curline = line(".") + 1
"    let begins = 1
"    while begins > 0
"        if getline(curline) =~ '.*\\begin.*$'
"            let begins += 1
"        endif
"        if getline(curline) =~ '.*\\end.*$'
"            let begins -= 1
"        endif
"
"        let curline += 1
"    endwhile
"
"    return curline - 1
"endfunction
"
"function! PrevBegin()
"    let curline = line(".")
"    let ends = 1
"    while ends > 0
"        if getline(curline) =~ '.*\\begin.*$'
"            let ends -= 1
"        endif
"        if getline(curline) =~ '.*\\end.*$'
"            let ends += 1
"        endif
"
"        let curline -= 1
"    endwhile
"
"    return curline + 1
"endfunction
"
"function! SelectInEnvironment(surround)
"    let start = PrevBegin()
"    let end = NextEnd()
"
"    call cursor(start, 0)
"    if !a:surround
"        normal! j
"    end
"    normal! V
"    call cursor(end, 0)
"    if !a:surround
"        normal! k
"    end
"endfunction
"
"" Operate on environments (that have begin and ends on separate lines)
"vnoremap ie <ESC>:call SelectInEnvironment(0)<CR>
"vnoremap ae <ESC>:call SelectInEnvironment(1)<CR>
"omap ie :normal Vie<CR>
"omap ae :normal Vae<CR>
"
"" Operate on math
"function! SelectInMath(surround)
"	let save_cursor = getpos(".")
"	if getline(".")[col(".")-1] == '$' && getline(".")[col(".")-2] != ' '
"		call cursor(save_cursor[1],save_cursor[2]-1)
"	elseif getline(".")[col(".")-1] == '$' && getline(".")[col(".")-2] == ' '
"		call cursor(save_cursor[1],save_cursor[2]+1)
"	endif
"	let [nextLine, nextCol] = searchpos('\$', 'ncW')
"	let [prevLine, prevCol] = searchpos('\$', 'ncWb')
"	let delimLen = 1
"
"    if a:surround
"        call cursor(prevLine, prevCol)
"    else
"        call cursor(prevLine, prevCol + delimLen)
"    end
"
"    normal! v
"    if a:surround
"        call cursor(nextLine, nextCol)
"    else
"        call cursor(nextLine, nextCol-delimLen)
"    end
"endfunction
"
"vnoremap i$ <ESC>:call SelectInMath(0)<CR>
"vnoremap a$ <ESC>:call SelectInMath(1)<CR>
"omap i$ :normal vi$<CR>
"omap a$ :normal va$<CR>
"
"" Operate on LaTeX quotes
"vmap iq <ESC>?``<CR>llv/''<CR>h
"omap iq :normal viq<CR>
"vmap aq <ESC>?``<CR>v/''<CR>l
"omap aq :normal vaq<CR>

"Vim-LaTeX settings
let g:tex_flavor='latex'

"set compile engine and parameters delivered to engine
let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
let g:Tex_CompileRule_pdf = 'xelatex --interaction=nonstopmode -synctex=1 -src-specials $*'

"switch to pdflatex
function SetpdfLaTeX()
	let g:Tex_CompileRule_pdf = 'pdflatex --interaction=nonstopmode -synctex=1 -src-specials $*'
endfunction
noremap <Leader>lp :<C-U>call SetpdfLaTeX()<CR>

"switch to xelatex
function SetXeLaTeX()
	let g:Tex_CompileRule_pdf = 'xelatex --interaction=nonstopmode -synctex=1 -src-specials $*'
endfunction
noremap <Leader>lx :<C-U>call SetXeLaTeX()<CR>

"switch to arara control
function SetAraraControl()
	let g:Tex_CompileRule_pdf = 'arara -l -v $*'
endfunction
noremap <Leader>la :<C-U>call SetAraraControl()<CR>

"filetype-specific and buffer-local mapping <F3> for compilation
autocmd Filetype tex map <buffer> <F3> :<C-U>w<CR><Leader>ll
autocmd Filetype c map <buffer> <F3> :<C-U>w<CR>:!agcc -o %< %<CR>
autocmd Filetype java map <buffer> <F3> :<C-U>w<CR>:!javac %<CR>

"set PDF viewer
let g:Tex_ViewRule_pdf = 'okular'

"set default output format as PDF
let g:Tex_DefaultTargetFormat = 'pdf'

"(re)new vim-latex command shortcuts
let g:Tex_Com_tfrac = "\\tfrac{<++>}{<++>}<++>"
let g:Tex_Com_dfrac = "\\dfrac{<++>}{<++>}<++>"
let g:Tex_Com_D = "\\D{<++>}{<++>}<++>"
let g:Tex_Com_newcommand = "\\newcommand{<++>}[<++>]{<++>}<++>"
let g:Tex_Com_renewcommand = "\\renewcommand{<++>}[<++>]{<++>}<++>"
let g:Tex_Com_tbf = "\\textbf{<++>}<++>"
let g:Tex_Com_ttt = "\\texttt{<++>}<++>"
let g:Tex_Com_tsf = "\\textsf{<++>}<++>"
let g:Tex_Com_tit = "\\textit{<++>}<++>"
let g:Tex_Com_tex = "{\\TeX}<++>"
let g:Tex_Com_pdftex = "{pdf\\TeX}<++>"
let g:Tex_Com_latex = "{\\LaTeX}<++>"
let g:Tex_Com_latexe = "{\\LaTeXe}<++>"
let g:Tex_Com_pdflatex = "{pdf\\LaTeX}<++>"
let g:Tex_Com_xetex = "{\\XeTeX}<++>"
let g:Tex_Com_context = "{\\ConTeXt}<++>"
let g:Tex_Com_xelatex = "{\\XeLaTeX}<++>"
let g:Tex_Com_luatex = "{\\Lua\TeX}<++>"
let g:Tex_Com_amslatex = "{\\AmS-\\LaTeX}<++>"
let g:Tex_Com_metapost = "\\{MP}<++>"
let g:Tex_Com_metafont = "\\{MF}<++>"
let g:Tex_Com_mbb = "\\mathbb{<++>}<++>"
let g:Tex_Com_SI = "\\SI{<++>}{<++>}<++>"
let g:Tex_Com_verb = '\verb|<++>|<++>'
let g:Tex_Com_pverb = '\PVerb{<++>}<++>'

"show all warnings
let g:Tex_IgnoreLevel = 0

"set folded sections
let Tex_FoldedSections = 'part,chapter,section,%%fakesection,subsection,subsubsection'

"set folded misc
let Tex_FoldedMisc = 'preamble,<<<'

"set foled environments
let Tex_FoldedEnvironments = 'appendices,comment,lstlisting,verbatim,definition,theorem,equation,align,gather,figure,table,thebibliography,keywords,abstract,titlepage,tikzpicture'

"turn off stupid smart triple dots
let g:Tex_SmartKeyDot = 0

"wanna turn off Visual mode stupid mappings, the default <Leader> ',' overrides Vim's default ',' command in Visual mode, but it looks like impossible to do it without side effect, so remap it.
let Tex_Leader2 = '`'

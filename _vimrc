"===============================================================================
" デフォルト設定
"===============================================================================
" タブの設定
set tabstop=4
set shiftwidth=4
set noexpandtab
set softtabstop=4

set number
set nowrap

"===============================================================================
" NeoBundle
"===============================================================================
set nocompatible

if has('vim_starting')
	if has("win32") || has("win64")
		set runtimepath+=~/vimfiles/bundle/neobundle.vim/
		call neobundle#rc(expand('~/vimfiles/bundle/'))
	else
		set runtimepath+=~/.vim/bundle/neobundle.vim/
		call neobundle#rc(expand('~/.vim/bundle/'))
	endif
endif

" NeoBundle自身を管理する
NeoBundleFetch 'Shougo/neobundle.vim'

" NeoBundleのインストールに必要
" インストール時に自動でビルドする
NeoBundle 'Shougo/vimproc', {
	\ 'build': {
		\ 'windows': 'make -f make_mingw32.mak',
		\ 'cygwin': 'make -f make_cygwin.mak',
		\ 'mac': 'make -f make_mac.mak',
		\ 'unix': 'make -f make_unix.mak'
	\ },
\ }

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'Shougo/neocomplete'

" ヘッダーファイルとソースファイルを切り替えるプラグイン
NeoBundle 'kana/vim-altr'

" コメントアウトプラグイン
NeoBundle "tyru/caw.vim"

" Markdown用シンタックスハイライト
NeoBundle 'rcmdnk/vim-markdown'

" C++用シンタックスハイライト
NeoBundleLazy 'vim-jp/cpp-vim', {
	\ 'autoload' : {'filetypes' : 'cpp'}
	\ }

" 必須
filetype plugin indent on

" インストールの確認
NeoBundleCheck

"------------------------------------------------------------------------------
" neocompleteの設定
"------------------------------------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_syntax_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
	\ 'default' : '',
	\ 'vimshell' : $HOME.'/.vimshell_hist',
	\ 'scheme' : $HOME.'/.gosh_completions'
	\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left> neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up> neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down> neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

"===============================================================================
" cawの設定
"===============================================================================
nmap \c <Plug>(caw:I:toggle)
vmap \c <Plug>(caw:I:toggle)

nmap \C <Plug>(caw:I:uncomment)
vmap \C <Plug>(caw:I:uncomment)

"===============================================================================
" vim-markdownの設定
"===============================================================================
" 折りたたみを無効にする
let g:vim_markdown_folding_disabled=1

"===============================================================================
" Ruby
"===============================================================================
function! s:rb()
	setlocal expandtab
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
endfunction

augroup vimrc-rb
	autocmd!
	autocmd FileType ruby call s:rb()
augroup END

"===============================================================================
" C++ 
"===============================================================================
function! s:cpp()
	setlocal noexpandtab
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	
	" アクセス修飾子のインデント幅を0にする
	set cinoptions=g0

	"括弧<>のペアを認識させる
	setlocal matchpairs+=<:>

	if $BOOST_ROOT != ''
		setlocal path+=$GCC_CPP_INC_ROOT
		setlocal path+=$BOOST_INC_ROOT
	endif
endfunction

augroup vimrc-cpp
	autocmd!
	autocmd FileType cpp call s:cpp()
augroup END


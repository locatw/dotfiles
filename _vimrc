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

" シンタックス有効
syntax enable

" インサートモード時にバックスペースを有効にする
set backspace=indent,eol,start

" ステータス行を表示
set laststatus=2
set statusline=%<%f\ %m%r%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l/%L,%v

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

" Clangを使ったC++のコード補完プラグイン
NeoBundle 'osyo-manga/vim-marching'

" スニペット
" neocompleteが必要
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'

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
NeoBundle 'Mizuchi/STL-syntax'

" ディレクトリ固有の設定をするためのプラグイン
NeoBundle 'thinca/vim-localrc'

" ディレクトリツリー表示プラグイン
NeoBundle 'scrooloose/nerdtree'

" カラースキーム
NeoBundle 'ujihisa/unite-colorscheme'

NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'jeffreyiacono/vim-colors-wombat'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'jonathanfilip/vim-lucius'
NeoBundle 'vim-scripts/Zenburn'
NeoBundle 'mrkn/mrkn256.vim'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'therubymug/vim-pyte'
NeoBundle 'tomasr/molokai'
NeoBundle 'w0ng/vim-hybrid'

" vimの履歴をUniteで表示するプラグライン 
NeoBundle 'thinca/vim-unite-history'

" 必須
filetype plugin indent on

" インストールの確認
NeoBundleCheck

"===============================================================================
" uniteの設定
"===============================================================================
" '<Space>u'をUniteプラグイン専用とする
" 参照：http://deris.hatenablog.jp/entry/2013/05/02/192415
nnoremap [unite] <Nop>
nmap  <Space>u [unite]

" キーマップ
nnoremap <silent> [unite]f :<C-u>Unite file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]c :<C-u>Unite history/command<CR>

" Unite history/yankを有効化
let g:unite_source_history_yank_enable = 1

"===============================================================================
" neocompleteの設定
"===============================================================================
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_syntax_length = 1
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
" vim-marchingの設定
"===============================================================================
" clang コマンドの設定
let g:marching_clang_command = "clang"

" オプションを追加する
" filetype=cpp に対して設定する場合
let g:marching#clang_command#options = {
	\   "cpp" : "-std=gnu++1y"
	\}

" インクルードディレクトリのパスを設定
let g:marching_include_paths = [
	\	$GCC_CPP_INC_ROOT,
	\	$BOOST_INC_ROOT
	\]

" neocomplete.vim と併用して使用する場合
let g:marching_enable_neocomplete = 1

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

" 処理のタイミングを制御する
" 短いほうがより早く補完ウィンドウが表示される
" ただし、marching.vim 以外の処理にも影響するので注意する
set updatetime=1

" オムニ補完時に補完ワードを挿入したくない場合
imap <buffer> <C-x><C-o> <Plug>(marching_start_omni_complete)

" キャッシュを削除してからオムニ補完を行う
imap <buffer> <C-x><C-x><C-o> <Plug>(marching_force_start_omni_complete)

" 非同期ではなくて、同期処理でコード補完を行う場合
" この設定の場合は vimproc.vim に依存しない
" let g:marching_backend = "sync_clang_command"

"===============================================================================
" neosnippetの設定
"===============================================================================
" Ctrl-kで展開
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_or_jump)

" タブでも展開
imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: pumvisible() ? "\<C-n>" : "\<Tab>"
smap <expr><Tab> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: "\<Tab>"

" 現在のfiletype用のスニペットを編集するためのキーマップ
nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>
let g:neosnippet#snippets_directory = "~/.neosnippet"

"===============================================================================
" vim-altrの設定
"===============================================================================
" F2で切り替える
nmap <F2> <Plug>(altr-forward)

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
" NERDTreeの設定
"===============================================================================
" 隠しファイルを表示する
let NERDTreeShowHidden = 1

" ウィンドウサイズ 
let NERDTreeWinSize = 40

" 行番号を表示する
let NERDTreeShowLineNumbers = 1

" ツリーを表示するキーマップ
nnoremap <silent><C-t> :NERDTreeToggle<CR>

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

	" C++関連のインクルードパスの設定
	" インクルードパス補間機能に必要
	if $GCC_CPP_INC_ROOT != ''
		setlocal path+=$GCC_CPP_INC_ROOT
	else
		echohl WarningMsg | echo "$GCC_CPP_INC_ROOTが設定されていません。" | echohl None
	endif
	if $BOOST_INC_ROOT != ''
		setlocal path+=$BOOST_INC_ROOT
	else
		echohl WarningMsg | echo "$BOOST_INC_ROOTが設定されていません。" | echohl None
	endif
endfunction

augroup vimrc-cpp
	autocmd!
	autocmd FileType cpp call s:cpp()
	autocmd BufReadPost $GCC_CPP_INC_ROOT/* if empty(&filetype) | set filetype=cpp | endif
augroup END

"===============================================================================
" カラー設定
"===============================================================================
" 行番号だけグレーにする
" colorschemeの設定の前に行う
autocmd colorscheme * highlight LineNr ctermfg=7

" ポップアップメニューの背景色を黒に、文字色を白にする
autocmd colorscheme * highlight Pmenu ctermfg=white ctermbg=black
" ポップアップメニューの選択しているアイテムは色を反転する
autocmd colorscheme * highlight PmenuSel ctermfg=black ctermbg=white

set background=dark
colorscheme hybrid

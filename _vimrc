"===============================================================================
" デフォルト設定
"===============================================================================
" タブの設定
set tabstop=4
set shiftwidth=4
set noexpandtab
set softtabstop=4

"===============================================================================
" NeoBundle
"===============================================================================
set nocompatible

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

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

" vim-ruby
NeoBundle 'vim-ruby/vim-ruby'

" 必須
filetype plugin indent on

" インストールの確認
NeoBundleCheck

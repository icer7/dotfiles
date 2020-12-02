" init autocmd
autocmd!

" set script encoding
scriptencoding utf-8

" stop loading config if it's on tiny or small
if !1 | finish | endif

"-------------------------------------------------------------------------------
" Dein
"-------------------------------------------------------------------------------
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')

" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

"""""""""""""""""""""
" 基本設定
"""""""""""""""""""""
" 行番号表示
set number

" ファイルを開いたときにファイルの種類を検出する機能
filetype plugin indent on

" シンタックスハイライト
syntax enable

" 文字コード変換
set encoding=utf-8

" クリップボード機能
set clipboard=unnamedplus

" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title

" 改行時に前の行のインデントを継続する
set autoindent

" バックアップファイル出力無効
set nobackup

" 検索結果をハイライト表示する
set hlsearch

" 入力中のコマンドを表示する
set showcmd

" メッセージ表示欄を1行確保
set cmdheight=1

" ステータス行を常に表示
set laststatus=2

" 上下10行の視界を確保
set scrolloff=10

" タブ入力を複数の空白入力に置き換える
set expandtab

" incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" スクロールが遅くなる問題解決
set lazyredraw

" 大文字と小文字を区別しない
set ignorecase

" 改行時に、前の行と同じ数だけ自動でインデントを挿入される
set ai "Auto indent

" 改行時に、ブロックに応じて自動でインデント数を調整して挿入される
set si "Smart indent

" 行の折り返し表示をやめる
set nowrap

" Backspaceキーの影響範囲に制限を設けない
set backspace=indent,eol,start

" ペーストモードでいる事は無いので、挿入モードからノーマルモードに戻る時に自動で解除
autocmd InsertLeave * set nopaste

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" 改行時にコメント継続するのをやめる
set formatoptions+=r

" 検索対象ファイル
set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

"-------------------------------------------------------------------------------
" Cursor line
"-------------------------------------------------------------------------------

set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr       cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

"-------------------------------------------------------------------------------
" DevIcons
"-------------------------------------------------------------------------------

set guifont=Sauce\ Code\ Pro\ Light\ Nerd\ Font\ Complete\ Windows\ Compatible:h11
let g:webdevicons_enable_vimfiler = 1

"-------------------------------------------------------------------------------
" Other plugins
"-------------------------------------------------------------------------------

" vim-go
let g:go_disable_autoinstall = 1

" vim-json
let g:vim_json_syntax_conceal = 0

" Status line
if !exists('*fugitive#statusline')
  set statusline=%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[L%l/%L,C%03v]
  set statusline+=%=
  set statusline+=%{fugitive#statusline()}
endif

" JSX
let g:jsx_ext_required = 0

" Tern
" Disable auto preview window
set completeopt-=preview

" localvimrc
let g:localvimrc_ask = 0

"-------------------------------------------------------------------------------
" imports
"-------------------------------------------------------------------------------

if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    source ~/.vimrc.osx
  endif
endif

source ~/.vimrc.maps
source ~/.vimrc.lightline

set exrc

# 検索ハイライトを解除するにはescキーを2押す
nnoremap <ESC><ESC> :nohl<CR>

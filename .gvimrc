" vi compatibility
if !&compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" Setting of dein.vim.
let s:vim_dir = empty($XDG_CACHE_HOME) ? expand('~/.vim') : $XDG_CACHE_HOME
let s:dein_dir = s:vim_dir . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

if dein#load_state(expand('~/.vim/dein'))
    call dein#begin(expand('~/.vim/dein'))

    " TOML file containing the plugin list.
    let g:dein_dir = expand('~/.vim/dein')
    let s:toml = g:dein_dir . '/dein.toml'
    let s:lazy_toml = g:dein_dir . '/dein_lazy.toml'

    " Write plugin in TOML file.
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

" Confirm not installed.
if dein#check_install()
    call dein#install()
endif

filetype plugin indent on

" IME Ctrl
" 「日本語入力固定モード」の動作モード
let IM_CtrlMode = 1
" 「日本語入力固定モード」切替キー
inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>

" IBus 1.5以降
function! IMCtrl(cmd)
  let cmd = a:cmd
  if cmd == 'On'
    let res = system('ibus engine "mozc-jp"')
  elseif cmd == 'Off'
    let res = system('ibus engine "xkb:us::eng"')
  endif
  return ''
endfunction

" <ESC>押下後のIM切替開始までの反応が遅い場合はttimeoutlenを
" 短く設定してみてください。
" IMCtrl()のsystem()コマンド実行時に&を付けて非同期で実行する
" という方法でも体感速度が上がる場合があります。
set timeout timeoutlen=3000 ttimeoutlen=100

" Basic settings.
syntax on
syntax enable
set number
set cursorline
set tabstop=2
set list
set listchars=tab:>-
set guifont=Ricty\ for\ Powerline\ Regular\ 11
set guifontwide=Ricty\ for\ Powerline\ Regular\ 11
set nobackup
set directory=~/.vim/meta
set backupdir=~/.vim/meta
set background=dark
set t_Co=256
set helplang=ja
colorscheme molokai

" Setting of vim meta directory.
let s:vim_meta = s:vim_dir . '/meta'
if !isdirectory(s:vim_meta)
  call system('mkdir ~/.vim/meta')
endif

" GUI Menu Control.
":set guioptions-=m  "remove menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

" 80column
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" gVim でウィンドウの位置とサイズを記憶する
let g:save_window_file = expand('~/.vim/meta/vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set columns=' . &columns,
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

imap <silent> <C-D><C-D> <C-R>=strftime("%Y/%m/%d (%a) %H:%M")<CR>

" Search grep word at cursor position.
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

autocmd VimEnter * execute 'NERDTree'

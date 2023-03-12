".vimrc
"Author: Reese Horton
"Sources: largely copied from online tutorials and files on github



"Setup for vim plugin manager needs to be handled first. Rest of setup is below.
"---------------------------------PLUGIN SETUP------------------------------------------
"---------------------------------Vim Plugin Options------------------------------------
"Using vim plugin manager vim-plug
"Downloads/updates plugins and stores them in the default directory ~/.vim/plugged
filetype plugin on
set encoding=utf-8
set nocompatible

"Automaticall install vim-Plug if it hasn't been already
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

"Specify plugins to use
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'powerline/powerline'
Plug 'powerline/fonts'
"Airline provides a 'status bar to vim', requires powerline plugin and fonts loaded above
"NOTE: the terminal app on your current computer must have a font compatible with the 'powerline' package
"selected as default for the airline bar to display correctly
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jacoborus/tender.vim'
"Allows access to git commands within a vim instance. Shows repository status within vim 
"when coupled with the airline plugin
Plug 'tpope/vim-fugitive'
"Introduces many useful features for editing .tex files in vim, e.g. command completion,
"syntax highlighting, etc.
Plug 'lervag/vimtex' 
Plug 'xuhdev/vim-latex-live-preview'
"Adds syntax highlighting for many different languages, most importantly
"gnuplot
Plug 'sheerun/vim-polyglot'

"Plug 'Valloric/YouCompleteMe', { 'commit' : 'd98f896' }

"Finalise and install plugins
call plug#end()


"Environment variables for YouCompleteMe installation
"let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
"let g:ycm_confirm_extra_conf=0
"let g:ycm_python_binary_path='/usr/bin/python3'

let g:airline_powerline_fonts=1
"Need to call some airline functions to manually set a character in the powerline
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif
let g:airline_symbols.colnr="CN"

"Set theme for airline bar at the bottom of the screen
let g:airline_theme='tender'
"Vim remappings to make plugins easier to call
"Easily activate NERDTree
map <Leader>n :NERDTreeToggle
"Toggle displaying line numbers
nmap z :set number                                                                                                                                             
nmap x :set nonumber
nmap m :set mouse=

let g:tex_flavor='latex'
let g:Tex_TreatMacViewerAsUNIX = 1
let g:Tex_ExecuteUNIXViewerInForeground = 1
let g:Tex_ViewRule_ps = 'open -a Skim'
let g:Tex_ViewRule_pdf = 'open -a /Applications/Skim.app'
let g:Tex_ViewRule_dvi = 'open -a /Applications/texniscope.app'




"-----------------------------------------------------------------------------------------
"----------------------------------PERSONAL SETTINGS--------------------------------------
"Allows vim to detect file type and add automatic indentation
filetype indent on
"Activates syntax highlighting for various file types, syntax files stored in .vim/syntax/
syntax on    
"Fixes issue with syntax highlighting failing for large files following jump to line number
set redrawtime=10000

"-------------------Basic Options---------------------------
set si "activate smart indent and autoindent
set ai
set shiftwidth=3 "Number of spaces used for autoindenting (i.e via fortran_do_enddo)
set showmode
set ruler "Show row and column of cursor
"Allows backspacing over automatic indentation 
"and back past the line where insert mode was activated
set backspace=indent,eol,start
set mouse=a "Turn mouse on
set nowrap  "Prevent line wrapping
set clipboard=unnamed
set number
highlight LineNr ctermfg=blue ctermbg=none
set cursorline "Highlight the line the cursor is on
"Opens file at the row and column cursor was on upon last exit 
autocmd BufReadPost * normal `"
"Note: to change horizontally split windows to vertical: :vertical ball

"-------------------Moving and searching---------------------
set ignorecase  "Ignore case when searching
set incsearch   "Display search matches as you type
set hlsearch  "Highlight saerch results
set showmatch   "Show matching parens 
"Quicker way to exit edit mode than using <esc>
"Note: any characters (inlcluding whitespace AND comments) after <esc> will be interpreted as part of the alias for jk, leave only one space
inoremap jk <esc>
vnoremap jk <esc>
"Prevent user from using <exc> to exit edit mode. See above comment, keep empty after <nop>
inoremap <esc> <nop>
vnoremap <esc> <nop>
"Prevent user from using arrow keys to navigate, force hjkl movement
"All use cases that would require arrow keys have corresponding vim shortcuts, use them.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>


function Plot()
  :w  
  :!gnuplot % 
 endfunction 
 map <Leader>p :<C-U>call Plot()<CR><CR>



"-------------------Fortran specific options----------------
let fortran_have_tabs=1  "prevents tabs from being highlighted
let fortran_do_enddo=1  "Indents all lines between do and enddo in fortran files
let fortran_free_source=1
let fortran_more_precise=1





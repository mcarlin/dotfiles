"==============================
" Shared Settings
"==============================

let mapleader=","

set so=2
set nu

" Make leader+tab switch between most recent buffer
map <leader><tab> :b#<cr>

nnoremap j gj
vnoremap j gj
onoremap j gj
nnoremap k gk
vnoremap k gk
onoremap k gk
nnoremap 0 g0
nnoremap $ g$

"==============================
" Environment Specific Settings
"==============================

if has('ide') """ IDEA

  """ Plugin Settings
  set surround
  set multiple-cursors
  set argtextobj
  set sneak
  set quickscope
  set textobj-entire
  set ReplaceWithRegister
  set highlightedyank

  """ Plugin Settings
  let g:argtextobj_pairs="[:],(:),<:>"

  """ Idea specific settings
  set ideajoin
  set ideastatusicon=gray
  set idearefactormode=keep

  """ Idea specific mappings
  map <leader><leader>d <Action>(Debug)
  map <leader><leader>r <Action>(Run)
  map <leader><leader>s <Action>(Stop)

  """ Refactoring
  map <leader>r i<Action>(RenameElement)
  map <leader>p <Action>(IntroduceParameter)
  map <leader>fp <Action>(IntroduceFunctionalParameter)
  map <leader>c <Action>(IntroduceConstant)
  map <leader>v <Action>(IntroduceVariable)
  map <leader>d <Action>(QuickJavaDoc)

  map <leader>R <Action>(Refactorings.QuickListPopupAction)

  map <leader>a <Action>(ShowIntentionActions)

  map <S-Space> <Action>(GotoNextError)

  """ Navigate / Search
  map <leader>ff <Action>(SearchEverywhere)
  map <leader>fg <Action>(FindInPath)
  map <leader>gd <Action>(GotoDeclaration)
  map <leader>gD <Action>(GotoTypeDeclaration)
  map <leader>gi <Action>(GotoImplementation)
  map <leader>gr <Action>(FindUsages)
  map <leader>fs <Action>(FileStructurePopup)
  map <leader><enter> <Action>(Switcher)

  map <leader>b <Action>(ToggleLineBreakpoint)
  map <leader>m <Action>(ToggleBookmark)
  map <leader>xx <Action>(ActivateProblemsViewToolWindow)

  map <leader>tt <Action>(ActivateProjectToolWindow)

  nmap s <Plug>(easymotion-overwin-w)

elseif exists('g:vscode') """ VSCode

  """ Idea specific mappings
"  map <leader><leader>d <Action>(Debug)
"  map <leader><leader>r <Action>(Run)
"  map <leader><leader>s <Action>(Stop)
"
  """ Refactoring
  map <leader>r <Cmd>call VSCodeNotify('editor.action.rename')<CR>
  map <leader>gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
"  map <leader>r <Action>(RenameElement)
"  map <leader>p <Action>(IntroduceParameter)
"  map <leader>fp <Action>(IntroduceFunctionalParameter)
"  map <leader>c <Action>(IntroduceConstant)
"  map <leader>v <Action>(IntroduceVariable)
"  map <leader>d <Action>(QuickJavaDoc)
"
"  map <leader>R <Action>(Refactorings.QuickListPopupAction)
"
"  map <leader>a <Action>(Annotate)
"
"  map <S-Space> <Action>(GotoNextError)
"
  """ Navigate / Search
"  map <leader>o <Action>(FileStructurePopup)
"  map <leader>ff <Action>(SearchEverywhere)
"  map <leader>fg <Action>(FindInPath)
"  map <leader>gd <Action>(GotoDeclaration)
"  map <leader>gD <Action>(GotoTypeDeclaration)
"  map <leader>gr <Action>(FindUsages)
"
"  map <leader>b <Action>(ToggleLineBreakpoint)

" Fix vscode highlighting issue
set colorcolumn=

else """ Vanilla

lua require('base')
lua require('plugins')

end

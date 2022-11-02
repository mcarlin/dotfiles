"==============================
" Shared Settings
"==============================

let mapleader=","

set so=2
set nu

" Make leader+tab switch between most recent buffer
map <leader><tab> :b#<cr>

"==============================
" Environment Specific Settings
"==============================

if has('ide') """ IDEA

  """ Plugin Settings
  set surround
  set multiple-cursors
  set argtextobj
  set easymotion
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
  map <leader>r <Action>(RenameElement)
  map <leader>p <Action>(IntroduceParameter)
  map <leader>fp <Action>(IntroduceFunctionalParameter)
  map <leader>c <Action>(IntroduceConstant)
  map <leader>v <Action>(IntroduceVariable)
  map <leader>d <Action>(QuickJavaDoc)

  map <leader>R <Action>(Refactorings.QuickListPopupAction)

  map <leader>a <Action>(Annotate)

  map <S-Space> <Action>(GotoNextError)

  """ Navigate / Search
  map <leader>o <Action>(FileStructurePopup)
  map <leader>ff <Action>(SearchEverywhere)
  map <leader>fg <Action>(FindInPath)
  map <leader>gd <Action>(GotoDeclaration)
  map <leader>gD <Action>(GotoTypeDeclaration)
  map <leader>gr <Action>(FindUsages)

  map <leader>b <Action>(ToggleLineBreakpoint)

elseif exists('g:vscode') """ VSCode


else """ Vanilla

lua require('base')

end

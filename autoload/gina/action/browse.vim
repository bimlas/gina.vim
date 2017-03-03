function! gina#action#browse#define(binder) abort
  call a:binder.define('browse', function('s:on_browse'), {
        \ 'description': 'Open a system browser and show a content in remote',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': {},
        \})
  call a:binder.define('browse:exact', function('s:on_browse'), {
        \ 'hidden': 1,
        \ 'description': 'Open a system browser and show a content in remote',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'exact': 1 },
        \})
  call a:binder.define('browse:yank', function('s:on_browse'), {
        \ 'description': 'Copy a URL of a content in remote',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'yank': 1 },
        \})
  call a:binder.define('browse:yank:exact', function('s:on_browse'), {
        \ 'hidden': 1,
        \ 'description': 'Copy a URL of a content in remote',
        \ 'mapping_mode': 'n',
        \ 'requirements': [],
        \ 'options': { 'yank': 1, 'exact': 1 },
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:on_browse(candidates, options) abort
  if empty(a:candidates)
    return
  endif
  let options = extend({
        \ 'exact': 0,
        \ 'yank': 0,
        \}, a:options)
  for candidate in a:candidates
    let treeish = gina#core#treeish#build(
          \ gina#util#get(candidate, 'rev'),
          \ gina#util#get(candidate, 'path', v:null),
          \)
    execute printf(
          \ '%s Gina browse %s %s %s',
          \ options.mods,
          \ options.exact ? '--exact' : '',
          \ options.yank ? '--yank' : '',
          \ gina#util#shellescape(treeish),
          \)
  endfor
endfunction

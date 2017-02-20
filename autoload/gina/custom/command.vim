let s:preferences = {}
let s:t_number = type(0)

function! gina#custom#command#preference(scheme, ...) abort
  let readonly = a:0 ? a:1 : 1
  let s:preferences[a:scheme] = get(s:preferences, a:scheme, {})
  let preference = extend(s:preferences[a:scheme], {
        \ 'options': [],
        \ 'origin': a:scheme,
        \ 'raw': 0,
        \}, 'keep'
        \)
  return readonly ? deepcopy(preference) : preference
endfunction

function! gina#custom#command#option(scheme, query, ...) abort
  if a:query !~# '^--\?\S\+\%(|--\?\S\+\)*$'
    throw gina#core#exception#error(
          \ 'Invalid query. See :h gina#custom#command#option'
          \)
  endif
  let value = get(a:000, 0, 1)
  let remover = type(value) == s:t_number ? s:build_remover(a:query) : ''
  let preference = gina#custom#command#preference(a:scheme, 0)
  call add(preference.options, [a:query, value, remover])
endfunction

function! gina#custom#command#alias(scheme, alias, ...) abort
  let preference = gina#custom#command#preference(a:alias, 0)
  let preference.origin = a:scheme
  let preference.raw = get(a:000, 0, 0)
endfunction


" Private --------------------------------------------------------------------
function! s:build_remover(query) abort
  let terms = split(a:query, '|')
  let names = map(copy(terms), 'matchstr(v:val, ''^--\?\zs\S\+'')')
  let remover = map(
        \ range(len(terms)),
        \ '(terms[v:val] =~# ''^--'' ? ''--no-'' : ''-!'') . names[v:val]'
        \)
  return join(remover, '|')
endfunction

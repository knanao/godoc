function! godoc#show_docs(bang, args)
 let arg = join(split(a:args), '.')
 silent! let res = system('go doc -cmd -all '.arg.' 2>/dev/null')
 if v:shell_error != 0
    let err = systemlist('go doc '.arg.' 1>/dev/null')
    echohl ErrorMsg | echomsg err | echohl None
    return
  endif
  call s:OpenReadOnlyBuffer('' , arg, res)
  endif
  setlocal ft=godoc
  nnoremap <buffer> <silent> q :q<cr>
endfunction

function godoc#list_docs()
  return systemlist('{ cd $(go env GOROOT)/src && find . -type d } | sed -e "s#^\./##" | grep -v "^\(\.\|vendor\)"')
endfunction

function! godoc#complete_docs(arg_lead, cmdline, cursor_pos)
    return filter(copy(godoc#list_docs()), 'stridx(v:val, a:arg_lead)==0')
endfunction

function s:open_read_only(target, name, body)
  execute a:target.' '.a:name
  setlocal buflisted modifiable modified noreadonly
  cal append(line('^'), split(a:body, '\n'))
  silent! $d
  setlocal noswapfile nobuflisted buftype=nofile bufhidden=unload
  setlocal nomodifiable nomodified readonly
  setlocal nonumber nobinary nolist
  execute 'normal! 1G'
endfunction

function s:open_read_only_tab(type, name, body)
  cal s:open_read_only('tabnew!', a:name, a:body)
endfunction

function s:open_read_only_buffer(type, name, body)
  cal s:open_read_only(a:type =~# '^\(v\|vert\)' ? 'vsplit!' : 'split!', a:name, a:body)
endfunction

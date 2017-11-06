" vim: ft=vim:noai:ts=2:sw=2:sts=2:iskeyword+=\:,\!,\<,\>,\-,\&
"

function Refresh_server_list(sync_others)
  silent! unmenu! UI
  menu &UI.refresh\ menu
        \ :call Refresh_server_list(1)<CR>

  menu &UI.-Sep1- :

  for s in split(serverlist(), '\n')
    if v:servername != s
      execute ':menu &UI.&Open\ in\ '.s." :execute \":bd<Bar>:call remote_send('".s."', ':drop ' . expand('#:p')  . '\\<CR\\>')<Bar>:call remote_foreground('".s."')\"<CR>"
      if a:sync_others
        call remote_send(s, ":call Refresh_server_list(0)<CR>")
      endif
    endif
  endfor
endfunction
autocmd! VimEnter,VimLeave * call Refresh_server_list(1)

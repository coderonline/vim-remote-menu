" vim: ft=vim:noai:ts=2:sw=2:sts=2:iskeyword+=\:,\!,\<,\>,\-,\&
"

function! Refresh_server_list()
silent! unmenu! UI
menu &UI.refresh\ server\ list :call Refresh_server_list()<CR>
menu &UI.-Sep1- :
for s in split(serverlist(), '\n')
  if v:servername != s
    execute ':menu &UI.&Open\ in\ '.s." :execute \":bd<Bar>:call remote_send('".s."', ':drop ' . expand('#:p')  . '\\<CR\\>')<Bar>:call remote_foreground('".s."')\"<CR>"
  endif
endfor
endfunction
autocmd! VimEnter * call Refresh_server_list()


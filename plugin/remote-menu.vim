" vim: set filetype=vim:noai:ts=2:sw=2:sts=2:iskeyword+=\:,\!,\<,\>,\-,\&

" this plugin requires Vims clientserver feature to be compiled in and will otherwise be disabled...
if has('clientserver')
    let g:remote_menu_name = '&Remote'

    function! RemoteMenuSendTo(servername)
      " switch to either a new and empty or the previous buffer
      if len(getbufinfo({'buflisted':1})) == 1
        new
      else
        bp
      endif

      " close the previously left buffer (alternate)
      bd #

      call remote_send(a:servername, ':drop '.expand('#:p').'<CR>')
      call remote_foreground(a:servername)
    endfunction

    " this is a wrapper function with does just a little more then serverlist()
    function s:ServerList(ArgLead, CmdLine, CursorPos)
      return sort(split(serverlist(), '\n'))
    endfunction

    function! RemoteMenuUpdate(announce, exception)

      " first ensure, that each vim session is a server session (gvim does that by default)
      if v:servername == ''
        silent! call remote_startserver('VIM')
      endif

      " clear the menu and recreate it
      silent! aunmenu g:remote_menu_name

      for s in s:ServerList(0, 0, 0)
        if s != v:servername && s != a:exception

          " local vim session: add menu entry
          execute ':menu '.g:remote_menu_name.'.&Send\ to\ '.s.' '
                \ ":execute \":bp<Bar>bd #"
                \ "<Bar>:call remote_send('".s."', ':drop ' . expand('#:p') . '\\<CR\\>')
                \ <Bar>:call remote_foreground('".s."')\"<CR>"

          if a:announce == 1
            " inform other server to execute this function and refresh their menus
            call remote_send(s, "<C-\\><C-n>:call RemoteMenuUpdate(0, '".a:exception."')<CR>")

          endif

        endif
      endfor

    endfunction

    autocmd VimEnter * call RemoteMenuUpdate(1, '')
    autocmd VimLeave * call RemoteMenuUpdate(1, v:servername)

    command -complete=customlist,s:ServerList -nargs=1 RemoteMenuSendTo :call RemoteMenuSendTo("<args>")
endif

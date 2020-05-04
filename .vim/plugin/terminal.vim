" Functions and commands for using terminal windows

" Run command reusing existing terminal window
function! TermExec(command)
    " Get all terminal buffers
    let tlist = term_list()
    for bufn in tlist
        " If status is finished
        let status = term_getstatus(bufn)
        if status == "finished"
            " If has a window on this tabpage
            let window = bufwinnr(bufn)
            if window != -1
                " Reuse window
                execute window . "wincmd w"
                execute "terminal ++curwin" a:command
                return bufnr("%")
            endif
        endif
    endfor
    " Create new window
    execute "bo terminal ++rows=15" a:command
    return bufnr("%")
endfunction

" Function for getting options with my defaults
function! s:getTermOptions()
    let options = {"term_finish": "close", "term_kill": "hup"}
    " Always use netrw dir if avaliable
    if exists("b:netrw_curdir")
        let options["cwd"] = b:netrw_curdir
    endif
    return options
endfunction

function! TerminalBelow()
    let options = s:getTermOptions()
    let options["term_rows"] = 20
    botright call term_start(&shell, options)
endfunction

function! TerminalTab()
    let options = s:getTermOptions()
    $tab call term_start(&shell, options)
endfunction

command! -nargs=* Run :call s:TermExec("<args>")
command! Term call TerminalBelow()
command! TabTerm call TerminalTab()

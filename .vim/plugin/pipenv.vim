" Get path to pipenv virtualenv
function! s:getEnvPath()
    if executable("pipenv")
        silent let output = system("pipenv --venv")
        let envpath = trim(output, "\n")
        " If command exited with 0 we got an env dir
        if v:shell_error == 0
            return envpath
        else
            echoerr "No venv found"
        endif
    else
        echoerr "Pipenv is not installed"
    endif

    return ""
endfunction

function! s:getSitePath()
    let envpath = s:getEnvPath()
    if envpath != ""
        let splist = glob(envpath . "/lib/*/site-packages", 1, 1)
        return splist[0]
    endif

    return ""
endfunction

" Open package from pipenv path
function! PipenvOpen(package)
    let sitepath = s:getSitePath()
    if sitepath != ""
        let package_path = sitepath . "/" . a:package
        if isdirectory(package_path)
            execute "tabe" package_path
            execute "tcd" package_path
        else
            echoerr a:package "is not installed"
        endif
    else
        echoerr "Could not find site path"
    endif
endfunction

command! -nargs=1 PipenvOpen call PipenvOpen("<args>")

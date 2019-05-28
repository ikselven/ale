" Author: Bartolomeo Stellato <bartolomeo.stellato@gmail.com>
" Description: A language server for Julia

" Set julia executable variable
call ale#Set('julia_executable', 'julia')

function! ale_linters#julia#languageserver#GetCommand(buffer) abort
    let l:julia_executable = ale#Var(a:buffer, 'julia_executable')
    let l:cmd_string = '
                \ using Pkg, LanguageServer, SymbolServer;
                \ Pkg.activate(@__DIR__);
                \ server = LanguageServer.LanguageServerInstance(stdin, stdout, false, @__DIR__, "", Dict());
                \ server.runlinter = true;
                \ run(server);'

    return ale#Escape(l:julia_executable) . ' --startup-file=no --history-file=no -e ' . ale#Escape(l:cmd_string)
endfunction

call ale#linter#Define('julia', {
\   'name': 'languageserver',
\   'lsp': 'stdio',
\   'executable': {b -> ale#Var(b, 'julia_executable')},
\   'command': function('ale_linters#julia#languageserver#GetCommand'),
\   'language': 'julia',
\   'project_root': function('ale#julia#FindProjectRoot'),
\})

command -nargs=1 -bang -complete=customlist,godoc#complete_docs GoDoc cal godoc#show_docs('<bang>', <f-args>)
command GoList cal godoc#list_docs()

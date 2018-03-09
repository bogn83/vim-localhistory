""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-localhistory
" Copyright (C) 2018 Gianmaria Bajo <mg1979.git@gmail.com>
" License: MIT License
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Init
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:lh_basedir              = get(g:, 'lh_basedir', '~/.vim/local_history')
let g:lh_open_mode            = get(g:, 'lh_open_mode', 'edit')
let g:lh_vert_diff            = get(g:, 'lh_vert_diff', 1)
let g:lh_autobackup_frequency = get(g:, 'lh_autobackup_frequency', 0)
let g:lh_autobackup_first     = get(g:, 'lh_autobackup_first', 0)
let g:lh_autobackup_size      = get(g:, 'lh_autobackup_size', 10240)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

com! -nargs=? LHwrite call lh#backup_file(<f-args>)

com! LHdated call fzf#run({'source': lh#find_files(0),
            \ 'sink': function('lh#open_backup'), 'down': '30%',
            \ 'options': '--multi --reverse --prompt "Local History >>>  "'})

com! LHsnapshot call fzf#run({'source': lh#find_files(1),
            \ 'sink': function('lh#open_backup'), 'down': '30%',
            \ 'options': '--multi --reverse --prompt "Snapshots >>>  "'})

com! LHall call fzf#run({'source': lh#find_files(2),
            \ 'sink': function('lh#open_backup'), 'down': '30%',
            \ 'options': '--multi --reverse --prompt "Snapshots >>>  "'})

com! LHdiff call fzf#run({'source': lh#find_files(2),
            \ 'sink': function('lh#diff'), 'down': '30%',
            \ 'options': '--reverse --prompt "Diff with backup >>>  "'})

com! LHdelete call fzf#run({'source': lh#find_files(2),
            \ 'sink': function('lh#delete_backups'), 'down': '30%',
            \ 'options': '--multi --reverse --prompt "Delete Backups >>>  "'})

augroup plugin-lh
    autocmd!
    autocmd BufEnter * call lh#bufenter()

    if g:lh_autobackup_frequency
        autocmd BufWritePost * call lh#auto_backup()
    endif
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:local_history_disable_mappings')
    if !hasmapto('<Plug>LHWriteDate')
        map <unique> ght <Plug>LHWriteDated
    endif
    if !hasmapto('<Plug>LHWriteSnapshot')
        map <unique> ghs <Plug>LHWriteSnapshot
    endif
    if !hasmapto('<Plug>LHDiff')
        map <unique> ghd <Plug>LHDiff
    endif
    if !hasmapto('<Plug>LHLoadDate')
        map <unique> ghT <Plug>LHLoadDated
    endif
    if !hasmapto('<Plug>LHLoadSnapshot')
        map <unique> ghS <Plug>LHLoadSnapshot
    endif
    if !hasmapto('<Plug>LHDelete')
        map <unique> ghD <Plug>LHDelete
    endif
endif

nnoremap <silent> <unique> <script> <Plug>LHWriteDated    :LHwrite<cr>
nnoremap <unique> <script>          <Plug>LHWriteSnapshot :LHwrite<Space>
nnoremap <silent> <unique> <script> <Plug>LHLoadDated     :LHdated<cr>
nnoremap <silent> <unique> <script> <Plug>LHLoadSnapshot  :LHsnapshot<cr>
nnoremap <silent> <unique> <script> <Plug>LHDelete        :LHdelete<cr>
nnoremap <silent> <unique> <script> <Plug>LHDiff          :LHdiff<cr>

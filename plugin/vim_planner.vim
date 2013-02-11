

"
" Mini Year Planner for VIM 
" version 0.01
"
" Needs some joint efforts for a newer release, please.
" todo:
" Simple Tabulation of the months
 
" -----------------------------------------------------------
" How to ? 
" Select the first line (###################) with shift+v 
" then press ,q 
" and you will see that it will attempt to draw you the tabs for the year 
" If you enter 1testa;2    then it will prolongate the "#" line to reach the
" tabulation of the number 2
" -----------------------------------------------------------




" Example - Simple Project Bar Planner for the current year
" -----------------------------------------------------------
"                    #########################################################################
"                         1     2     3     4     5     6     7     8     9     10     11     12     
"1testa;    2;
"2testa;3.5;3.5;     #########(1m)###########
"testa; dsfkasdf;
"testa;dsfkasdf;
"5testa ;10.2;10.2;  #########(1m)#################################################
"6testa ;8.2;8.2;    #########(8m)#####################################
"







func! VtoList()
  firstline = line('v')  " Gets the line where the visual block begins
  lastline = line('.')   " Gets the current line, but not the one I want.
  mylist = getline(firstline, lastline)
  echo mylist
endfunc



function! VisualLengthPlan()
  " count the number of chars
  exe 'normal "xy'
  echo "Visual: " . strlen(@x) . "\n"
  exe 'normal gv'
  let visualengthtotal = strlen(@x)

  " make some sto
  let curr_line   = getline(".")
  let save_cursor = getpos(".")
  call setpos('.', save_cursor)

  " remove tabs 
  let topbartmp =  getline(".")
  let topbar = ""
  let j = 0 
  while j <= ( visualengthtotal  ) 
    if topbartmp[j]  != ' ' 
      let topbar = topbar . topbartmp[j] 
    endif
    let j +=1
  endwhile 
  "echomsg " Topc bar : " . topbar

  " redefine the total length
  call setline(line(".")+0, topbar )
  let visualengthtotal = strlen(@x)

  " create the bar separator
  let barsep=""
  let iteration = round( visualengthtotal / 12 )  
  let j = 1 
  while j <= ( visualengthtotal / (12 + 6)  )  
    let barsep = barsep . " "
    let j +=1
  endwhile 

  " create the top bar
  let yearbar = barsep 
  let mon = 1 
  while mon <= 12
    let yearbar = yearbar . mon . barsep
    let mon += 1
  endwhile
  "call setline(line(".")+1, yearbar )
  " echomsg " topbar ist: " . barsep . topbar 
  " echomsg " bar ist: " . barsep .  yearbar 




  " calculate the max length for tabulation 
  let coutermaxtab = 0 
  let linenbr = 0
  while linenbr  <=  line("$")
    let line = getline( line(save_cursor) + linenbr)
    let texfirstcharcheck = line[0]

    if line != "" && line != " "   
      let matchitem = ';'
      let matchit = matchstr(line,matchitem) 

      if matchit != ""
        let parta = split(line, matchitem)[0]
        let partb = split(line, matchitem)[1]
        let counterch= strlen( parta .  ";" . partb ) 
        if counterch > coutermaxtab
          let coutermaxtab = counterch 
        endif
      endif
    endif
    let linenbr = linenbr +1
  endwhile
  let coutermaxtab = coutermaxtab +5
  " echomsg "Max tab: " . coutermaxtab



  " create the bar separator for the title
  let barsep=""
  let j = 1 
  let barseptitle = ""
  while j <= coutermaxtab 
    let barseptitle = barseptitle . " "
    let j +=1
  endwhile 



  " Draw the new planner
  " separator bar
  call setline(line(".")+0, barseptitle . topbar )
  call setline(line(".")+1, barseptitle . yearbar )

  " print and format the cols
  " this is not necessary but still ...
  call setpos('.', save_cursor)
  " 
  let counti = 1 
  let gameover = 0 
  while (gameover == 0) 
    let line = getline( line(".") + counti )

    if line != "" && line != " "   
      let matchitem = ';'
      let matchit = matchstr(line,matchitem) 
      if matchit != ""
        let parta = split(line, matchitem)[0]
        let partb = split(line, matchitem)[1]
        let partc = split(line, matchitem)[1]
        " some stuffs... indeed:
        let inter = 1
        let inter = 1 + partc -1  

        if ( inter == 0 ) 
           let finalline= parta . ";" . partb . ";"
         else
           let finalline= parta . ";" . partb . ";" . partc . ";       #########(1m)#########"
        endif

        call setline(line(".")+ counti , finalline  )
      endif
    endif

    if line == "" 
      let gameover = 1
    endif

    let counti = counti +1

  endwhile

  call setpos('.', save_cursor)
endfunction





map ,q "xy:call VisualLengthPlan()<CR>




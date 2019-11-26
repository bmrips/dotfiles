" amsmath.vim
" Author:  Charles E. Campbell
" Date:    Apr 01, 2019
" Version: 1d ASTRO-ONLY
"
" Support for the amsmath and amssymb LaTeX packages

let b:loaded_amsmath = "v1d"

" Save compatibility options and reset them to Vim default to enable line continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

" AMS-Math Package Support {{{1

call TexNewMathZone("E","align",1)
call TexNewMathZone("F","alignat",1)
call TexNewMathZone("G","equation",1)
call TexNewMathZone("H","flalign",1)
call TexNewMathZone("I","gather",1)
call TexNewMathZone("J","multline",1)
call TexNewMathZone("K","xalignat",1)
call TexNewMathZone("L","xxalignat",0)

syntax match texBadMath	"\\end\s*{\s*\(align\|alignat\|equation\|flalign\|gather\|multline\|xalignat\|xxalignat\)\*\=\s*}"

" Amsmath [lr][vV]ert  (Holger Mitschke)
let s:texMathDelimList=[
    \ ['\\lvert'     , '|'] ,
    \ ['\\rvert'     , '|'] ,
    \ ['\\lVert'     , '‖'] ,
    \ ['\\rVert'     , '‖'] ,
    \ ]
for texmath in s:texMathDelimList
	execute "syntax match texMathDelim '\\\\[bB]igg\\=[lr]\\=".texmath[0]."' contained conceal cchar=".texmath[1]
endfor

" AMS-Math and AMS-Symb Package Support {{{1

let s:texMathList=[
    \ ['backepsilon'        , '∍'] ,
    \ ['backsimeq'          , '≃'] ,
    \ ['barwedge'           , '⊼'] ,
    \ ['because'            , '∵'] ,
    \ ['beth'               , 'ܒ'] ,
    \ ['between'            , '≬'] ,
    \ ['blacksquare'        , '∎'] ,
    \ ['Box'                , '☐'] ,
    \ ['boxdot'             , '⊡'] ,
    \ ['boxminus'           , '⊟'] ,
    \ ['boxplus'            , '⊞'] ,
    \ ['boxtimes'           , '⊠'] ,
    \ ['bumpeq'             , '≏'] ,
    \ ['Bumpeq'             , '≎'] ,
    \ ['Cap'                , '⋒'] ,
    \ ['circeq'             , '≗'] ,
    \ ['circlearrowleft'    , '↺'] ,
    \ ['circlearrowright'   , '↻'] ,
    \ ['circledast'         , '⊛'] ,
    \ ['circledcirc'        , '⊚'] ,
    \ ['colon'              , ':'] ,
    \ ['complement'         , '∁'] ,
    \ ['Cup'                , '⋓'] ,
    \ ['curlyeqprec'        , '⋞'] ,
    \ ['curlyeqsucc'        , '⋟'] ,
    \ ['curlyvee'           , '⋎'] ,
    \ ['curlywedge'         , '⋏'] ,
    \ ['doteqdot'           , '≑'] ,
    \ ['dotplus'            , '∔'] ,
    \ ['dotsb'              , '⋯'] ,
    \ ['dotsc'              , '…'] ,
    \ ['dotsi'              , '⋯'] ,
    \ ['dotso'              , '…'] ,
    \ ['doublebarwedge'     , '⩞'] ,
    \ ['eqcirc'             , '≖'] ,
    \ ['eqsim'              , '≂'] ,
    \ ['eqslantgtr'         , '⪖'] ,
    \ ['eqslantless'        , '⪕'] ,
    \ ['eth'                , 'ð'] ,
    \ ['fallingdotseq'      , '≒'] ,
    \ ['geqq'               , '≧'] ,
    \ ['gimel'              , 'ℷ'] ,
    \ ['gneqq'              , '≩'] ,
    \ ['gtrdot'             , '⋗'] ,
    \ ['gtreqless'          , '⋛'] ,
    \ ['gtrless'            , '≷'] ,
    \ ['gtrsim'             , '≳'] ,
    \ ['iiint'              , '∭'] ,
    \ ['iint'               , '∬'] ,
    \ ['implies'            , '⇒'] ,
    \ ['leadsto'            , '↝'] ,
    \ ['leftarrowtail'      , '↢'] ,
    \ ['leftrightsquigarrow', '↭'] ,
    \ ['leftthreetimes'     , '⋋'] ,
    \ ['leqq'               , '≦'] ,
    \ ['lessdot'            , '⋖'] ,
    \ ['lesseqgtr'          , '⋚'] ,
    \ ['lesssim'            , '≲'] ,
    \ ['lneqq'              , '≨'] ,
    \ ['ltimes'             , '⋉'] ,
    \ ['measuredangle'      , '∡'] ,
    \ ['ncong'              , '≇'] ,
    \ ['nexists'            , '∄'] ,
    \ ['ngeq'               , '≱'] ,
    \ ['ngeqq'              , '≱'] ,
    \ ['ngtr'               , '≯'] ,
    \ ['nleftarrow'         , '↚'] ,
    \ ['nLeftarrow'         , '⇍'] ,
    \ ['nLeftrightarrow'    , '⇎'] ,
    \ ['nleq'               , '≰'] ,
    \ ['nleqq'              , '≰'] ,
    \ ['nless'              , '≮'] ,
    \ ['nmid'               , '∤'] ,
    \ ['nparallel'          , '∦'] ,
    \ ['nprec'              , '⊀'] ,
    \ ['nrightarrow'        , '↛'] ,
    \ ['nRightarrow'        , '⇏'] ,
    \ ['nsim'               , '≁'] ,
    \ ['nsucc'              , '⊁'] ,
    \ ['ntriangleleft'      , '⋪'] ,
    \ ['ntrianglelefteq'    , '⋬'] ,
    \ ['ntriangleright'     , '⋫'] ,
    \ ['ntrianglerighteq'   , '⋭'] ,
    \ ['nvdash'             , '⊬'] ,
    \ ['nvDash'             , '⊭'] ,
    \ ['nVdash'             , '⊮'] ,
    \ ['pitchfork'          , '⋔'] ,
    \ ['precapprox'         , '⪷'] ,
    \ ['preccurlyeq'        , '≼'] ,
    \ ['precnapprox'        , '⪹'] ,
    \ ['precneqq'           , '⪵'] ,
    \ ['precsim'            , '≾'] ,
    \ ['rightarrowtail'     , '↣'] ,
    \ ['rightsquigarrow'    , '↝'] ,
    \ ['rightthreetimes'    , '⋌'] ,
    \ ['risingdotseq'       , '≓'] ,
    \ ['rtimes'             , '⋊'] ,
    \ ['sphericalangle'     , '∢'] ,
    \ ['star'               , '✫'] ,
    \ ['subset'             , '⊂'] ,
    \ ['Subset'             , '⋐'] ,
    \ ['subseteqq'          , '⫅'] ,
    \ ['subsetneq'          , '⊊'] ,
    \ ['subsetneqq'         , '⫋'] ,
    \ ['succapprox'         , '⪸'] ,
    \ ['succcurlyeq'        , '≽'] ,
    \ ['succnapprox'        , '⪺'] ,
    \ ['succneqq'           , '⪶'] ,
    \ ['succsim'            , '≿'] ,
    \ ['Supset'             , '⋑'] ,
    \ ['supseteqq'          , '⫆'] ,
    \ ['supsetneq'          , '⊋'] ,
    \ ['supsetneqq'         , '⫌'] ,
    \ ['therefore'          , '∴'] ,
    \ ['trianglelefteq'     , '⊴'] ,
    \ ['triangleq'          , '≜'] ,
    \ ['trianglerighteq'    , '⊵'] ,
    \ ['twoheadleftarrow'   , '↞'] ,
    \ ['twoheadrightarrow'  , '↠'] ,
    \ ['ulcorner'           , '⌜'] ,
    \ ['urcorner'           , '⌝'] ,
    \ ['varnothing'         , '∅'] ,
    \ ['vartriangle'        , '∆'] ,
    \ ['vDash'              , '⊨'] ,
    \ ['Vdash'              , '⊩'] ,
    \ ['veebar'             , '⊻'] ,
    \ ['Vvdash'             , '⊪']]

for texmath in s:texMathList
  if texmath[0] =~# '\w$'
    exe "syntax match texMathSymbol '\\\\".texmath[0]."\\>' contained conceal cchar=".texmath[1]
  else
    exe "syntax match texMathSymbol '\\\\".texmath[0]."' contained conceal cchar=".texmath[1]
  endif
endfor

" }}}1

" Restore compatibility options
let &cpoptions = s:save_cpo
unlet s:save_cpo

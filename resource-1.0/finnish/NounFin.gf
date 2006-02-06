concrete NounFin of Noun = CatFin ** open ResFin, Prelude in {

  flags optimize=all_subs ;

  lin

-- The $Number$ is subtle: "nuo autot", "nuo kolme autoa" are both plural
-- for verb agreement, but the noun form is singular in the latter.

    DetCN det cn = 
      let
        n : Number = case det.isNum of {
          True => Sg ;
          _ => det.n
          } ;
        ncase : Case -> NForm = \c -> case <n,c,det.isNum,det.isPoss> of {
          <_, Nom,True,_> => NCase Sg Part ;
          <_, _,  True,False> => NCase Sg c ;
          <_, Nom,_,True> => NPossNom ; 
          <Sg,Gen,_,True> => NPossNom ;
          <Pl,Gen,_,True> => NPossGenPl ;
          <_,Transl,_,True> => NPossTransl n ;
          <_,Illat,_,True>  => NPossIllat n ;
 
          _ => NCase n c  ----
          }
      in {
      s = \\c => let k = npform2case c in
                 det.s1 ! k ++ cn.s ! ncase k ++ det.s2 ; 
      a = agrP3 det.n ;
      isPron = False
      } ;

    UsePN pn = {
      s = \\c => pn.s ! npform2case c ; 
      a = agrP3 Sg ;
      isPron = False
      } ;
    UsePron p = p ** {isPron = True} ;

    PredetNP pred np = {
      s = \\c => pred.s ! np.a.n ! npform2case c ++ np.s ! c ;
      a = np.a ;
      isPron = np.isPron  -- kaikki minun - ni
      } ;

    DetSg quant ord = {
      s1 = \\c => quant.s1 ! c ++ ord.s ! Sg ! c ;
      s2 = quant.s2 ; 
      n  = Sg ; 
      isNum = False ; 
      isPoss = quant.isPoss
      } ;

    DetPl quant num ord = {
      s1 = \\c => quant.s1 ! c ++ num.s ! Sg ! c ++ ord.s ! Sg ! c ; 
      s2 = quant.s2 ;       
      n = Pl ;
      isNum = num.isNum ;
      isPoss = quant.isPoss
      } ;

    SgQuant quant = {
      s1 = quant.s1 ! Sg ; 
      s2 = quant.s2 ; 
      isNum = quant.isNum ; 
      isPoss = quant.isPoss
      } ;
    PlQuant quant = {
      s1 = quant.s1 ! Pl ; 
      s2 = quant.s2 ; 
      isNum = quant.isNum ; 
      isPoss = quant.isPoss
      } ;


    PossPron p = {
      s1 = \\_,_ => p.s ! NPCase Gen ;
      s2 = BIND ++ table Agr ["ni" ; "si" ; "nsa" ; "mme" ; "nne" ; "nsa"] ! p.a ;
      isNum = False ;
      isPoss = True
      } ;

    NoNum = {s = \\_,_ => [] ; isNum = False} ;
    NoOrd = {s = \\_,_ => []} ;

    NumInt n = {s = \\_,_ => n.s ; isNum = True} ;
    OrdInt n = {s = \\_,_ => n.s ++ "."} ;

----    NumNumeral numeral = {s = numeral.s ! NCard} ;
----    OrdNumeral numeral = {s = numeral.s ! NOrd} ;

    AdNum adn num = {s = \\n,c => adn.s ++ num.s ! n ! c ; isNum = num.isNum} ;

----    OrdSuperl a = {s = a.s ! AAdj Superl} ;

    DefArt = {
      s1 = \\_,_ => [] ; 
      s2 = [] ; 
      isNum,isPoss = False
      } ;

    IndefArt = {
      s1 = \\_,_ => [] ; --- Nom is Part in Pl ?
      s2 = [] ; 
      isNum,isPoss = False
      } ;

    MassDet = {
      s1 = \\_ => [] ; --- Nom is Part ?
      s2 = [] ; 
      isNum,isPoss = False
      } ;

    UseN n = n ;

    UseN2 n = n ;
    UseN3 n = n ;

    ComplN2 f x = {
      s = \\nf => appCompl True Pos f.c2 x ++ f.s ! nf
      } ;
    ComplN3 f x = {
      s = \\nf => appCompl True Pos f.c2 x ++ f.s ! nf ;
      c2 = f.c3
      } ;

    AdjCN ap cn = {
      s = \\nf => ap.s ! True ! AN nf ++ cn.s ! nf
      } ;
{-
    RelCN cn rs = {s = \\n,c => cn.s ! n ! c ++ rs.s ! {n = n ; p = P3}} ;
    AdvCN cn ad = {s = \\n,c => cn.s ! n ! c ++ ad.s} ;

    SentCN cn sc = {s = \\n,c => cn.s ! n ! c ++ sc.s} ;
-}
}

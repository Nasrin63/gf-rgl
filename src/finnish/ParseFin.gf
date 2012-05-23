--# -path=alltenses:.:../english
concrete ParseFin of ParseEngAbs = 
  TenseX, ---- - [Pol, PNeg, PPos],
  CatFin,
  NounFin,
  AdjectiveFin,
  NumeralFin,
  SymbolFin [PN, Symb, MkSymb, SymbPN],
  ConjunctionFin,
  VerbFin - [SlashV2V, PassV2, UseCopula],
  AdverbFin,
  PhraseFin,
  SentenceFin,
  RelativeFin,
  IdiomFin [NP, VP, Tense, Cl, ProgrVP, ExistNP],
--  ExtraFin [NP, Quant, VPSlash, VP, Tense, GenNP, PassVPSlash],
  DictEngFin ** 
open MorphoFin, ResFin, ParadigmsFin, Prelude in {

flags literal=Symb ;
{-
lin
  myself_NP = regNP "myself" singular ;
  yourselfSg_NP = regNP "yourself" singular ;
  himself_NP = regNP "himself" singular ;
  herself_NP = regNP "herself" singular ;
  itself_NP = regNP "itself" singular ;
  ourself_NP = regNP "ourself" plural ;
  yourselfPl_NP = regNP "yourself" plural ;
  themself_NP = regNP "themself" plural ;
  themselves_NP = regNP "themselves" plural ;

  CompoundCN num noun cn = {
    s = \\n,c => num.s ! Nom ++ noun.s ! num.n ! Nom ++ cn.s ! n ! c ;
    g = cn.g
  } ;
  
  DashCN noun1 noun2 = {
    s = \\n,c => noun1.s ! Sg ! Nom ++ "-" ++ noun2.s ! n ! c ;
    g = noun2.g
  } ;

  GerundN v = {
    s = \\n,c => v.s ! VPresPart ;
    g = Neutr
  } ;
  
  GerundAP v = {
    s = \\agr => v.s ! VPresPart ;
    isPre = True
  } ;

  PastPartAP v = {
    s = \\agr => v.s ! VPPart ;
    isPre = True
  } ;

  OrdCompar a = {s = \\c => a.s ! AAdj Compar c } ;

  PositAdVAdj a = {s = a.s ! AAdv} ;

  UseQuantPN q pn = {s = \\c => q.s ! False ! Sg ++ pn.s ! npcase2case c ; a = agrgP3 Sg pn.g} ;

  SlashV2V v p vp = insertObjc (\\a => p.s ++ case p.p of {CPos => ""; _ => "not"} ++ 
                                       v.c3 ++ 
                                       infVP v.typ vp a)
                               (predVc v) ;

  ComplPredVP np vp = {
      s = \\t,a,b,o => 
        let 
          verb  = vp.s ! t ! a ! b ! o ! np.a ;
          compl = vp.s2 ! np.a
        in
        case o of {
          ODir => compl ++ "," ++ np.s ! npNom ++ verb.aux ++ verb.adv ++ vp.ad ++ verb.fin ++ verb.inf ;
          OQuest => verb.aux ++ compl ++ "," ++ np.s ! npNom ++ verb.adv ++ vp.ad ++ verb.fin ++ verb.inf 
          }
    } ;

  that_RP = {
    s = \\_ => "that" ;
    a = RNoAg
    } ;
  no_RP = {
    s = \\_ => "" ;
    a = RNoAg
    } ;

  CompS s = {s = \\_ => "that" ++ s.s} ;
  CompVP vp = {s = \\a => infVP VVInf vp a} ;

lin
  PPos = {s = [] ; p = CPos} ;
  PNeg = {s = [] ; p = CNeg True} ; -- contracted: don't
-}    
}

incomplete concrete PredFunctor of Pred = Cat [Ant,NP,Utt,IP,IAdv,IComp,Conj,RP,RS] ** 
  open 
    PredInterface,
    ParamX,
    Prelude 
  in {

------------------------------------
-- lincats
-------------------------------------

lincat
  Tense = {s : Str ; t : PredInterface.STense} ;
  Pol   = {s : Str ; p : PredInterface.Polarity} ;

  Arg  = {s : Str} ;

  PrV  = PrVerb ;
  PrVP = PrVerbPhrase ;
  PrCl = PrClause ;

  PrQCl = PrQuestionClause ;

  PrVPI = {s : PredInterface.VVType => Agr => Str} ;

  VPC = {
    v   : VAgr => Str ;
    inf : Agr => Str ; 
    c1  : ComplCase ; 
    c2  : ComplCase ;
    s1  : Str ; -- storing both in both-and
    } ;

  ClC = {
    s  : Str ;
    c3 : ComplCase ;
    s1 : Str ;
    } ;

  PrAdv = PrAdverb ;
  PrS   = {s : Str} ;

  PrAP = {
    s : AAgr => Str ; 
    c1, c2 : ComplCase ; 
    obj1 : Agr => Str
    } ;

  PrCN = {
    s : NAgr => Str ; 
    c1, c2 : ComplCase ; 
    obj1 : Agr => Str
    } ;

-- reference linearizations for chunking

linref
  PrVP  = linrefPrVP ;
  PrCl  = linrefPrCl ;
  PrQCl = linrefPrQCl ;
  PrAdv = linrefPrAdv ;
  
----------------------------
--- linearization rules ----
----------------------------

lin

-- standard general

  TPres  = {s = [] ; t = Pres} ;
  TPast  = {s = [] ; t = Past} ;
  TFut   = {s = [] ; t = Fut} ;
  TCond  = {s = [] ; t = Cond} ;
  ASimul = {s = [] ; a = Simul} ;
  AAnter = {s = [] ; a = Anter} ;
  PPos   = {s = [] ; p = Pos} ;
  PNeg   = {s = [] ; p = Neg} ;

-- predication specific

  aNone, aS, aV, aA, aQ, aN = {s = []} ;
  aNP a = a ;

  UseV x a t p v = initPrVerbPhraseV a t p v ;

  PassUseV x a t p v = initPrVerbPhraseV a t p v ** {
    v   = \\agr => tenseV (a.s ++ t.s ++ p.s) t.t a.a p.p passive agr v ;
    inf = \\vt => tenseInfV a.s a.a p.p passive v vt ;
    obj2 = <noObj, True> ; -- becomes subject control even if object control otherwise "*she was promised by us to love ourselves"
    qforms = \\agr => qformsCopula (a.s ++ t.s ++ p.s) t.t a.a p.p agr ;
    } ;

  AgentPassUseV x a t p v np = initPrVerbPhraseV a t p v ** {
    v   = \\agr => tenseV (a.s ++ t.s ++ p.s) t.t a.a p.p passive agr v ;
    inf = \\vt => tenseInfV a.s a.a p.p passive v vt ;
    obj2 = <noObj, True> ; -- becomes subject control even if object control otherwise "*she was promised by us to love ourselves"
    adv = appComplCase agentCase np ;
    qforms = \\agr => qformsCopula (a.s ++ t.s ++ p.s) t.t a.a p.p agr ;
    } ;

  UseAP x a t p ap = useCopula a t p ** {
    c1  = ap.c1 ;
    c2  = ap.c2 ;
    adj = \\a => ap.s ! agr2aagr a ;
    obj1 = <ap.obj1, defaultAgr> ;
    } ;

  UseCN x a t p cn = useCopula a t p ** {
    c1  = cn.c1 ;
    c2  = cn.c2 ;
    adj = \\a => cn.s ! agr2nagr a ;
    obj1 = <cn.obj1, defaultAgr> ;
    } ;

  UseAdv x a t p adv = useCopula a t p ** {
    c1  = adv.c1 ;
    adj = \\a => adv.s ;
    } ;

  UseNP a t p np = useCopula a t p ** {
    adj = \\a => np.s ! subjCase ;
    } ;

  ComplV2 x vp np = vp ** {
    obj1 = <\\a => np.s ! objCase, np.a>  -- np.a for object control 
    } ;

  ComplVS x vp cl = addExtVP vp (that_Compl ++ declSubordCl cl) ; ---- sentence form

  ComplVQ x vp qcl = addExtVP vp (questSubordCl qcl) ; ---- question form

  ComplVV x vp vpo = addObj2VP vp (\\a => vpo.s ! vp.vvtype ! a) ;

  ComplVA x vp ap = addObj2VP vp (\\a => ap.s ! agr2aagr a ++ ap.obj1 ! a) ; ---- adjForm

  ComplVN x vp cn = addObj2VP vp (\\a => cn.s ! agr2nagr a ++ cn.obj1 ! a) ; ---- cnForm

  SlashV3 x vp np = addObj2VP vp (\\a => np.s ! objCase) ; -- control is preserved 

  SlashV2S x vp cl = addExtVP vp (that_Compl ++ declSubordCl cl) ; ---- sentence form

  SlashV2Q x vp cl = addExtVP vp (questSubordCl cl) ; ---- question form

  SlashV2V x vp vpo = addObj2VP vp (\\a => vpo.s ! vp.vvtype ! a) ;

  SlashV2A x vp ap = addObj2VP vp (\\a => ap.s ! agr2aagr a ++ ap.obj1 ! a) ; ---- adjForm

  SlashV2N x vp cn = addObj2VP vp (\\a => cn.s ! agr2nagr a ++ cn.obj1 ! a) ; ---- cn form

  ReflVP x vp = vp ** {
    obj1 = <\\a => reflPron a, defaultAgr> ;  --- defaultAgr will not be used but subj.a instead
    } ;

  ReflVP2 x vp = vp ** {
    obj2 = <\\a => reflPron a, vp.obj2.p2> ; --- subj/obj control doesn't matter any more
    } ;

  InfVP x vp = {s = \\vvt,a => infVP vvt a vp} ;

  PredVP x np vp = vp ** {
    v    = applyVerb vp (agr2vagr np.a) ;
    subj = np.s ! subjCase ;
    adj  = vp.adj ! np.a ;
    obj1 = vp.part ++ strComplCase vp.c1 ++ vp.obj1.p1 ! np.a ;  ---- apply complCase ---- place of part depends on obj
    obj2 = strComplCase vp.c2 ++ vp.obj2.p1 ! (case vp.obj2.p2 of {True => np.a ; False => vp.obj1.p2}) ;   ---- apply complCase
    c3   = noComplCase ;      -- for one more prep to build ClSlash 
    qforms = qformsVP vp (agr2vagr np.a) ; 
    } ;

  SlashClNP x cl np = cl ** {  -- Cl ::= Cl/NP NP 
    adv  = cl.adv ++ appComplCase cl.c3 np ; ---- again, adv just added
    c3   = noComplCase ;  -- complCase has been consumed
    } ;

  QuestCl x cl = cl ** {foc = [] ; focType = NoFoc} ;  -- NoFoc implies verb first: does she love us

  QuestIAdv x iadv cl = cl ** {foc = iadv.s ; focType = FocObj} ; -- FocObj implies Foc + V + Subj: why does she love us

  QuestVP x ip vp = 
   let 
       ipa = ipagr2agr ip.n 
   in {
    v    = applyVerb vp (ipagr2vagr ip.n) ;
    foc  = ip.s ! subjCase ;                      -- who (loves her)
    focType = FocSubj ;
    subj = [] ;
    adj  = vp.adj ! ipa ;
    obj1 = vp.part ++ strComplCase vp.c1 ++ vp.obj1.p1 ! ipa ; ---- appComplCase
    obj2 = strComplCase vp.c2 ++ vp.obj2.p1 ! (case vp.obj2.p2 of {True => ipa ; False => vp.obj1.p2}) ; ---- appComplCase
    c3   = noComplCase ;      -- for one more prep to build ClSlash ---- ever needed for QCl?
    adv  = vp.adv ;
    adV  = vp.adV ;
    ext  = vp.ext ; 
    qforms = qformsVP vp (ipagr2vagr ip.n) ;
    } ;

  QuestSlash x ip cl = 
    let 
      prep = cl.c3 ;
      ips  = ip.s ! objCase ;                     -- in Cl/NP, c3 is the only prep ---- appComplCase for ip
      focobj = case cl.focType of {
        NoFoc => <ips, [], FocObj,prep> ;         -- put ip object to focus  if there is no focus yet
        t     => <[], strComplCase prep ++ ips, t,noComplCase> -- put ip object in situ   if there already is a focus
        } ;
    in 
    cl ** {     -- preposition stranding
      foc     = focobj.p1 ;
      focType = focobj.p3 ;
      obj1    = cl.obj1 ++ focobj.p2 ;     ---- just add to a field?
      c3      = focobj.p4 ; 
      } ;  
{-
---- this is giving four records instead of two AR 5/2/2014 
   |
    cl ** {   -- pied piping
      foc     = focobj.p4 ++ focobj.p1 ;
      focType = focobj.p3 ;
      obj1    = cl.obj1 ++ focobj.p2 ;     ---- just add to a field?
      c3      = noComplCase ; 
      } ;
-}

  QuestIComp a t p icomp np = 
    let vagr = (agr2vagr np.a) in
    initPrClause ** {
    v    = tenseCopula (a.s ++ t.s ++ p.s) t.t a.a p.p vagr ;
    subj = np.s ! subjCase ;
    adV = negAdV p ;
    foc = icomp.s ! agr2icagr np.a ; 
    focType = FocObj ;
    qforms = qformsCopula (a.s ++ t.s ++ p.s) t.t a.a p.p vagr ; 
    } ;

  RelVP rp vp = 
    let 
      cl : Agr -> PrClause = \a -> 
        let rpa = rpagr2agr rp.a a in
        
        vp ** {
        v    = applyVerb vp (agr2vagr rpa) ;
        subj = rp.s ! subjRPCase a ;
        adj  = vp.adj ! rpa ;
        obj1 = vp.part ++ strComplCase vp.c1 ++ vp.obj1.p1 ! rpa ;  ---- apply complCase ---- place of part depends on obj
        obj2 = strComplCase vp.c2 ++ vp.obj2.p1 ! (case vp.obj2.p2 of {True => rpa ; False => vp.obj1.p2}) ;   ---- apply complCase
        c3   = noComplCase ;      -- for one more prep to build ClSlash 
        qforms = qformsVP vp (agr2vagr rpa) ; 
        }
    in {s = \\a => declCl (cl a) ; c = subjCase} ;

  RelSlash rp cl = {
    s = \\a => rp.s ! subjRPCase (rpagr2agr rp.a a) ++ declCl cl ; ---- rp case 
    c = objCase
    } ;

  PrImpSg vp = {s = impVP Sg vp} ;
  PrImpPl vp = {s = impVP Pl vp} ;

  UseCl  cl = {s = declCl cl} ;
  UseQCl cl = {s = questCl cl} ;

  UseAdvCl adv cl = {s = adv.s ++ declInvCl cl} ;

  UttPrS s = s ;


  AdvCl x a cl = case a.isAdV of {
    True  => cl ** {adV = cl.adV ++ a.s ; adv = cl.adv ; c3 = a.c1} ; 
    False => cl ** {adv = cl.adv ++ a.s ; adV = cl.adV ; c3 = a.c1}
    } ;

  AdvQCl x a cl = case a.isAdV of {
    True  => cl ** {adV = cl.adV ++ a.s ; adv = cl.adv ; c3 = a.c1} ; 
    False => cl ** {adv = cl.adv ++ a.s ; adV = cl.adV ; c3 = a.c1}
    } ;

  PresPartAP x v = {            
    s = \\a => vPresPart v a ;
    c1 = v.c1 ;                    -- looking at her
    c2 = v.c2 ;
    obj1 = noObj ;
    } ;

  PastPartAP x v = {
    s = \\a => vPastPart v a ;
    c1 = v.c1 ; 
    c2 = v.c2 ;
    obj1 = noObj ;
    } ;

  AgentPastPartAP x v np = {
    s = \\a => vPastPart v a ;
    c1 = v.c1 ; 
    c2 = v.c2 ;
    obj1 = \\_ => appComplCase agentCase np ; ---- addObj
    } ;

  StartVPC x c v w = {  ---- some loss of quality seems inevitable
    v = \\a => 
          let 
            vv = v.v ! a ; 
            wv = w.v ! a ;
            vpa = vagr2agr a ;
          in 
          vv.p1 ++ v.adV ++ vv.p2 ++ vv.p3 ++ v.adj ! vpa ++ 
          v.c1 ++ v.obj1.p1 ! vpa ++ v.c2 ++ v.obj2.p1 ! vpa ++ v.adv ++ v.ext   ---- appComplCase
            ++ c.s2 ++  
          wv.p1 ++ w.adV ++ wv.p2 ++ wv.p3 ++ w.adj ! vpa ++                ---- appComplCase
          w.c1 ++ w.obj1.p1 ! vpa ++ w.c2 ++ w.obj2.p1 ! vpa ++ w.adv ++ w.ext ;
    inf = \\a => 
            infVP v.vvtype a v ++ c.s2 ++ infVP w.vvtype a w ;
    c1 = noComplCase ; ---- w.c1 ? --- the full story is to unify v and w...
    c2 = noComplCase ; ---- w.c2 ? 
    s1 = c.s1 ;
    } ;

  ContVPC x v w = {  ---- some loss of quality seems inevitable
    v = \\a => 
          let 
            vv = v.v ! a ; 
            wv = w.v ! a ;
            vpa = vagr2agr a ;
          in 
          vv.p1 ++ v.adV ++ vv.p2 ++ vv.p3 ++ v.adj ! vpa ++ 
          v.c1 ++ v.obj1.p1 ! vpa ++ v.c2 ++ v.obj2.p1 ! vpa ++ v.adv ++ v.ext   ---- appComplCase
            ++ "," ++  
          wv ;
    inf = \\a => 
            infVP v.vvtype a v ++ "," ++ w.inf ! a ;
    c1 = noComplCase ; ---- w.c1 ? --- the full story is to unify v and w...
    c2 = noComplCase ; ---- w.c2 ? 
    s1 = w.s1 ;
    } ;

  UseVPC x vpc = initPrVerbPhrase ** { ---- big loss of quality (overgeneration) seems inevitable
    v   = \\a => <[], [], vpc.s1 ++ vpc.v ! a> ;
    inf = \\_ => vpc.inf ! defaultAgr ; ---- agreement
    c1  = vpc.c1 ;
    c2  = vpc.c2 ;
    qforms = \\a => <"do", vpc.inf ! defaultAgr> ; ---- do/does/did
    } ;

  StartClC x c a b = {
    s  = declCl a ++ c.s2 ++ declCl b ;
    c3 = b.c3 ; ---- 
    s1 = c.s1 ;
    } ;

  ContClC x a b = {
    s  = declCl a ++ "," ++ b.s ;
    c3 = b.c3 ; ---- 
    s1 = b.s1 ;
    } ;

  UseClC x cl = initPrClause ** {
    v    = <[],[], cl.s1 ++ cl.s> ; ----
    c3   = cl.c3 ;
    } ;

  ComplAdv x p np = {s = appComplCase p.c1 np ; isAdV = p.isAdV ; c1 = noComplCase} ;

}
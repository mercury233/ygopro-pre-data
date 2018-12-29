--バスター・リブート
--
--Script by mercury233
function c101008070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,101008070)
	e1:SetCost(c101008070.cost)
	e1:SetTarget(c101008070.target)
	e1:SetOperation(c101008070.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101008070+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101008070.tdtg)
	e2:SetOperation(c101008070.tdop)
	c:RegisterEffect(e2)
end
c101008070.card_code_list={80280737}
function c101008070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101008070.cfilter(c,e,tp)
	return c:IsSetCard(0x104f) and Duel.IsExistingMatchingCard(c101008070.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
		and Duel.GetMZoneCount(tp,c)>0
end
function c101008070.spfilter(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0x104f) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE)
end
function c101008070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101008070.cfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c101008070.cfilter,1,1,nil,e,tp)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101008070.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101008070.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c101008070.tdfilter(c,e)
	return not c:IsCode(101008070) and (aux.IsCodeListed(c,80280737) or c:IsCode(80280737)) and c:IsAbleToDeck()
		and (not e or c:IsCanBeEffectTarget(e))
end
function c101008070.tdcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end
function c101008070.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101008070.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101008070.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c101008070.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	local sg=g:SelectSubGroup(tp,c101008070.tdcheck,false,1,#g)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function c101008070.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
